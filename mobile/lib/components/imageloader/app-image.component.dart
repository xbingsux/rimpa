import 'package:flutter/cupertino.dart';
import 'package:rimpa/core/constant/app.constant.dart';

enum AppImageType {
  network,
  assets
}

class AppImageComponent extends StatelessWidget {
  final AppImageType imageType;
  final String imageAddress;
  final double aspectRatio;
  final BorderRadius borderRadius;
  final BoxFit fit;
  const AppImageComponent(
    {
      super.key, 
      required this.imageType,
      required this.imageAddress, 
      this.aspectRatio = 1 / 1, 
      this.borderRadius = const BorderRadius.all(Radius.circular(AppRadius.xs)), 
      this.fit = BoxFit.cover
    }
  );

  @override
  Widget build(BuildContext context) {
    return imageType == AppImageType.assets ? imageAssets() : imageNetwork();
  }

  Widget imageAssets() {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.asset(imageAddress, fit: fit,),
      ), 
    );
  }

  Widget imageNetwork() {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(imageAddress, fit: fit,),
      ), 
    );
  }
}