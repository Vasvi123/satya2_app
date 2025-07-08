import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'loan_type_selection_page.dart';
import 'dart:io';

class GrantPermissionsPage extends StatefulWidget {
  const GrantPermissionsPage({super.key});

  @override
  State<GrantPermissionsPage> createState() => _GrantPermissionsPageState();
}

class _GrantPermissionsPageState extends State<GrantPermissionsPage> {
  bool showStorage = false;
  int sdkInt = 33; // Default for emulator; use device_info_plus for real version

  @override
  void initState() {
    super.initState();
    // Optionally, use device_info_plus to get real SDK version
    // setState(() { sdkInt = ... });
    if (Platform.isAndroid && sdkInt < 30) {
      showStorage = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On page load, if all permissions are already granted, skip to main app
    _checkAndSkipIfPermissionsGranted();
  }

  Future<void> _checkAndSkipIfPermissionsGranted() async {
    List<Permission> permissions = [
      Permission.location,
      Permission.camera,
      Permission.photos,
      Permission.videos,
    ];
    if (showStorage) {
      permissions.add(Permission.storage);
    }
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    final locationStatus = statuses[Permission.location];
    final cameraStatus = statuses[Permission.camera];
    final photosStatus = statuses[Permission.photos];
    final videosStatus = statuses[Permission.videos];
    final storageStatus = statuses[Permission.storage];
    if (locationStatus == PermissionStatus.granted &&
        cameraStatus == PermissionStatus.granted &&
        (photosStatus == PermissionStatus.granted || photosStatus == PermissionStatus.limited) &&
        (videosStatus == PermissionStatus.granted || videosStatus == PermissionStatus.limited) &&
        (!showStorage || storageStatus == PermissionStatus.granted)) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoanTypeSelectionPage()),
        );
      });
    }
  }

  Future<void> _requestPermissions(BuildContext context) async {
    List<Permission> permissions = [
      Permission.location,
      Permission.camera,
      Permission.photos, // For photo access
      Permission.videos, // For video access
    ];
    if (showStorage) {
      permissions.add(Permission.storage);
    }
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    final locationStatus = statuses[Permission.location];
    final cameraStatus = statuses[Permission.camera];
    final photosStatus = statuses[Permission.photos];
    final videosStatus = statuses[Permission.videos];
    final storageStatus = statuses[Permission.storage];

    if (locationStatus == PermissionStatus.granted &&
        cameraStatus == PermissionStatus.granted &&
        (photosStatus == PermissionStatus.granted || photosStatus == PermissionStatus.limited) &&
        (videosStatus == PermissionStatus.granted || videosStatus == PermissionStatus.limited) &&
        (!showStorage || storageStatus == PermissionStatus.granted)) {
      // All permissions granted, navigate to the main app screen
      _showSnackBar(context, 'All permissions granted!', Colors.green);
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoanTypeSelectionPage()),
        );
      });
    } else {
      // Handle the case where some permissions were denied
      _showSnackBar(context, 'Some permissions were denied. Please grant all permissions to continue.', Colors.orange);
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/satya2_logo.png', height: 80),
              const SizedBox(height: 40),
              Text(
                'Permissions Required',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[700],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'For the best experience, please grant the following permissions:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildPermissionItem(
                icon: Icons.location_on,
                title: 'Location',
                subtitle: 'To provide location-based services.',
                color: Colors.blueAccent,
              ),
              _buildPermissionItem(
                icon: Icons.camera_alt,
                title: 'Camera',
                subtitle: 'To capture photos and videos.',
                color: Colors.blueAccent,
              ),
              _buildPermissionItem(
                icon: Icons.photo_library,
                title: 'Photos & Videos',
                subtitle: 'To access your media library.',
                color: Colors.blueAccent,
              ),
              if (showStorage)
                _buildPermissionItem(
                  icon: Icons.folder,
                  title: 'Storage',
                  subtitle: 'To access and upload documents from your device.',
                  color: Colors.blueAccent,
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _requestPermissions(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Grant Permissions',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, size: 28, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
    );
  }
} 