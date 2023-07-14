
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Controllers/SellDetails/SellDetailsRequest.dart';
import 'package:rentarbo_flutter/Utils/BaseModel.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Models/Ads.dart';
import '../../component/image_slider.dart';
import '../../utils/style.dart';
import '../Models/BookingAdsRental.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalBookingDetails.dart';
import '../Models/SellBookingDetails.dart';
import '../Models/User.dart';
import '../Utils/BookingAds.dart';
import '../Utils/Prefs.dart';
import '../Utils/Sell_Services.dart';
import '../Utils/utils.dart';
import 'ChatScreen.dart';
import 'RentalRequest/RentalSendRequestDetailView.dart';
import 'RentalRequestContentView.dart';


class RentalRequestDetail extends StatefulWidget {
  static const String route = "RentalRequestDetail";

  String? navigateFrom ;
  AdsObj? adObj;
  GlobalKey? requestUpdatemain = GlobalKey();
  RentalBookingdatum? rentalBookingmain;
  RentalBookingDetails? _rentalBookingDetails;
  BookingDatum? _bookingRentalAds;
  SellBookingDetails?  _sellBookingDetails;
  RentalRequestDetail(String isNavigate , AdsObj? obj , GlobalKey? requestUpdate , RentalBookingdatum? rentalBooking , RentalBookingDetails? rentalBookingDetails,SellBookingDetails? sellBookingDetails  ) {
    navigateFrom = isNavigate;
    adObj = obj;
    requestUpdatemain = requestUpdate;
    rentalBookingmain = rentalBooking;
    _rentalBookingDetails = rentalBookingDetails;
    _sellBookingDetails = sellBookingDetails;
  }

  @override
  _RentalRequestDetailState createState() => _RentalRequestDetailState();
}

class _RentalRequestDetailState extends State<RentalRequestDetail> with Observer {

