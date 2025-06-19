import 'package:flutter/material.dart';

class GrantPermissionsPage extends StatelessWidget {
  const GrantPermissionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 0, top: 0),
                  child: Image.asset(
                    'assets/satya2_logo.png',
                    height: 180,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 244, 244),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Grant Permissions',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'To build your comprehensive credit risk assessment and credit profile and facilitate quicker loan disbursal, we require the following permissions from you:',
                      style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 88, 87, 87),fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on, color: Color.fromARGB(255, 29, 28, 28)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "To give you the best possible experience, we need access to your device's location. This allows us to show relevant content, services, and features based on where you are. Your location data helps us personalize recommendations and improve the accuracy of our services. We respect your privacy and only use your location with your permission.",
                            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.sms, color: Color.fromARGB(255, 35, 35, 35)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Needs SMS access to read transaction-related messages so we can help you track your expenses, categorize purchases, and provide financial insights. We do not access personal conversations or share your data with third parties. All information is processed securely on your device.',
                            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5 ,fontWeight: FontWeight.normal),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 