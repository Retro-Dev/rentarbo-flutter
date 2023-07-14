import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../Extensions/style.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';
import '../component/image_slider.dart';
import 'Dashboard.dart';

class PostAdReview extends StatefulWidget {
  static const String route = "PostAdReview";
  GlobalKey productUpdateKey = GlobalKey();
  // const PostAdReview({Key? key}) : super(key: key);

  String? pTitle,
      pCategory,
      pDescription,
      pfacilities,
      pCharges,
      pPickUpLocation,
      pDropOffLocation,
      pSSNNo,
      pDriverLisenceNumber,
      pIDCardNo,pRentPerHour;
  int? pcategoryId;

  double? pPickUpLocationlat,
      pPickUpLocationlng,
      pDropOffLocationlat,
      pDropOffLocationlong;

  bool? demoRequested;

  late TextfieldTagsController _controller;

  List<String> tags ;
  List<File?> images = [];
  List<File?>? videosImage = [];
  List<bool>? isVideoI;
  GlobalKey productUpdate = GlobalKey();
  PostAdReview(
      {this.pTitle,
      this.pCategory,
      this.pDescription,
      required this.tags,
      this.pRentPerHour,
      this.pCharges,
      this.pPickUpLocation,
      this.pDropOffLocation,
      this.pSSNNo,
      this.pDriverLisenceNumber,
      this.pIDCardNo,
      this.pPickUpLocationlat,
      this.pPickUpLocationlng,
      this.pDropOffLocationlong,
      this.pDropOffLocationlat,
      required this.images,
        required this.videosImage,
      this.pcategoryId ,this.demoRequested , required this.productUpdate , this.isVideoI});

  @override
  _PostAdReviewState createState() => _PostAdReviewState();
}

