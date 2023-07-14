import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MenuSliderImage extends StatelessWidget {
  final Widget? icRight;
  final Widget? icLeft;
  final VoidCallback? onPressed;
  const MenuSliderImage({Key? key, this.icLeft, this.icRight, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    var img = [
      Style.getTempImage("slider-img-2.png"),
      Style.getTempImage("slider-img-3.png"),
      Style.getTempImage("slider-img-4.png")
    ];
    return Stack(alignment: Alignment.topCenter, children: [
      CarouselSlider(
        options: CarouselOptions(
          height: 350.0,
          enlargeCenterPage: false,
          viewportFraction: 1,
          onPageChanged: (position, reason) {
            debugPrint(reason.toString());
            print(CarouselPageChangedReason.controller);
          },
          enableInfiniteScroll: false,
        ),
        items: img.map<Widget>((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          i,
                        ),
                        fit: BoxFit.fill,
                      )));
            },
          );
        }).toList(),
      ),
      Positioned(
        bottom: 80,
        child: SmoothPageIndicator(
          controller: controller,
          count: 3,
          axisDirection: Axis.horizontal,
          effect: const SlideEffect(
            activeDotColor: Colors.white54,
            dotHeight: 8,
            dotColor: Colors.white,
            dotWidth: 8,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 50.0, right: 15, left: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: SizedBox(width: 30.w, height: 30.h, child: icLeft)),
            GestureDetector(
              onTap: onPressed,
              child: icRight,
            ),
          ],
        ),
      ),
    ]);
  }
}

