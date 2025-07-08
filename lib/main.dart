import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'grant_permissions_page.dart';
import 'loan_type_selection_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Widget? _home;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _determineStartPage();
  }

  Future<void> _determineStartPage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _home = const LoginPage());
    } else {
      if (await _allPermissionsGranted()) {
        setState(() => _home = const LoanTypeSelectionPage());
      } else {
        setState(() => _home = const GrantPermissionsPage());
      }
    }
  }

  Future<bool> _allPermissionsGranted() async {
    List<Permission> permissions = [
      Permission.location,
      Permission.camera,
      Permission.photos,
      Permission.videos,
    ];
    if (Platform.isAndroid) {
      int sdkInt = 33; // Default for emulator; use device_info_plus for real version
      try {
        // Optionally, use device_info_plus for actual version
      } catch (_) {}
      if (sdkInt < 30) {
        permissions.add(Permission.storage);
      }
    }
    final statuses = await permissions.request();
    final storageGranted = statuses[Permission.storage] == null || statuses[Permission.storage] == PermissionStatus.granted;
    return (statuses[Permission.location] == PermissionStatus.granted &&
            statuses[Permission.camera] == PermissionStatus.granted &&
            (statuses[Permission.photos] == PermissionStatus.granted || statuses[Permission.photos] == PermissionStatus.limited) &&
            (statuses[Permission.videos] == PermissionStatus.granted || statuses[Permission.videos] == PermissionStatus.limited) &&
            storageGranted);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KYCsaathi',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[50],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: Colors.deepPurple,
          secondary: Colors.blueAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Button text color
            backgroundColor: Colors.deepPurple, // Button background color
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple, // Text button color
          ),
        ),
      ),
      home: _home ?? const SplashScreen(),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/satya2_logo.png',
          width: MediaQuery.of(context).size.width * 0.6,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}