import 'package:flutter/material.dart';
import 'email_otp_service.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Still using for potential login after verification
import 'grant_permissions_page.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isResending = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _isVerifying = true);

    String otp = _otpControllers.map((controller) => controller.text).join();
    
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      setState(() => _isVerifying = false);
      return;
    }

    bool isValid = EmailOTPService.verifyOTP(widget.email, otp);
    
    if (mounted) {
      setState(() => _isVerifying = false);
      if (isValid) {
        // Navigate to the permissions page on successful verification
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const GrantPermissionsPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    setState(() => _isResending = true);
    
    bool success = await EmailOTPService.sendOTP(widget.email);
    
    if (mounted) {
      setState(() => _isResending = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String maskedEmail = widget.email.replaceRange(3, widget.email.indexOf('@'), '******');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Image.asset('assets/satya2_logo.png', height: 60),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Email Verification',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/login_illustration.jpg',
                        height: 48,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'We have sent a 6-digit verification code to your email $maskedEmail',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (i) {
                      return SizedBox(
                        width: 48,
                        child: TextField(
                          controller: _otpControllers[i],
                          focusNode: _focusNodes[i],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.deepOrange),
                            ),
                          ),
                          onChanged: (val) => _onOtpChanged(i, val),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "If you haven't received the code, please check your spam folder.",
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isVerifying ? null : _verifyOTP,
                child: _isVerifying
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Verify Email',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive an OTP? "),
                GestureDetector(
                  onTap: _isResending ? null : _resendOtp,
                  child: Text(
                    'Resend',
                    style: TextStyle(
                      color: _isResending ? Colors.grey : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 