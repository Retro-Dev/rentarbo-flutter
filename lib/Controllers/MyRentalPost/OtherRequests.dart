import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Models/SellBookingDetails.dart';
import 'package:rentarbo_flutter/Utils/Sell_Services.dart';
import '../../Controllers/RentRequestDetail.dart';
import '../../Models/Ads.dart';
import '../../Models/RentalBooking.Dart.dart';
import '../../Models/RentalBookingDetails.dart';
import '../../Models/RentalRequestsViewModel.dart';

import '../../Extensions/style.dart';
import '../../Models/OthersRequestViewModel.dart';
import '../../Models/SellBooking.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../component/image_slider.dart';
import '../RentalRequestContentView.dart';


class OtherRequests extends StatefulWidget  {
  GlobalKey? requestsUpdate = GlobalKey();
  static const String route = "OtherRequests";
  bool? request;
  bool? isAccept;
  AdsObj? adsObj;
  OtherRequests({this.request , this.isAccept , this.adsObj, this.requestsUpdate});


  // const OtherRequests({Key? key}) : super(key: key);

  @override
  _OtherRequestsState createState() => _OtherRequestsState();
}

class _OtherRequestsState extends State<OtherRequests> with Observer {

  OtherRequestsViewModel otherRequestsViewModel = OtherRequestsViewModel();



  List<RentalBookingdatum>? listRentatBooking;
  List<Datum>? sellBooking;
  RentalBookingDetails? rentalBookingDetails;
  SellBookingDetails? sellBookingDetails;

  Color? colorTapOne;
  Color? colorTapTwo;

  @override
  void initState() {
    super.initState();
    loadAds();
    print("--------Product id ---------");
    print("${widget.adsObj!.id!}");
    print("-------product id -------");
    colorTapOne = Colors.white;
    colorTapTwo = Colors.black;
    Observable.instance.addObserver(this);
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }


  loadAds() async {
    showLoading();
    getRentalBookingAds(bookingType: "recieved" , productId: "${widget.adsObj!.id!}" ,onSuccess: (data) {
      setState((){
        print(data);
        if (data.length == 0) {
          toast("Record not found.");
        }
        listRentatBooking = data;
      });

      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    });

  }


  loadSellAds() async {
    showLoading();
    getBookingSell(bookingType: "recieved" , productId: "${widget.adsObj!.id!}" ,onSuccess: (data) {
      setState((){
        print(data);
        if (data.data?.length == 0) {
          toast("Record not found.");
        }
        sellBooking = data.data;
      });

      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    }, jsonData: {"type" : "recieved" , "product" :"${widget.adsObj!.id!}" });
  }


  String? returnImageValue(int i) {
    if (listRentatBooking?[i].product?.media?.first?.fileType == "image") {
      return listRentatBooking?[i].product?.media?.first?.fileUrl ?? "";
    } else {
      return listRentatBooking?[i].product?.media?.first?.thumbnailUrl ?? "";
    }
  }


