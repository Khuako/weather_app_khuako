import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;
  final BoxFit? boxFit;

  const CustomNetworkImage(
      {super.key, required this.url, this.height, this.width, this.boxFit});

  @override
  Widget build(BuildContext context) {
    try {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: boxFit ?? BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
      );
    } catch (e) {
      return const Placeholder();
    }
  }
}