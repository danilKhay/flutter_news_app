import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RadiusImage extends StatelessWidget {
  final double height;
  final double widthFactor;
  final double radius;
  final String imageUrl;

  RadiusImage(
      {@required this.imageUrl,
      this.height = 100,
      this.widthFactor = 1,
      this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => FractionallySizedBox(
          widthFactor: widthFactor,
          child: Container(height: height, child: Icon(Icons.error))),
    );
  }
}
