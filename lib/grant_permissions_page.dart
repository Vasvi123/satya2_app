import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class GrantPermissionsPage extends StatelessWidget {
  const GrantPermissionsPage({Key? key}) : super(key: key);

  Future<void> _requestPermissions(BuildContext context) async {
    // Request multiple permissions at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.photos, // For photo access
      Permission.videos, // For video access
    ].request();

    // Check the status of each permission
    final locationStatus = statuses[Permission.location];
    final cameraStatus = statuses[Permission.camera];
    final photosStatus = statuses[Permission.photos];
    final videosStatus = statuses[Permission.videos];

    // On modern Android, videos and photos are often granted together.
    // We'll consider it a success if both are granted, or if one is granted and the other is not applicable.
    if (locationStatus == PermissionStatus.granted &&
        cameraStatus == PermissionStatus.granted &&
        (photosStatus == PermissionStatus.granted || photosStatus == PermissionStatus.limited) &&
        (videosStatus == PermissionStatus.granted || videosStatus == PermissionStatus.limited)) {
      // All permissions granted, navigate to the main app screen
      _showSnackBar(context, 'All permissions granted!', Colors.green);
      // TODO: Navigator.of(context).pushReplacementNamed('/home');
    } else {
      // Handle the case where some permissions were denied
      _showSnackBar(context, 'Some permissions were denied. Please grant all permissions to continue.', Colors.orange);
      // Optionally, open app settings to let the user grant them manually
      // openAppSettings();
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
              const Text(
                'Permissions Required',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'To provide you with the best experience, we need access to your device\'s location, camera, and storage.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              _buildPermissionItem(Icons.location_on, 'Location', 'For location-based services.'),
              _buildPermissionItem(Icons.camera_alt, 'Camera', 'To capture photos and videos.'),
              _buildPermissionItem(Icons.photo_library, 'Photos & Videos', 'To save and access media.'),
              const Spacer(),
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
                  onPressed: () => _requestPermissions(context),
                  child: const Text(
                    'Grant Permissions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 40),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 