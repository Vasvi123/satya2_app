import 'dart:math';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class EmailOTPService {
  // WARNING: Storing credentials in your app is insecure.
  // This is for development/testing purposes only.
  // In production, use a backend server to handle email sending.
  static final String _username = 'satya2.app@gmail.com'; // TODO: Replace with your email
  static final String _password = 'wcoj fzvd shoc desb';   // TODO: Replace with your Gmail App Password

  // In-memory store for OTPs. In production, use a secure backend database.
  static final Map<String, String> _otpStore = {};

  /// Generates a 6-digit OTP
  static String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  /// Sends an OTP to the given email address
  static Future<bool> sendOTP(String email) async {
    final otp = _generateOTP();
    final smtpServer = gmail(_username, _password);

    final message = Message()
      ..from = Address(_username, 'Satya2 App')
      ..recipients.add(email)
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP for Satya2 App is: $otp\nThis code is valid for 10 minutes.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
      
      // Store the OTP for verification
      _otpStore[email] = otp;
      
      return true;
    } on MailerException catch (e) {
      print('Message not sent. Error: $e');
      // Look for specific errors
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }

  /// Verifies the OTP entered by the user
  static bool verifyOTP(String email, String userOtp) {
    if (_otpStore.containsKey(email) && _otpStore[email] == userOtp) {
      // OTP is correct, remove it after verification
      _otpStore.remove(email);
      return true;
    }
    return false;
  }
} 