import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double size;
  final EdgeInsetsGeometry margin;

  CircleImage({@required this.imageUrl, this.size = 20.0, this.margin});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        margin: margin,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image:
              DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        margin: margin,
        height: size,
        width: size,
        child: Icon(Icons.error_outline),
      ),
    );
  }
}
