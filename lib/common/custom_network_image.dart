import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String urls;
  final double? width;
  final double? height;
  final double? borderRadius;

  const CustomNetworkImage({
    super.key,
    required this.urls,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
      child: CachedNetworkImage(
        key: ValueKey(urls),
        imageUrl: urls,
        width: width ?? 70.w,
        height: height ?? 70.h,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: width ?? 90.w,
            height: height ?? 70.h,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) {
          debugPrint("Image load error: $error | URL: $url");
          return CircleAvatar(
            radius: 35.r,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: 35.r, color: Colors.white),
          );
        },
      ),
    );
  }
}
