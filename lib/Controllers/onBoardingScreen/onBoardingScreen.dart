import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Extensions/style.dart';
import '../../Models/OnboardingViewModel.dart';
import '../../Utils/Const.dart';
import '../../component/custom_button.dart';
import '../login.dart';

class OnBoardingScreen extends StatefulWidget {

  static const String route = "OnBoardingScreen";

  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {

  int index = 0,
      pagechange = 0;
  String btnName = "Next";



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    OnboardingViewModel onboardingViewModel = OnboardingViewModel();


    return Scaffold(
      appBar: AppBar(actions: [
        SizedBox(
            width: 90.w,
            height: 20.h,
            child: IconButton(
              icon: Container(
                width: 90.w,
                height: 30.w,
                decoration: BoxDecoration(
                    color: const Color(0xFFB2B2B2),
                    borderRadius: BorderRadius.all(Radius.circular(30.w))),
                child: Center(
                  child: Text("Skip",
                      textAlign: TextAlign.center,
                      style:
                      Style.getSemiBoldFont(16.sp, color: Colors.white)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Login.route, (route) => false);
              },
            ))
      ]),
      backgroundColor: Colors.white,
      body: OnboardingBody(onboardingViewModel),
    );
  }


  Widget OnboardingBody(OnboardingViewModel onboardingViewModel) {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  controller: onboardingViewModel.getController(),
                  onPageChanged: (int index1) {





                    if (index1 == 0) {
                      onboardingViewModel.changePage(0);
                      btnName = "Next";
                    }else if (index1 == 1) {
                      onboardingViewModel.changePage(1);
                      btnName = "Next";
                    }else if (index1 == 2) {
                      btnName = "Get Started";
                      onboardingViewModel.changePage(2);
                    }else {
                     index = -1;
                    }
                    if(mounted) {
                      setState((){});
                    }

                    //
                  },
                  itemBuilder: (context, index2) {
                    index = index2;
                    Size imageSize = onboardingViewModel.getImageSizeFor(index);
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: SizedBox(
                              width: imageSize.width,
                              height: imageSize.height,
                              child: Image.asset(
                                Style.getCommonImage(
                                    onboardingViewModel.getImageNameFor(index)),
                                fit: BoxFit.contain,
                              ),
                            )),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Text(
                            onboardingViewModel.getCaptionFor(index),
                            style: Style.getSemiBoldFont(16.sp,
                                color: Style.textBlackColor),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
             CustomButton(
              btnText: btnName,
              width: 345.w,
              height: 54.w,
              radius: 30.w,
              fontSize: 18.sp,
              fontstyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                fontFamily: Const.aventa,
                fontStyle: FontStyle.normal,
                fontSize: 18.sp,
              ),
              onPressed: () {


                index = index + 1;

                if (index == 0) {
                  onboardingViewModel.changePage(0);
                  btnName = "Next";
                }else if (index == 1) {
                  onboardingViewModel.changePage(1);
                  btnName = "Next";
                }else if (index == 2) {
                  btnName = "Get Started";
                  onboardingViewModel.changePage(2);
                }else {
                  index = -1;
                  Navigator.pushNamedAndRemoveUntil(context, Login.route, (route) => false);
                }






                if(mounted) {
                  setState((){});
                }

              },
            ),
            SizedBox(height: 80.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                    (index) => buildDot(onboardingViewModel, index, context),
              ),
            ),
            SizedBox(height: 50.h)
          ],
        ),
      ),
    );
  }

  GestureDetector buildDot(OnboardingViewModel viewModel, int index1,
      BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {



        if (index1 == 0) {
          viewModel.changePage(0);
          btnName = "Next";
        }else if (index1 == 1) {
          viewModel.changePage(1);
          btnName = "Next";
        }else if (index1 == 2) {
          btnName = "Get Started";
          viewModel.changePage(2);
        }else {
          index = -1;
        }

         if(mounted) {
           setState((){});
         }

       //
      },
      child: Container(
        height: 8.w,
        width: 8.w,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: index1 == index
              ? const Color(0xFF707070)
              : const Color(0xFF707070).withOpacity(0.5),
        ),
      ),
    );
  }

}