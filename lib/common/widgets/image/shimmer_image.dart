/*
 * @ Author: Chung Nguyen Thanh <chunhthanhde.dev@gmail.com>
 * @ Created: 2024-12-22 08:15:32
 * @ Message: 🎯 Happy coding and Have a nice day! 🌤️
 */

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shimmer/shimmer.dart';

/// A widget that displays an image with a shimmer loading effect.
/// - If the image is still loading, a shimmering placeholder is shown.
/// - Once loaded, the image replaces the placeholder.
class ShimmerImage extends StatelessWidget {
  /// The URL of the image to be displayed.
  final String url;

  /// Determines how the image should be fitted inside its container.
  final BoxFit fit;

  /// The width of the image when `aspectRatio` is not provided.
  final double width;

  /// The height of the image when `aspectRatio` is not provided.
  final double height;

  /// Optional aspect ratio to control the image's width-to-height ratio.
  /// - If `aspectRatio` is greater than 0, it takes priority over `width` and `height`.
  final double aspectRatio;

  /// The size of the placeholder icon when the image is loading.
  final double iconHolderSize;
  const ShimmerImage({
    super.key,
    required this.url,
    required this.fit,
    this.width = 16,
    this.height = 16,
    this.aspectRatio = 0,
    this.iconHolderSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /// The shimmer effect that acts as a placeholder while the image loads.
        Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[100]!,
          child:
              aspectRatio != 0
                  ? AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(child: _buildIcon()),
                  )
                  : SizedBox(width: width, height: height, child: _buildIcon()),
        ),

        /// The actual image fetched from the provided `url`.
        /// - Uses an `AspectRatio` if provided,
        /// otherwise it follows `width` and `height`.
        aspectRatio != 0
            ? AspectRatio(
                aspectRatio: aspectRatio,
                child: Image.network(
                  _corsSafeUrl(url),
                  fit: fit,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey[200], child: _buildIcon());
                  },
                ),
              )
            : Image.network(
                _corsSafeUrl(url),
                width: width,
                height: height,
                fit: fit,
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Colors.grey[200], child: _buildIcon());
                },
              ),
      ],
    );
  }

  _buildIcon() {
    return Center(
      child: Icon(Icons.crop_original, color: Colors.red, size: iconHolderSize),
    );
  }

  String _corsSafeUrl(String original) {
    if (!kIsWeb) return original;
    final uri = Uri.tryParse(original);
    if (uri == null) return original;
    final isHttp = uri.scheme == 'http' || uri.scheme == 'https';
    if (!isHttp) return original;
    // Always proxy external http/https images on web to avoid CORS/SSL issues.
    // The local dev server exposes /img to fetch and stream the image with permissive CORS.
    final encoded = Uri.encodeComponent(original);
    return 'http://localhost:3000/img?url=$encoded';
  }
}
