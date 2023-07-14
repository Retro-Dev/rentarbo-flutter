import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Models/Ads.dart';
import 'package:rentarbo_flutter/Utils/Ads_services.dart';
import 'package:rentarbo_flutter/Utils/user_services.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Extensions/Externsions.dart';
import '../Extensions/style.dart';
import '../Models/Notification.dart';
import '../Models/NotificationModel.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalBookingDetails.dart';
import '../Models/User.dart';
import '../Utils/BookingAds.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/Sell_Services.dart';
import 'ChatScreen.dart';
import 'DisputeDetailsMain.dart';
import 'RentRequestDetail.dart';

class Notifications extends StatefulWidget {
  static const String route = "Notifications";

   Notifications({Key? key}) : super(key: key);
  GlobalKey? requestUpdate = GlobalKey();
  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationViewModel notificationViewModel = NotificationViewModel();

  List<Notfi> notification = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationViewModel.setDataNotification();
    showLoading();
    getNotifications(onSuccess: (data) {
      load();
      if (data.length == 0 ) {
        toast("Record not found.");
      }else {
        setState((){
          notification = data;

        });
      }

      hideLoading();
    }, onError: (error) {
      hideLoading();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  User? userObj;
  List<RentalBookingdatum>? listRentatBooking;
  List<RentalBookingdatum>? rentalBookingDetailsarr;
  RentalBookingDetails? rentalBookingDetails;
  load() async {
    Prefs.getUser((User? user) {
      if(mounted) {
        setState(() {
          this.userObj = user;
          loadAds();
        });
      }
    });
  }

  loadAds() async {
    // showLoading();
    getRentalBookingAds(bookingType: "sent" ,onSuccess: (data) {
      if(mounted) {
        setState(() {
          if (data.length == 0) {
          }
          listRentatBooking = data;
        });
      }

      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    });

  }



  loadAdsOwner(AdsObj adProductId) async {
    // showLoading();
    getRentalBookingAds(bookingType: "recieved" , productId: "${adProductId.id}" ,onSuccess: (data) {
      setState((){

        if (data.length == 0) {
          toast("Record not found.");
        }
        listRentatBooking = data;
        getRentalBookingDetails(slug: listRentatBooking?.last?.slug ?? "", onSuccess: (data) {
          // RentalBookingDetails
          rentalBookingDetails = data;
          Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("Requests" ,adProductId , widget.requestUpdate , listRentatBooking?.first ,rentalBookingDetails,null ) ));

          hideLoading();
        }, onError: (error) {
          hideLoading();
          showToast(error);
        }, jsonData: {});
      });

      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    });

  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: Text(
          "Notifications",
          textAlign: TextAlign.start,
          style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
        ),
        leading: IconButton(
          icon: SizedBox(
              width: 30.w,
              height: 30.w,
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
        padding: EdgeInsets.only(left: 16.w , right: 16.w , top: 15.h),
            child: ListView.builder(
        itemCount: notification.length,
        itemBuilder: (context, position) {
        return InkWell(
          onTap: () {
            showLoading();
    if (notification[position].module == "products") {
      if (notification[position].webRedirectLink != null) {

        getAdsDetails(slug: notification[position].webRedirectLink ?? "", onSuccess: (data) {
          setState((){
            hideLoading();


            GlobalKey requestsUpdated = GlobalKey();

            Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("myAds",data,requestsUpdated , null , null , null)) ).then((value) {


            });
          });
        }, onError: (error) {

        });
      }
    }

            if (notification[position].module == "bookings") {

                if(notification[position].webRedirectLink != null) {
              getRentalBookingDetails(
                  slug: notification[position].webRedirectLink ?? "", onSuccess: (data) {
                AdsObj? adsobj;
                RentalBookingdatum? rentalDetails;
                adsobj = AdsObj.fromJson({ "id": data.data?.product?.id ,
                  "userId": data.data?.product?.userId,
                  "categoryId": data.data?.product?.categoryId,
                  "name": data.data?.product?.name,
                  "slug": data.data?.product?.slug,
                  "description": data.data?.product?.description,
                  "tags": List<String>.from(data.data!.product!.tags!.map((x) => x)),
                  "rentType": data.data?.product?.rentType,
                  "rentCharges": data.data?.product?.rentCharges,
                  "sellPrice": data.data?.product?.sellPrice,
                  "pickUpLocationAddress": data.data?.product?.pickUpLocationAddress,
                  "pickupLat": data.data?.product?.pickupLat,
                  "pickupLng": data.data?.product?.pickupLng,
                  "dropLocationAddress": data.data?.product?.dropLocationAddress,
                  "dropLat": data.data?.product?.dropLat,
                  "dropLng": data.data?.product?.dropLng,
                  "ssn": data.data?.product?.ssn,
                  "idCard": data.data?.product?.idCard,
                  "drivingLicense": data.data?.product?.drivingLicense,
                  "hostingDemos": data.data?.product?.hostingDemos,
                  "rating":data.data?.product?.rating,
                  "reviews": data.data?.product?.reviews,
                  "isSell": data.data?.product?.isSell,
                  "isRent": data.data?.product?.isRent,
                  "sellStatus": data.data?.product?.sellStatus,
                  "pendingRequest": data.data?.product?.pendingRequest,
                  "category": data.data!.product!.category!.toJson(),
                  "owner":data.data!.product!.category!.toJson(),
                  "media": data.data!.product!.media!.map((x) => x.toJson())});
                rentalDetails = RentalBookingdatum.fromJson(data.data!.toJson());

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RentalRequestDetail(
                            "Requests",adsobj ,null, rentalDetails, data , null)));
                hideLoading();
              }, onError: (error) {
                hideLoading();
                showToast(error);
              }, jsonData: {});
            }
                }


            if (notification[position].module  == "sell") {
                  if (notification[position].webRedirectLink != null) {
                    showLoading();
                    getSellBookingDetails(
                        slug: notification[position].webRedirectLink,
                        onSuccess: (data) {
                          AdsObj? adsobj;
                          adsobj =
                              AdsObj.fromJson({ "id": data.data?.product?.id,
                                "userId": data.data?.product?.userId,
                                "categoryId": data.data?.product?.categoryId,
                                "name": data.data?.product?.name,
                                "slug": data.data?.product?.slug,
                                "description": data.data?.product?.description,
                                "tags": List<String>.from(
                                    data.data!.product!.tags!.map((x) => x)),
                                "rentType": data.data?.product?.rentType,
                                "rentCharges": data.data?.product?.rentCharges,
                                "sellPrice": data.data?.product?.sellPrice,
                                "pickUpLocationAddress": data.data?.product
                                    ?.pickUpLocationAddress,
                                "pickupLat": data.data?.product?.pickupLat,
                                "pickupLng": data.data?.product?.pickupLng,
                                "dropLocationAddress": data.data?.product
                                    ?.dropLocationAddress,
                                "dropLat": data.data?.product?.dropLat,
                                "dropLng": data.data?.product?.dropLng,
                                "ssn": data.data?.product?.ssn,
                                "idCard": data.data?.product?.idCard,
                                "drivingLicense": data.data?.product
                                    ?.drivingLicense,
                                "hostingDemos": data.data?.product
                                    ?.hostingDemos,
                                "rating": data.data?.product?.rating,
                                "reviews": data.data?.product?.reviews,
                                "isSell": data.data?.product?.isSell,
                                "isRent": data.data?.product?.isRent,
                                "sellStatus": data.data?.product?.sellStatus,
                                "pendingRequest": data.data?.product
                                    ?.pendingRequest,
                                "category": data.data!.product!.category!
                                    .toJson(),
                                "owner": data.data!.product!.category!.toJson(),
                                "media": data.data!.product!.media!.map((x) =>
                                    x.toJson())});

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RentalRequestDetail(
                                          "SellRequests", adsobj, null, null,
                                          null, data)));
                          hideLoading();
                        },
                        onError: (error) {
                          hideLoading();
                          showToast(error);
                        },
                        jsonData: {});
                  }
                }

            if (notification[position].module == "disputes" ) {
              hideLoading();
              Navigator.pushNamed(context, DisputeDetailsMain.route , arguments: {'slug' : notification[position].webRedirectLink  , 'type' : notification[position].referenceModule});

            }


            if(notification[position].module == "chat") {
              hideLoading();
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) =>
                      ChatScreen(user_name: "${notification[position].actorName}",
                        chat_Room_id: notification[position].referenceId
                            .toString(), other_id: userObj!.id! == notification[position].targetId! ? notification[position].actorId! : notification[position].targetId! ,),));
            }


          },
          child: Padding(
              padding: EdgeInsets.only(bottom: 5.w),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: FadeInImage(
                              height: 55,
                              width: 55,
                              fadeInDuration: const Duration(milliseconds: 500),
                              fadeInCurve: Curves.easeInExpo,
                              fadeOutCurve: Curves.easeOutExpo,
                              placeholder: Image.asset("src/placeholder.png" , height: 45, width: 45,).image,
                              image: notification[position].actorImageUrl!.isNotEmpty ?  NetworkImage(notification[position].actorImageUrl ?? "" ) : Image.asset("src/placeholder.png", height: 45, width: 45,).image,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset("src/placeholder.png", height: 45, width: 45,);
                              },
                              fit: BoxFit.fill),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: "${notification[position].title} ",
                                  style: Style.getRegularFont(12.sp,
                                      color: const Color(0xFF2A2E43)),
                                  children: [
                                    // Text("${notification[position].title} asdflkjasdlkfjalskdjf aslkdfja sdfjlaksjflkas djflkas jdflkas djf",)
                                    TextSpan(
                                        text: "${notification[position].description}",
                                        style: const TextStyle(fontFamily: Const.aventa  ))
                                  ])),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        if (notification[position].isRead == "1")
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Style.redColor,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                              width: 8.w,
                              height: 8.w,
                            ),
                          ),
                        if (notification[position].isRead == "1")
                          SizedBox(
                            width: 8.w,
                          ),
                        // const Spacer(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${timeAgoSinceDate(notification[position].createdAt ?? "")}",
                            style: Style.getRegularFont(12.sp,
                                color: const Color(0xFF78849E) ) ,textAlign: TextAlign.right,
                          ),
                        )
                      ]),
                ),
              ),
            ),
        );
        },
      ),
      ),
    );
  }
}



