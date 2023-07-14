import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/Models/Earning.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Controllers/LinearGraphView.dart';
import '../Extensions/style.dart';
import '../Utils/BookingAds.dart';


class MyEarning extends StatefulWidget {
  static const String route = "MyEarning";
  const MyEarning({Key? key}) : super(key: key);

  @override
  State<MyEarning> createState() => _MyEarningState();
}

class _MyEarningState extends State<MyEarning> {

  List<Color> gradientColors = [
    Color.fromRGBO(234, 54, 63, 1),
    Color.fromRGBO(255, 155, 177, 1)

  ];

  Earning? earn;
  Widget graph = SizedBox(height: 50.h,width: 50.w,);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoading();
   getEarning(jsonData: {}, slug: "", onSuccess: (data){
     setState((){
       if (data.earn?.total == null || data.earn?.graphData == [] ) {
         toast("Data not found.");
       }else {
         earn = data;
         graph = LinearGraphView(aspectRatio: 1.02,earn: earn,);
       }

     });

     hideLoading();
   }, onError: (error){
     toast(error);
     hideLoading();
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "My Earning",
          textAlign: TextAlign.start,
          style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
        ),
        leading: IconButton(
          icon: SizedBox(
              width: 24.w,
              height: 24.w,
              child: Image.asset(
                "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Style.textWhiteColor,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total earning",
                            style: Style.getSemiBoldFont(14.sp,
                                color: Style.textBlackColorOpacity80),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "\$${earn?.earn?.total ?? "0"}",
                            style: Style.getBoldFont(
                              26,
                            ),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            graph!,
          ],
        ),
      ),
    );
  }
}
