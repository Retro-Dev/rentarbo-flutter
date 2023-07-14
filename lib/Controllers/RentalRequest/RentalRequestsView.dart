import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controllers/RentRequestDetail.dart';
import '../../Models/RentalRequestsViewModel.dart';

import '../../Extensions/style.dart';
import '../../component/MenuSliderImage.dart';
import '../../component/image_slider.dart';
import '../RentalRequestContentView.dart';



class RentalRequestView extends StatefulWidget {

  static const String route = "RentalRequestView";

  const RentalRequestView({Key? key}) : super(key: key);

  @override
  State<RentalRequestView> createState() => _RentalRequestViewState();
}

class _RentalRequestViewState extends State<RentalRequestView> {
  bool request = false;
  RentalRequestsViewModel rentalRequestsViewModel = RentalRequestsViewModel();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var img = [
      Style.getTempImage("slider-img-4.png"),
      Style.getTempImage("slider-img-4.png"),
      Style.getTempImage("slider-img-4.png")
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          ImageSlider(
            icLeft: Image.asset(
              "src/backimg@3x.png",
              width: 30.w,
            ),
            icRight: SizedBox(
              height: 40.h,
              width: 40.w,
              child: Image.asset(
                Style.getIconImage("ic_chat@2x.png"),
              ),
            ), images: [], isVideoI: [], videosImages: [],
          ),
          Positioned(top: 280, child: RentalRequestContentView()),
        ]),
      ),
    );
  }
}