  String? sellImageValue(int i) {
    if (sellBooking?[i].product?.media?.first?.fileType == "image") {
      return sellBooking?[i].product?.media?.first?.fileUrl ?? "";
    } else {
      return sellBooking?[i].product?.media?.first?.thumbnailUrl ?? "";
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            bottom: PreferredSize(child: Padding(
              padding: EdgeInsets.only(left: 16.w , right: 16.w),
              child: ClipRRect(

                borderRadius: BorderRadius.circular(50.0),

                child: Container(
                  padding: EdgeInsets.all(2.w),
                  color: Color(0xffe7e7e7),
                  child: TabBar(onTap: (index) {
                    if (index == 0) {
                      setState((){
                        colorTapOne = Colors.white;
                        colorTapTwo = Colors.black;
                        // listRentatBooking = [];
                        loadAds();
                      });

                    }else if (index == 1) {
                      setState((){
                        colorTapOne = Colors.black;
                        colorTapTwo = Colors.white;
                        // listRentatBooking = [];
                        loadSellAds();
                      });

                    }
                  },
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50), // Creates border
                        color: Color(0xff78849e)), //Change background color from here
                    tabs: [ Tab(child: Text("Rental" , style: TextStyle(fontFamily: Const.aventaBold, color: colorTapOne ?? Colors.black , fontSize: 16.sp) ,)),
                      Tab(child: Text("Purchase" , style: TextStyle(fontFamily: Const.aventaBold ,color: colorTapTwo ?? Colors.black , fontSize: 16.sp),),),],

                  ),
                ),
              ),
            ), preferredSize: Size(MediaQuery.of(context).size.width, 80)),
            centerTitle: false,
            titleSpacing: 0,
            title: Text(
              "Request(s)",
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
          body: _OtherRequestsBodyView()
      ),
    );
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
      // imageBuilder: (context, imageProvider) => CircleAvatar(
      // backgroundImage: imageProvider,
      // radius: 50.r,
      // ),
      // fit: BoxFit.cover,
    );
  }

  Widget _OtherRequestsBodyView() {

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16.w,right: 16.w , top: 10.w),
        child: TabBarView(children: [
          ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {

                        widget.request = true;
                        widget.isAccept = true;
                        // Navigator.of(context)
                        //     .pushNamed(Constants.rentalRequestDetail);
                          //Move to Product
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests",widget.adsObj!,widget.requestsUpdate , null , null)) ).then((value) {
                        //   Navigator.pop(context ,widget.requestsUpdate);
                        // });

                        showLoading();
                        getRentalBookingDetails(slug: listRentatBooking![index]!.slug ?? "", onSuccess: (data) {
                          // RentalBookingDetails
                          rentalBookingDetails = data;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests" ,widget.adsObj! , widget.requestsUpdate , listRentatBooking![index] ,rentalBookingDetails,null ) ));

                          hideLoading();
                        }, onError: (error) {
                          hideLoading();
                          showToast(error);
                        }, jsonData: {});
                      },
                    child: Container(
                      height: 100.h,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.all(Radius.circular(16.w))),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 16.w),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child : listRentatBooking![index].product!.media!.isNotEmpty ?   circularImageView(image: returnImageValue(index) ?? "" ,size: 60.w)  : Image.asset("src/placeholder.png"),),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 15.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width : MediaQuery.of(context).size.width/2.6,
                                      child: Text(
                                          listRentatBooking?[index]?.product?.name ?? "",maxLines: 2,
                                        // listRentatBooking?[index]?.product?.name ?? "",
                                        style: Style.getSemiBoldFont(16.sp,
                                            color: Style.textBlackColor),
                                      ),
                                    ),
                                    Spacer(),
                                    Text("Booking # ${listRentatBooking?[index]?.id}" , style: Style.getBoldFont(9.sp),),
                                  ],
                                ),
                                SizedBox(height: 3.5,),

                                Text(
                                  listRentatBooking?[index]?.product?.category!.name ?? "",
                                  style: Style.getSemiBoldFont(12.sp,
                                      color: Style.redColor),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 8.w,
                  );
                },
                itemCount: listRentatBooking?.length ?? 0),
          ListView.separated(
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (index == 0) {
                      widget.request = true;
                      widget.isAccept = true;
                      // Navigator.of(context)
                      //     .pushNamed(Constants.rentalRequestDetail);
                      //Move to Product
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests",widget.adsObj!,widget.requestsUpdate , null , null ,null)) ).then((value) {
                        Navigator.pop(context ,widget.requestsUpdate);
                      });
                    }
                  },
                  child: Container(
                    height: 100.h,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.all(Radius.circular(16.w))),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {

                        widget.request = true;
                        widget.isAccept = true;
                        // Navigator.of(context)
                        //     .pushNamed(Constants.rentalRequestDetail);
                        //Move to Product
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests",widget.adsObj!,widget.requestsUpdate , null , null)) ).then((value) {
                        //   Navigator.pop(context ,widget.requestsUpdate);
                        // });

                        showLoading();
                        getSellBookingDetails(slug: sellBooking![index]!.slug ?? "", onSuccess: (data) {
                          // RentalBookingDetails
                          sellBookingDetails = data;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("SellRequests" ,widget.adsObj! , widget.requestsUpdate , null ,rentalBookingDetails,data ) ));

                          hideLoading();
                        }, onError: (error) {
                          hideLoading();
                          showToast(error);
                        }, jsonData: {});
                      },
                      child: Container(
                        height: 100.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.all(Radius.circular(16.w))),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 16.w),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child : sellBooking![index].product!.media!.isNotEmpty ?   circularImageView(image: sellImageValue(index) ?? "" ,size: 60.w)  : Image.asset("src/placeholder.png"),),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15.h,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width : MediaQuery.of(context).size.width/2.6,
                                        child: Text(
                                          sellBooking?[index]?.product?.name ?? "",maxLines: 2,
                                          style: Style.getSemiBoldFont(16.sp,
                                              color: Style.textBlackColor),
                                        ),
                                      ),
                                      Spacer(),
                                      Text("Booking # ${sellBooking?[index]?.id}" , style: Style.getBoldFont(9.sp),),
                                    ],
                                  ),
                                  SizedBox(height: 3.5,),


                                  Text(
                                    sellBooking?[index]?.product?.category!.name ?? "",
                                    style: Style.getSemiBoldFont(12.sp,
                                        color: Style.redColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.w),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8.w,
                );
              },
              itemCount: sellBooking?.length ?? 0),
        ]),
      ),
    );

  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    setState((){
      print("-----------------Notification Data------------");
      print(map);
      String? mapvalue = map?["type"] as String;
      if (mapvalue == "booking") {

        loadAds();
      }

      print("-----------------Notification Data------------");
    });
  }


}