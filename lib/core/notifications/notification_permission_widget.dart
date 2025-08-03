import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'simple_notification_service.dart';

class NotificationPermissionWidget extends StatefulWidget {
  final Widget child;
  
  const NotificationPermissionWidget({
    super.key,
    required this.child,
  });

  @override
  State<NotificationPermissionWidget> createState() => _NotificationPermissionWidgetState();
}

class _NotificationPermissionWidgetState extends State<NotificationPermissionWidget> {
  bool _hasPermission = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _hasPermission = status.isGranted;
      _isChecking = false;
    });
  }

  Future<void> _requestPermission() async {
    final status = await Permission.notification.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
    
    if (status.isGranted) {
      // Re-initialize notification service with permissions
      await simpleNotificationService.initialize();
      
      if (mounted) {
        // Use post-frame callback to avoid calling showSnackBar during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notification permissions granted!'),
              backgroundColor: Colors.green,
            ),
          );
        });
      }
    } else {
      if (mounted) {
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission Required'),
        content: const Text(
          'To receive important updates and notifications, please enable notification permissions in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return widget.child;
    }

    if (_hasPermission) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.notifications, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enable Notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const Text(
                        'Stay updated with important information',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _requestPermission,
                  child: const Text('Enable'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 