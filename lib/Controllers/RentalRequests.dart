import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Models/SellBooking.dart';
import 'package:rentarbo_flutter/Models/SellBookingDetails.dart';
import '../Controllers/RentalRequest/RentalRequestsView.dart';
import '../Models/Ads.dart';

import '../Extensions/style.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalBookingDetails.dart';
import '../Models/RentalItemModel.dart';
// import '../Models/SellBooking.dart';
import '../Utils/Ads_services.dart';
import '../Utils/BookingAds.dart';
import '../Utils/Const.dart';
import '../Utils/Sell_Services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'RentRequestDetail.dart';

class RentalRequest extends StatefulWidget {
  static const String route = "RentalRequest";

  RentalRequest({Key? key}) : super(key: key);
  GlobalKey? requestUpdate = GlobalKey();

  @override
  _RentalRequestState createState() => _RentalRequestState();
}

class _RentalRequestState extends State<RentalRequest> with Observer {


  int getSellCount(){
    return sellBooking?.length ?? 0;
  }

  int getInboxItemsCount() {
    return listRentatBooking?.length ?? 0;
  }

  String getTitleFor(int index) {
    return listRentatBooking![index]!.product!.name ?? "";
  }

  String getTitleForSell(int index) {
    return sellBooking![index]!.product!.name ?? "";
  }

  String getSubtitleFor(int index) {
    return listRentatBooking![index]!.product!.category!.name ?? "";
  }

  String getSubtitleForSell(int index) {
    return sellBooking![index]!.product!.category!.name ?? "";
  }

  String getDisplayPriceFor(int index) {
    return listRentatBooking![index]!.totalCharges ?? "";
  }

  String getDisplayPriceForSell(int index) {
    return sellBooking![index]!.totalCharges ?? "";
  }

  String getDisplayImageFor(int index) {
    return listRentatBooking![index]!.product!.media!.first!.filename ?? "";
  }


  List<RentalBookingdatum>? listRentatBooking;
  RentalBookingDetails? rentalBookingDetails;
  SellBookingDetails? sellBookingDetails;
  List<Datum>? sellBooking;