  // String isNavigate = "";
  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
      });
    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Observable.instance.addObserver(this);
    load();
    if (widget.navigateFrom == "Requests") {
      showLoading();
      getRentalBookingDetails(
          slug: widget.rentalBookingmain?.slug ?? "", onSuccess: (data) {
        widget._rentalBookingDetails = data;
        hideLoading();
      }, onError: (error) {
        hideLoading();
        showToast(error);
      }, jsonData: {});
    }
  }

  @override
  void dispose() {
    widget._rentalBookingDetails = null;
    widget._bookingRentalAds = null;
    widget.adObj = null;
    widget.requestUpdatemain = null;

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

   Widget topNavigationButtons(){

     if (widget.navigateFrom == "Home") {

     return  ImageSlider(
       isFromCreatePost: false,
         isFromMyAds: false,
         adsObj: widget.adObj,
         icLeft: InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: SizedBox(
           width: 50,
           height: 52,
         ), images: [], isVideoI: [], videosImages: [],
       );

     }else if (widget.navigateFrom == "Requests"){

       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: false,
         adsObj:widget.adObj,
         icLeft:  InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: InkWell(
           onTap: () {
             if(widget._rentalBookingDetails != null) {
               showLoading();
               create_chat(
                   user_id: "${widget._rentalBookingDetails!.data!.userId}",
                   other_id: "${widget._rentalBookingDetails!.data!
                       .productOwnerId}",
                   onSuccess: (BaseModel baseModel) {
                     hideLoading();
                     if (baseModel.data != null && baseModel.code == 200) {
                       Navigator.of(context, rootNavigator: true).push(
                           MaterialPageRoute(builder: (context) =>
                               ChatScreen(user_name: "${widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget._rentalBookingDetails!.data!.rentar!.name}" :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget._rentalBookingDetails!.data!.owner!.name}" :"${userObj!.name}"}",
                                 chat_Room_id: baseModel.data["room_id"]
                                     .toString(), other_id:widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? widget._rentalBookingDetails!.data!.rentar!.id! :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._rentalBookingDetails!.data!.owner!.id! : userObj!.id! ,),));
                     }
                   },
                   onError: (error) {
                     hideLoading();
                     toast(error);
                   });
             }else {
               showLoading();
               create_chat(
                   user_id: "${widget._sellBookingDetails!.data!.userId}",
                   other_id: "${widget._sellBookingDetails!.data!
                       .productOwnerId}",
                   onSuccess: (BaseModel baseModel) {
                     hideLoading();
                     if (baseModel.data != null && baseModel.code == 200) {
                       Navigator.of(context, rootNavigator: true).push(
                           MaterialPageRoute(builder: (context) =>
                               ChatScreen(user_name: "${widget._sellBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget._sellBookingDetails!.data!.rentar!.name}" :   widget._sellBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget._sellBookingDetails!.data!.owner!.name}" :"${userObj!.name}"}",
                                 chat_Room_id: baseModel.data["room_id"]
                                     .toString(), other_id:widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? widget._rentalBookingDetails!.data!.rentar!.id! :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._rentalBookingDetails!.data!.owner!.id! : userObj!.id!,),));
                     }
                   },
                   onError: (error) {
                     hideLoading();
                     toast(error);
                   });
             }


           },
           child: Image.asset(
             Style.getIconImage("ic_chat@2x.png"),
             width: 50,
             height: 50,
           ),
         ), images: [], isVideoI: [], videosImages: [],
       );


     }else if (widget.navigateFrom == "RentalRequest") {


       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: false,
         adsObj: widget.adObj,
         icLeft: InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: InkWell(
           onTap: (){
             if(widget._rentalBookingDetails != null) {
               showLoading();
               create_chat(
                   user_id: "${widget._rentalBookingDetails!.data!.userId}",
                   other_id: "${widget._rentalBookingDetails!.data!
                       .productOwnerId}",
                   onSuccess: (BaseModel baseModel) {
                     hideLoading();
                     if (baseModel.data != null && baseModel.code == 200) {
                       Navigator.of(context, rootNavigator: true).push(
                           MaterialPageRoute(builder: (context) =>
                               ChatScreen(user_name: "${widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget._rentalBookingDetails!.data!.rentar!.name}" :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget._rentalBookingDetails!.data!.owner!.name}" :"${userObj!.name}"}",
                                   chat_Room_id: baseModel.data["room_id"]
                                   .toString(), other_id:widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? widget._rentalBookingDetails!.data!.rentar!.id! :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._rentalBookingDetails!.data!.owner!.id! : userObj!.id!),));
                     }
                   },
                   onError: (error) {
                     hideLoading();
                     toast(error);
                   });
             }else {
               showLoading();
               create_chat(
                   user_id: "${widget._sellBookingDetails!.data!.userId}",
                   other_id: "${widget._sellBookingDetails!.data!
                       .productOwnerId}",
                   onSuccess: (BaseModel baseModel) {
                     hideLoading();
                     if (baseModel.data != null && baseModel.code == 200) {
                       Navigator.of(context, rootNavigator: true).push(
                           MaterialPageRoute(builder: (context) =>
                               ChatScreen(user_name: "${widget._sellBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget._sellBookingDetails!.data!.rentar!.name}" :   widget._sellBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget._sellBookingDetails!.data!.owner!.name}" :"${userObj!.name}"}",
                                 chat_Room_id: baseModel.data["room_id"]
                                     .toString(),other_id:widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? widget._rentalBookingDetails!.data!.rentar!.id! :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._rentalBookingDetails!.data!.owner!.id! : userObj!.id!),));
                     }
                   },
                   onError: (error) {
                     hideLoading();
                     toast(error);
                   });
             }
           },
           child: Image.asset(
             Style.getIconImage("ic_chat@2x.png"),
             width: 50,
             height: 52,
           ),
         ),
         onPressed: () {

         }, images: [], isVideoI: [], videosImages: [],


       );


     }else if(widget.navigateFrom == "Own") {
       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: false,
         adsObj: widget.adObj,
         icLeft: InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: SizedBox(
           width: 50,
           height: 52,
         ), images: [], isVideoI: [], videosImages: [],
       );

     }else if (widget.navigateFrom == "requestrental") {

       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: false,
         adsObj:widget.adObj,
         icLeft:  InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: InkWell(
           onTap: (){

           },
           child: Image.asset(
             Style.getIconImage("ic_chat@2x.png"),
             width: 50,
             height: 50,
           ),
         ), images: [], isVideoI: [], videosImages: [],
       );


       }else if (widget.navigateFrom == "myAds") {

       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: true,
         adsObj: widget.adObj,
         icLeft: InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: SizedBox(
           width: 50,
           height: 52,
         ), images: [], isVideoI: [], videosImages: [],
       );

     }else if (widget.navigateFrom == "SellRequests"){

       return  ImageSlider(
         isFromCreatePost: false,
         isFromMyAds: false,
         adsObj:widget.adObj,
         icLeft:  InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: InkWell(
           onTap: () {
             if(widget._rentalBookingDetails != null) {
               showLoading();
               create_chat(
                   user_id: "${widget._rentalBookingDetails!.data!.userId}",
                   other_id: "${widget._rentalBookingDetails!.data!
                       .productOwnerId}",
                   onSuccess: (BaseModel baseModel) {
                     hideLoading();
                     if (baseModel.data != null && baseModel.code == 200) {
                       Navigator.of(context, rootNavigator: true).push(
                           MaterialPageRoute(builder: (context) =>
                               ChatScreen(user_name: "${widget.adObj?.name ??
                                   ""}",
                                 chat_Room_id: baseModel.data["room_id"]
                                     .toString(),other_id:widget._rentalBookingDetails!.data!.rentar!.id != userObj!.id ? widget._rentalBookingDetails!.data!.rentar!.id! :   widget._rentalBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._rentalBookingDetails!.data!.owner!.id! : userObj!.id!),));
                     }
                   },
                   onError: (error) {
                     hideLoading();
                     toast(error);
                   });
             }else {
               showLoading();
               create_chat(user_id: "${widget._sellBookingDetails!.data!.userId}" , other_id: "${widget._sellBookingDetails!.data!.productOwnerId}", onSuccess: (BaseModel baseModel) {
                 hideLoading();
                 if(baseModel.data != null && baseModel.code == 200) {
                   Navigator.of(context, rootNavigator: true).push(
                       MaterialPageRoute(builder: (context) =>
                           ChatScreen(user_name: "${widget.adObj?.name ??
                               ""}",
                             chat_Room_id: baseModel.data["room_id"]
                                 .toString(), other_id:widget._sellBookingDetails!.data!.rentar!.id != userObj!.id ? widget._sellBookingDetails!.data!.rentar!.id! :   widget._sellBookingDetails!.data!.rentar!.id == userObj!.id! ? widget._sellBookingDetails!.data!.owner!.id! : userObj!.id!),));
                 }
               }, onError: (error) {
                 hideLoading();
                 toast(error);

               });
             }



           },
           child: Image.asset(
             Style.getIconImage("ic_chat@2x.png"),
             width: 50,
             height: 50,
           ),
         ), images: [], isVideoI: [], videosImages: [],
       );


     }else {
       return  ImageSlider(
         isFromMyAds: false,
         isFromCreatePost: false,
         icLeft:  InkWell(
           onTap: () {
             Navigator.of(context).pop();
           },
           child: Container(
             width: 50,
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
         icRight: InkWell(
           onTap: () {

           },
           child: Image.asset(
             Style.getIconImage("ic_chat@2x.png"),
             width: 50,
             height: 50,
           ),
         ), images: [], isVideoI: [], videosImages: [],
       );
     }

   }

    Widget navigateFrom(){
      if (widget.navigateFrom == "Home") {

        return  Positioned(top: 280, child: RentalSendRequestDetailView(adobj: widget.adObj ,isfromOwner: true,));

      }else if (widget.navigateFrom == "Requests") {


        return Positioned(top: 280, child:

        RentalRequestContentView(isMark: false,
          isConfirm: true,
          isComplete: true,
          isthank: false,
          isAccept: true,
          visible: false,
          request: true,
          sendRequest: true,
          requestUpdate: widget.requestUpdatemain,
          rentalBooking: widget.rentalBookingmain,
          rentalBookingDetails: widget._rentalBookingDetails,));

      }else if (widget.navigateFrom == "RentalRequest") {

        return  Positioned(top: 280, child:

        RentalRequestContentView(isMark: false ,isConfirm: true, isComplete: true, isthank: false ,
          isAccept: false  ,visible: true,request: false, sendRequest: false,rentalBooking: widget.rentalBookingmain,rentalBookingDetails: widget._rentalBookingDetails, ));

      }else if (widget.navigateFrom == "Own") {
        return  Positioned(top: 280, child: RentalSendRequestDetailView(adobj: widget.adObj ,isfromOwner: false,));

      }else if (widget.navigateFrom == "requestrental") {
        return  Positioned(top: 280, child:

        RentalRequestContentView(isMark: false ,isConfirm: true, isComplete: true, isthank: false ,
          isAccept: false  ,visible: false,request: true, sendRequest: true ,requestUpdate: widget.requestUpdatemain,rentalBooking: widget.rentalBookingmain ));

      }else if (widget.navigateFrom == "myAds") {

        return  Positioned(top: 280, child: RentalSendRequestDetailView(adobj: widget.adObj ,isfromOwner: false,));

      }else if (widget.navigateFrom == "SellRequests") {


        return Positioned(top: 280, child:

        SellDetailsRequest(sellBookingDetails: widget._sellBookingDetails,));

      }else{
        return Positioned(top: 280, child: Container(height: 200,));
      }


    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          topNavigationButtons(),
          navigateFrom(),
        ]),
      ),
    );

  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    Observable.instance.notifyObservers([
      "_RentalRequestContentViewState",
    ], notifyName: "custom_data", map: map );

    if (widget.navigateFrom == "Requests") {
      showLoading();
      getRentalBookingDetails(
          slug: widget.rentalBookingmain?.slug ?? "", onSuccess: (data) {
        if(mounted){
          setState((){
            widget._rentalBookingDetails = data;
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
            widget.adObj = adsobj;
            widget.rentalBookingmain = rentalDetails;
          });
        }


        hideLoading();
      }, onError: (error) {
        hideLoading();
        showToast(error);
      }, jsonData: {});
    } else if (widget.navigateFrom == "SellRequests") {
      showLoading();
      getSellBookingDetails(
          slug: widget.rentalBookingmain?.slug ?? "", onSuccess: (data) {
        if(mounted){
          setState((){
            widget._sellBookingDetails = data;
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
            widget.adObj = adsobj;
            widget.rentalBookingmain = rentalDetails;
          });
        }


        hideLoading();
      }, onError: (error) {
        hideLoading();
        showToast(error);
      }, jsonData: {});
    }
  }




}