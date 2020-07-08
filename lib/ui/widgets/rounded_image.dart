import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/ui/widgets/loading_widget.dart';

class RoundedImage extends StatelessWidget {
  final double size;
  final String imageUrl;
  final EdgeInsetsGeometry margin;
  final double radius;

  const RoundedImage(
      {this.size = 80.0,
      this.imageUrl,
      this.margin = const EdgeInsets.all(8),
      this.radius = 4.0});

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          margin: margin,
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill,
            ),
          ),
        ),
        placeholder: (context, url) => Container(
            margin: margin, height: size, width: size, child: LoadingWidget()),
        errorWidget: (context, url, error) => _error(),
      );
    } else {
      return _error();
    }
  }

  Widget _error() {
    return Container(
      margin: margin,
      height: size,
      width: size,
      child: Icon(Icons.error_outline),
    );
  }
}
