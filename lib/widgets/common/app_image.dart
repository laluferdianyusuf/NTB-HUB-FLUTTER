import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Displays a local asset or remote URL image.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorIcon = Icons.image_outlined,
  });

  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final IconData errorIcon;

  static bool isAsset(String source) => source.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final child = isAsset(source) ? _assetImage() : _networkImage();

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _assetImage() {
    return Image.asset(
      source,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _errorBox(),
    );
  }

  Widget _networkImage() {
    return CachedNetworkImage(
      imageUrl: source,
      fit: fit,
      width: width,
      height: height,
      placeholder: (_, __) => placeholder ?? _loadingBox(),
      errorWidget: (_, __, ___) => _errorBox(),
    );
  }

  Widget _loadingBox() {
    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }

  Widget _errorBox() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade200,
      child: Center(child: Icon(errorIcon, color: Colors.grey.shade500)),
    );
  }
}
