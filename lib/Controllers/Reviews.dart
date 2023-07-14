import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/Models/ReviewModel.dart';
import 'package:rentarbo_flutter/Utils/Ads_services.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Extensions/style.dart';
import '../Utils/Const.dart';

class Reviews extends StatefulWidget {
  static const String route = "Reviews";
  String? reviewsAvg;
  String? reviewsCount;
  int? product_id;
  Reviews({ this.product_id});
  GlobalKey? requestUpdate = GlobalKey();
  @override
  State<Reviews> createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {

  List<ReviewDatum>? reviews;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jsonParam = {
      "product_id":"${widget.product_id ?? 0}",

    };
    showLoading();
    getComments(jsonData: jsonParam, onSuccess: (data) {
      if (data.isEmpty) {
        hideLoading();
        toast("Record not found.");
      }else {
        hideLoading();
        setState(() {
          reviews = data;
        });
      }


    }, onError: (data){
      hideLoading();
      toast(data);


    });
  }

  showMonth(int value) {
    switch(value) {
      case 1:
       return "January";

      case 2:
        return "February";

      case 3:
        return "March";

      case 4:
        return "April";

      case 5:
        return "May";

      case 6:
        return "June";

      case 7:
        return "July";
        
      case 8:
        return "August";
        
      case 9:
        return "September";
        
      case 10:
        return "Octuber";
        
      case 11:
        return "November";
        
      case 12:
        return "December";

    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Reviews",
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
      body: ListView(

        children: [
          SizedBox(height: 10.h,),
          Row(
            children: [
              SizedBox(width: 16.w,),
              Image.asset("src/star@3x.png" , height: 12.h , width: 12.w,),
              SizedBox(width: 8.w,),
              Text("${reviews?.first.product?.rating ?? 0}" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp ,fontWeight: FontWeight.w600),),
              SizedBox(width: 8.w,),
              Container(
                width: 1,
                height: 22,
                color: Colors.grey.withAlpha(80),
              ),
              SizedBox(width: 8.w,),
              Image.asset("src/bubble-chat.png" , height: 12.h , width: 12.w,),
              SizedBox(width: 8.w,),
              Text("${reviews?.first.product?.reviews ?? 0}" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp ,fontWeight: FontWeight.w600),),
              SizedBox(width: 8.0,),
              Text("Reviews" ,style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp ,fontWeight: FontWeight.w600, color: Colors.grey) ),

            ],
          ),
          SizedBox(height: 10.h,),
          Container(
            margin: EdgeInsets.only(left: 16.w , right: 16.w),
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey.withAlpha(80),
          ),
          SizedBox(height: 8.h,),
          ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.only(left: 10.w , right: 10.w , top: 10.h) ,
                  margin: EdgeInsets.only(left: 15.w  ,right: 16.w),
                  // 200pt × 148pt

                  // height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 0.2,
                        blurRadius: 0.5,
                        offset: Offset(-0.1, 0.1), // changes position of shadow
                      ),
                    ],

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(height: 10.h,),
                          Container(
                            width: 44.0,
                            height: 44.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: FadeInImage(
                                // height: 50,
                                // width: 50,
                                  fadeInDuration: const Duration(milliseconds: 500),
                                  fadeInCurve: Curves.easeInExpo,
                                  fadeOutCurve: Curves.easeOutExpo,
                                  placeholder: AssetImage("src/placeholder.png"),
                                  image: NetworkImage(reviews?[index].user?.imageUrl ?? Const.IMG_DEFUALT,
                                      scale: 3.5),
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return Container(
                                        child: Image.asset("src/placeholder.png"));
                                  },
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(reviews?[index].user?.name ?? "" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp , fontWeight: FontWeight.w600),),
                                  SizedBox(width: 3.w,),
                                  Image.asset("src/star@3x.png" , height: 12.h , width: 12.w,),
                                  SizedBox(width: 3.w,),
                                  Text("${reviews?[index].rating ?? 0}" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 14.sp , fontWeight: FontWeight.w600),),
                                ],
                              ),
                              Text( "${showMonth(reviews?[index].createdAt?.month ?? 0)} " + "${reviews?[index].createdAt?.year}" , style: TextStyle(fontFamily: Const.aventaBold , fontSize: 12.sp , color: Colors.grey),)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20.h,),
                      Text("${reviews?[index].comment}" , style: TextStyle(fontFamily: Const.aventa , fontSize: 14.sp),),
                     SizedBox(height: 10.h,)
                    ],
                  )
                );
              },
              separatorBuilder: (context, index) => SizedBox(
                height: 15.h,
              ),
              itemCount: reviews?.length ?? 0),
        ],
      ),
    );
  }

}