class _PostAdReviewState extends State<PostAdReview> {
  late BuildContext _context;
  List<Map<String,dynamic>>? imageFiles = [];
  List<File?> images = [];
  List<File?>? videosImagess = [];
  List<bool>? isVideoI = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    images = [];
    videosImagess = [];
    isVideoI = [];
  }


  Widget? imageslider = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = widget.images;
    videosImagess = widget.videosImage;
    isVideoI = widget.isVideoI;
   imageslider =  ImageSlider(
      isFromCreatePost: true,
      isFromMyAds: false,
      images: images!,
      icLeft:  InkWell(
        onTap: () {
          Map<String, dynamic> imagesVides = {"images" : widget.images , "videos" : widget.videosImage , "isVideo" : widget.isVideoI};
          Navigator.pop(context, imagesVides);
        },
        child: Container(
          width:  50,
          height: 50,
          child: Icon(Icons.arrow_back , color: Colors.black,),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.h),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 12,
                offset: Offset(-1, 1), // Shadow position
              ),
            ],
          ),
        ),
      ),
      icRight: Container(
        width: 40.w,
        height: 35.h,

      ),
      onPressed: () {
      }, isVideoI:isVideoI!, videosImages: videosImagess! ,
    );
   setState((){});
  }
  
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
       imageslider!,
          Positioned(
              top: 280,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 300 ,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.pTitle ?? ""}",
                            style: Style.getBoldFont(
                              22.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${widget.pCategory ?? ""}",
                            style: Style.getBoldFont(16.sp,
                                color: Style.textBlackColorOpacity80),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                              children :[
                                Text(
                                  "\$${widget.pCharges ?? ""}\/${productType(widget.pRentPerHour ?? "")}",
                                  style: TextStyle(fontFamily: Const.aventa , fontSize: 20.sp , fontWeight: FontWeight.w900,color: Style.redColor),
                                ),


                            ]

                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Description",
                            style: Style.getBoldFont(
                              14.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.pDescription ?? ""}",
                            textAlign: TextAlign.justify,
                            style: Style.getMediumFont(
                              12.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Facilities",
                            style: Style.getBoldFont(
                              14.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 5,
                            children: [
                              for (var values in widget!.tags!)
                                facilitiesView("${values}"),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Pick-up Location",
                            style: Style.getBoldFont(
                              14.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.pPickUpLocation ?? ""}",
                            textAlign: TextAlign.justify,
                            style: Style.getMediumFont(
                              12.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Drop-off Location",
                            style: Style.getBoldFont(
                              14.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.pDropOffLocation ?? ""}",
                            textAlign: TextAlign.justify,
                            style: Style.getMediumFont(
                              12.sp,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if(widget.demoRequested!)
                          facilitiesView("Hosting & Demonstration Required"),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // CustomButton(
                              //     btnText: "Cancel",
                              //     color: Style.btnGreyColor,
                              //     onPressed: () {
                              //       scrollController.jumpTo(0.0);
                              //       Navigator.pop(context);
                              //     }),
                              // MyButton(
                              //   onPress: () {
                              //     Navigator.pop(context);
                              //   },
                              //   text: "Cancel",
                              //   color: Style.btnGreyColor,
                              //   width: MediaQuery.of(context).size.width / 2.3,
                              // ),
                              CustomOutlineButton(
                                  btnText: "Cancel",
                                  radius: 25.w,
                                  height: 50.w,
                                  width: 150.w,
                                  fontSize: 12.sp,
                                  fontstyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.sp,
                                  ),
                                  onPressed: () {
                                    Map<String, dynamic> imagesVides = {"images" : widget.images , "videos" : widget.videosImage , "isVideo" : widget.isVideoI};
                                    Navigator.pop(context, imagesVides);
                                  }),
                              const SizedBox(
                                width: 15,
                              ),
                              CustomButton(
                                  btnText: "Proceed",
                                  radius: 25.w,
                                  height: 50.w,
                                  width: 150.w,
                                  fontSize: 12.sp,
                                  fontstyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 18.sp,
                                  ),
                                  onPressed: () {
                                    Map<String, String>? jsonnew = {"":""};
                                    var count = 0;
                                    jsonnew.remove("");
                                    for (var values in widget.tags){

                                      jsonnew!["tags[$count]"] = widget.tags[count];
                                      count = count + 1;
                                    }

                                    var jsonParam = { "category_id":"${widget.pcategoryId}",
                                      "name":"${widget.pTitle}",
                                      "description": "${widget.pDescription}",
                                      "rent_type":"${productType(widget.pRentPerHour)}",
                                      "rent_charges":"${widget.pCharges}",
                                      "pick_up_location_address":"${widget.pPickUpLocation}",
                                      "pickup_lat":"${widget.pPickUpLocationlat}",
                                      "pickup_lng":"${widget.pPickUpLocationlng}",
                                      "drop_location_address":"${widget.pDropOffLocation}",
                                      "drop_lat":"${widget.pDropOffLocationlat}",
                                      "drop_lng":"${widget.pDropOffLocationlong}",
                                      "ssn":"${widget.pSSNNo}",
                                      "id_card":"${widget.pIDCardNo}",
                                      "driving_license":"${widget.pDriverLisenceNumber}",
                                      "hosting_demos":"${booltoIntHome(widget.demoRequested)}" };
                                    var icount = 0;
                                    for (var values in widget.videosImage!){
                                      imageFiles!.add({"name":"image_url[$icount]","path":values!.path});
                                      icount = icount + 1;
                                    }
                                    jsonParam.addEntries(jsonnew!.entries);
                                    showLoading();
                                    createAds(jsonData: jsonParam, files: imageFiles!, onSuccess: (data) {
                                      hideLoading();
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              ThankYoupopUp()
                                      );
                                    }, onError: (error) {
                                      toast(error);
                                      imageFiles = [];
                                      hideLoading();
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ]),
      ),
    );
  }

  Widget facilitiesView(String facilityName) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: const Color(0xFF707070).withOpacity(0.20)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          facilityName,
          style: Style.getBoldFont(
            12.sp,
          ),
        ),
      ),
    );
  }

  Widget ThankYoupopUp() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Thank You!",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "For placing the Ad. Once approved from Admin you will be notified",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              // CustomButton(
              //     btnText: "Goto Home",
              //     color: Style.redColor,
              //     onPressed: () {
              //       homeNavigationViewModel.currentScreenIndex = 0;
              //       Navigator.pushNamedAndRemoveUntil(
              //           context, Constants.home, (route) => false);
              //     })
              CustomButton(
                btnText: "Goto Home",
                radius: 25.w,
                height: 50.w,
                width: MediaQuery.of(context).size.width,
                fontSize: 12.sp,
                fontstyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: Const.aventa,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.sp,
                ),
                onPressed: () {
                  //homeNavigationViewModel.currentScreenIndex = 0;
                  Navigator.pushNamedAndRemoveUntil(
                      context, Dashboard.route, (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }


  String? productType(String? value) {
    if (value == "Rent as Days" ){
      return "day";
    }else {
      return "hr";
    }
  }

  String? productTypeValue(int index) {
    if (index == 0)
      return "hr";
    else if(index == 1)
      return "day";

  }

  int? booltoIntHome(bool? value){
    if (value == true) {
      return 1;
    }else {
      return 0;
    }
  }
}
