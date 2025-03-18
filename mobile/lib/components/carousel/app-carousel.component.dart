import 'package:flutter/cupertino.dart';
import 'package:rimpa/components/imageloader/app-image.component.dart';
import 'package:rimpa/core/constant/app.constant.dart';

class AppCarousel extends StatefulWidget {
  final AppImageType imageSrc;
  final List<String> images;
  final double ratio;
  final BorderRadius borderRadius;
  final BoxFit fit;
  final double indicatorBottomSpace;

  const AppCarousel({
    super.key,
    required this.imageSrc,
    required this.images,
    this.ratio = 1 / 1,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.fit = BoxFit.cover,
    this.indicatorBottomSpace = 0,
  });

  @override
  _AppCarouselState createState() => _AppCarouselState();
}

class _AppCarouselState extends State<AppCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      int nextPage = _currentIndex + 1 < widget.images.length ? _currentIndex + 1 : 0;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
      setState(() => _currentIndex = nextPage);
      _startAutoSlide();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: widget.ratio,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _currentIndex = value),
            itemBuilder: (context, index) {
              return AppImageComponent(
                imageType: widget.imageSrc,
                imageAddress: widget.images[index],
                aspectRatio: widget.ratio,
                fit: widget.fit,
                borderRadius: widget.borderRadius,
              );
            },
          ),
        ),
        Positioned(
          bottom: widget.indicatorBottomSpace,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Container(
                  width: 25,
                  height: 5,
                  decoration: BoxDecoration(
                    color: _currentIndex == index ? AppColors.primary : AppColors.secondary,
                    borderRadius: BorderRadius.circular(AppRadius.rounded),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
