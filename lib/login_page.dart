import 'package:flutter/material.dart';
import 'otp_verification_page.dart';
import 'email_otp_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _agreed = true;
  bool _isLoading = false;

  Future<void> _sendOTP(String email) async {
    setState(() => _isLoading = true);

    bool success = await EmailOTPService.sendOTP(email);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationPage(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send OTP. Please check your credentials and network.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/satya2_logo.png',
                  height: 150,
                  width: 200,
                ),
              ),

              // Card Container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Heading and Image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Let's Get Started!",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                "Please enter your email address and we will send an OTP for verification",
                                style: TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          'assets/login_illustration.jpg',
                          height: 60,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Email input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.email_outlined, color: Colors.grey),
                          ),
                          Container(
                            height: 32,
                            width: 1.2,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email address',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Terms & checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreed,
                          onChanged: (val) {
                            setState(() {
                              _agreed = val ?? false;
                            });
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                        Expanded(
                          child: Wrap(
                            children: [
                              const Text("By Signing up, you agree to the "),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "Terms of Service",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              const Text(" and "),
                              GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  "Privacy Policy",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () {
                          String email = _emailController.text.trim();
                          if (_isValidEmail(email) && _agreed) {
                            _sendOTP(email);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please enter a valid email and agree to the terms.')),
                            );
                          }
                        },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Send OTP",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
