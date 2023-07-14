import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import '../Extensions/style.dart';
import '../Models/Ads.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalItemModel.dart';
import '../Utils/Ads_services.dart';
import '../Utils/BookingAds.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'MyRentalPost/OtherRequests.dart';
import 'RentRequestDetail.dart';


class MyRentalPosted extends StatefulWidget {

  static const String route = "MyRentalPosted";

  const MyRentalPosted({Key? key}) : super(key: key);

  @override
  State<MyRentalPosted> createState() => _MyRentalPostedState();
}

class _MyRentalPostedState extends State<MyRentalPosted> {

  List<AdsObj> _adsObj = [];
  bool? _isRequest = true;
  GlobalKey requestsUpdated = GlobalKey();

  final List<RentalItemModel> _rentalItemModels = [
    RentalItemModel(
        title: "Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$120/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.requests),
    RentalItemModel(
        title: "2019 Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$110/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.details),
  ];


  String getTitleFor(int index) {
    return _adsObj[index].name ?? "";
  }

  String getSubtitleFor(int index) {
    return _adsObj[index].description ?? "";
  }

  String getDisplayPriceFor(int index) {
    return "\$${_adsObj[index].rentCharges ?? " "}\/${_adsObj[index].rentType ?? ""}";
  }

  String getRentype(int index){
    return returnRentType("${_adsObj[index].rentType ?? ""}") ?? "";
  }

  String? returnRentType(String? value) {
    if (value == "day"){
      return "Rent as per Day";
    }else {
      return "Rent as per Hour";
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      loadAds();

  }


  loadAds() async {
    showLoading();
    getAds(type: "owner", lat: "", long: "", keyword: "", rentType: "", category: 1,distance: "10", onSuccess: (list) {
      _adsObj = list;


      hideLoading();
      if(mounted){
        setState((){});
      }

    }, onError: (error) {
      hideLoading();
      toast(error);
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
            "Received Requests",
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
        body: _RentalPostedBodyView());
  }

  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , height: 60.h , width: 60.h , fit: BoxFit.cover,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
            height: 60.h , width: 60.h ,fit: BoxFit.cover,
          )),
      height: 60.h,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
    );
  }

  Widget _adsMyPost(int index){

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {

          Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRequests(isAccept: true , request: true, adsObj: _adsObj[index],requestsUpdate: requestsUpdated ,)) ).then((value) {


            setState((){
              loadAds();
            });

            requestsUpdated.currentState?.setState(() {


            });
          });
        },
        child: Container(
          height: 100.h,
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              border: Border.all(color: Colors.white , width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(16.w))),
          child: Padding(
            padding: EdgeInsets.only(top: 5.h , bottom: 5.h),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 8.w),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child:

                  _adsObj[index].media!.isNotEmpty ?  circularImageView(image: _adsObj?[index].media?.first?.fileUrl ?? "" ,size: 60.w)
                      : circularImageView(image: _adsObj?[index].media?.first?.fileUrl ?? "" ,size: 60.w)
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTitleFor(index),
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: Const.aventaBold,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.sp,
                        ),overflow: TextOverflow.clip,maxLines: 1,),
                      SizedBox(height: 2.h,),
                      Text(
                        getSubtitleFor(index),
                        style:TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontFamily: Const.aventaBold,
                          fontStyle: FontStyle.normal,
                          fontSize: 12.sp,
                        ),overflow: TextOverflow.clip,maxLines: 1,),
                      SizedBox(height: 5.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getDisplayPriceFor(index),
                            style: Style.getBoldFont(12.sp,
                                color: Style.redColor),
                          ),
                          if(_adsObj[index].isSell == 1)
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Container(

                                width: 60.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                    color: Style.redColor,
                                    borderRadius:
                                    BorderRadius.circular(20.w)),
                                child: Center(
                                  child: InkWell(
                                    onTap: (){
                                    },
                                    child: Text(
                                      "SELL",
                                      style: Style.getBoldFont(12.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_adsObj[index].pendingRequest == 1)
                            Padding(
                              padding: EdgeInsets.only(bottom: 6.h),
                              child: Container(

                                width: 81.w,
                                height: 25.w,
                                decoration: BoxDecoration(
                                    color: const Color(0xFF70CE01),
                                    borderRadius:
                                    BorderRadius.circular(20.w)),
                                child: Center(
                                  child: InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OtherRequests(isAccept: true , request: true, adsObj: _adsObj[index],requestsUpdate: requestsUpdated ,)) ).then((value) {


                                        setState((){
                                          loadAds();
                                        });

                                        requestsUpdated.currentState?.setState(() {


                                        });
                                      });
                                    },
                                    child: Text(
                                      "Request(s)",
                                      style: Style.getBoldFont(12.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_adsObj[index].pendingRequest == 0)
                            Container(
                              width: 99.w,
                              height: 25.w,
                              decoration: BoxDecoration(
                                  color: Style.redColor,
                                  borderRadius:
                                  BorderRadius.circular(20.w)),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    RentalBookingdatum? dataRentalBooking;
                                    showLoading();
                                    getRentalBookingAds(bookingType: "recieved" , productId: "${_adsObj![index].id!}" ,onSuccess: (data) {
                                      setState((){
                                        if (data.length == 0) {
                                          toast("Record not found.");
                                        }

                                        dataRentalBooking = data.first;
                                        showLoading();
                                        getRentalBookingDetails(slug: data?.first?.slug ?? "", onSuccess: (data) {
                                          // RentalBookingDetails
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests" ,_adsObj[index] , requestsUpdated , dataRentalBooking ,data ,null) )).then((value) {
                                            setState((){
                                              loadAds();
                                            });

                                            requestsUpdated.currentState?.setState(() {


                                            });
                                          });

                                          hideLoading();
                                        }, onError: (error) {
                                          hideLoading();
                                          showToast(error);
                                        }, jsonData: {});

                                      //   Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests" ,_adsObj![index] , requestsUpdated , null ,data.last ) ));
                                      //
                                      //
                                      });

                                      hideLoading();
                                    }, onError: (error) {
                                      hideLoading();
                                      showToast(error);
                                    });


                                  },
                                  child: Text(
                                    "Rental Details",
                                    style: Style.getBoldFont(12.sp,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),

                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ),
        ),
      );

  }

  Widget _RentalPostedBodyView()
  {
    return SafeArea(
       child: Padding(
         padding: EdgeInsets.all(16.w),
         child: ListView.separated(
             itemCount: _adsObj!.length,
             itemBuilder: (context, index) {

             return _adsMyPost(index);

             },
           separatorBuilder:  (context, index) {
                return SizedBox(height: 9.w,);
           },
             ),
       ));
  }

}