  @override
  void initState() {
    super.initState();
    loadAds();
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
    getRentalBookingAds(bookingType: "sent" ,onSuccess: (data) {
      setState((){
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
    getBookingSell(bookingType: "sent" , productId: "" ,onSuccess: (data) {
      setState((){
        if (data.data?.length == 0) {
          toast("Record not found.");
        }
        sellBooking = data.data;
      });

      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    }, jsonData: {"type" : "sent"});
  }



  bool request = false;
  Color? colorTapOne;
  Color? colorTapTwo;


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
            backgroundColor: Colors.white,
            centerTitle: false,
            titleSpacing: 0,
            title: Text(
              "Send Requests",
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
          body: _RentalRequestsBodyView()),
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
    );
  }

  AdsObj getAdjsFromProduct(int index) {
    Product mainValue = listRentatBooking![index]!.product!;
    AdsObj obj = AdsObj.fromJson({
      "id": mainValue.id,
      "user_id": mainValue.userId,
      "category_id": mainValue.categoryId,
      "name": mainValue.name,
      "slug": mainValue.slug,
      "description": mainValue.description,
      "tags": List<dynamic>.from(mainValue.tags!.map((x) => x)),
      "rent_type": mainValue.rentType,
      "rent_charges": mainValue.rentCharges,
      "pick_up_location_address": mainValue.pickUpLocationAddress,
      "pickup_lat": mainValue.pickupLat,
      "pickup_lng": mainValue.pickupLng,
      "drop_location_address": mainValue.dropLocationAddress,
      "drop_lat": mainValue.dropLat,
      "drop_lng": mainValue.dropLng,
      "ssn": mainValue.ssn,
      "id_card": mainValue.idCard,
      "driving_license": mainValue.drivingLicense,
      "hosting_demos": mainValue.hostingDemos,
      "rating": mainValue.rating,
      "reviews": mainValue.reviews,
      "category": mainValue.category?.toJson(),
      "owner": mainValue.category?.toJson(),
      "media": List<dynamic>.from(mainValue.media!.map((x) => x.toJson())),
    });

    return obj;
  }

  Widget _RentalRequestsBodyView()
  {

    return TabBarView(children: [
      Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  request = false;
                  //Move to Product
                  showLoading();
                  getRentalBookingDetails(slug: listRentatBooking![index]!.slug ?? "", onSuccess: (data) {
                    rentalBookingDetails = data;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("RentalRequest" , getAdjsFromProduct(index) , widget.requestUpdate , listRentatBooking![index] ,data , null ) ));

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
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 16.w),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                       child : listRentatBooking![index].product!.media!.isNotEmpty ?  circularImageView(image: returnImageValue(index) ?? "" ,size: 60.w) : Image.asset("src/placeholder.png"),),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width : MediaQuery.of(context).size.width/2.6,
                                  child: Text(
                                    getTitleFor(index),maxLines: 2,
                                    style: Style.getBoldFont(14.sp,
                                        color: Style.textBlackColor),
                                  ),
                                ),
                                    Spacer(),

                                    Text("Booking # ${listRentatBooking?[index].id}" , style: Style.getSemiBoldFont(9.sp),),

                              ],
                            ),
                            SizedBox(height: 3,),
                            Text(
                              getSubtitleFor(index),
                              style: Style.getBoldFont(12.sp,
                                  color: Style.textBlackColor),
                            ),
                            SizedBox(height: 5.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${getDisplayPriceFor(index)}",
                                  style: Style.getBoldFont(12.sp,
                                      color: Style.redColor),
                                ),
                                InkWell(
                                  onTap: (){
                                    showLoading();
                                    getRentalBookingDetails(slug: listRentatBooking![index]!.slug ?? "", onSuccess: (data) {
                                      // RentalBookingDetails
                                      rentalBookingDetails = data;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("RentalRequest" , getAdjsFromProduct(index) , widget.requestUpdate , listRentatBooking![index] ,data ,null) ));

                                      hideLoading();
                                    }, onError: (error) {
                                      hideLoading();
                                      showToast(error);
                                    }, jsonData: {});
                                  },
                                  child: Container(
                                    width: 90.w,
                                    height: 25.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF707070),
                                        borderRadius: BorderRadius.circular(20.w)),
                                    child: Center(
                                      child: Text(
                                        "View Status",
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
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 8.w,
              );
            },
            itemCount: getInboxItemsCount()),
      ),
      Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return  GestureDetector(
                onTap: () {
                  showLoading();
                  getSellBookingDetails(slug: sellBooking![index]!.slug ?? "", onSuccess: (data) {
                    sellBookingDetails = data;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("SellRequests" , getAdjsFromProduct(index) , widget.requestUpdate , null ,null,data ) ));

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
                        child : sellBooking![index].product!.media!.isNotEmpty ?  circularImageView(image: sellImageValue(index) ?? "" ,size: 60.w) : Image.asset("src/placeholder.png"),),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                                Text(
                                  getTitleForSell(index),maxLines: 1,
                                  style: Style.getBoldFont(14.sp,
                                      color: Style.textBlackColor),
                                ),
                            SizedBox(height: 2,),
                            Text("Booking # ${sellBooking?[index].id}" , style: Style.getSemiBoldFont(9.sp),),
                            SizedBox(height: 2,),
                            Text(
                              getSubtitleForSell(index),
                              style: Style.getBoldFont(12.sp,
                                  color: Style.textBlackColor),
                            ),

                            SizedBox(height: 5.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "\$${getDisplayPriceForSell(index)}",
                                  style: Style.getBoldFont(12.sp,
                                      color: Style.redColor),
                                ),
                                InkWell(
                                  onTap: (){
                                    showLoading();
                                    getSellBookingDetails(slug: sellBooking![index]!.slug ?? "", onSuccess: (data) {
                                      sellBookingDetails = data;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("SellRequests" , getAdjsFromProduct(index) , widget.requestUpdate , null ,null,data ) ));

                                      hideLoading();
                                    }, onError: (error) {
                                      hideLoading();
                                      showToast(error);
                                    }, jsonData: {});
                                  },
                                  child: Container(
                                    width: 90.w,
                                    height: 25.w,
                                    decoration: BoxDecoration(
                                        color: const Color(0xFF707070),
                                        borderRadius: BorderRadius.circular(20.w)),
                                    child: Center(
                                      child: Text(
                                        "View Status",
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
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 8.w,
              );
            },
            itemCount: getSellCount()),
      ),
    ]);


  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    setState((){
      String? mapvalue = map?["type"] as String;
      if (mapvalue == "booking") {
        listRentatBooking = [];
        loadAds();
      }
    });
  }
}



