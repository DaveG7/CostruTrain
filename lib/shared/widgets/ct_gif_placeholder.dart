import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CTGifPlaceholder extends StatelessWidget {
  const CTGifPlaceholder({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF242424),
      highlightColor: const Color(0xFF333333),
      child: Container(
        width: width,
        height: height,
        color: const Color(0xFF242424),
      ),
    );
  }
}
