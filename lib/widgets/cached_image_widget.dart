import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageWidget extends StatelessWidget {
  final String imageUrl;
  const CachedImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // progressIndicatorBuilder: (context, url, downloadProgress) => const LoadingWidget(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.fitWidth,
    );
  }
}
