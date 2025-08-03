import 'package:hready/core/network/api_base.dart';

class ProfilePictureUtils {
  static String resolveProfilePicture(String? picture) {
    if (picture == null || picture.isEmpty) return 'assets/images/profile.webp';
    
    // If it's already a full URL (Cloudinary), return it directly
    if (picture.startsWith('http')) return picture;
    
    // If it's a local path (legacy), try to construct the full URL
    if (picture.startsWith('/uploads')) {
      final base = apiBaseUrl.replaceAll('/api', '');
      final apiPath = '$base/api$picture';
      final directPath = '$base$picture';
      print('Legacy path detected, trying: $apiPath');
      return apiPath;
    }
    
    return 'assets/images/profile.webp';
  }
} 