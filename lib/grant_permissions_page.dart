import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'loan_type_selection_page.dart';
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoanTypeSelectionPage()),
      );
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