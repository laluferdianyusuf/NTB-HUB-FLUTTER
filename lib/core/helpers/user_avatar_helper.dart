abstract final class UserAvatarHelper {
  static const _background = '51BC86';
  static const _color = 'fff';

  static String fallbackUrl(String name) {
    final displayName = name.trim().isNotEmpty ? name.trim() : 'User';
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=$_background&color=$_color';
  }

  static String resolveUrl({required String name, String? imageUrl}) {
    if (imageUrl != null && imageUrl.trim().isNotEmpty) {
      return imageUrl.trim();
    }
    return fallbackUrl(name);
  }
}
