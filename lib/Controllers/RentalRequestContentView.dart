
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Controllers/Payment/Payout.dart';
import '../Controllers/Dashboard.dart';
import '../Models/HomeNavigationModel.dart';
import '../../utils/style.dart';
import '../Models/RentalBooking.Dart.dart';
import '../Models/RentalBookingDetails.dart';
import '../Models/User.dart';
import '../Utils/Ads_services.dart';
import '../Utils/BookingAds.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';
import 'ImagePreviewer.dart';


class RentalRequestContentView extends StatefulWidget {
  static const String route = "RentalRequest";
  bool? isMark = false,
      isConfirm = false,
      isComplete = false,
      isthank = false,
      isAccept = true,
      visible = true;

  bool? request = false;
  bool? sendRequest = false;
  GlobalKey? requestUpdate = GlobalKey();
  RentalBookingdatum? rentalBooking;
  RentalBookingDetails? rentalBookingDetails;
  RentalRequestContentView({Key? key, this.isMark , this.isConfirm , this.isComplete , this.isthank , this.isAccept , this.visible,this.request , this.sendRequest , this.requestUpdate , this.rentalBooking , this.rentalBookingDetails}) : super(key: key);

  @override
  State<RentalRequestContentView> createState() => _RentalRequestContentViewState();
}

class _RentalRequestContentViewState extends State<RentalRequestContentView>  with Observer {
  String status = "", btnText = "" , pendingTxt = "";
  ScrollController scrollController = ScrollController();
  late HomeNavigationViewModel navigationViewModel;
  List<File?>? images = [];
  List<File?>? openDisputeImages = [];
  List<Map<String,dynamic>>? imageFiles = [];
  List<Map<String,dynamic>>? disputeImageFiles = [];
  String? commentValue;
  String? disputeValue;
  double? ratting;
  bool isSaleSelected = false;
  bool isRentSelected = true;
  String selectedvalue = "";
  final  productCharges = TextEditingController();
  String? pCharges;
  Color? color = Style.redColor;
  Color? repostColor = Style.redColor;
  TextEditingController? disputeValueContr;


  FocusNode disputeComment = FocusNode();



  bool autoValidate = false, obsure = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_Login');

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: disputeComment),

      ],
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Observable.instance.addObserver(this);
    navigationViewModel = HomeNavigationViewModel();
    disputeValueContr = TextEditingController();
    images = [null];
    openDisputeImages = [null];
    ratting = 3.0;
    load();
    showLoading();
    getRentalBookingDetails(
        slug: widget.rentalBookingDetails!.data!.slug, onSuccess: (data) {
      widget.rentalBookingDetails = data;
      load();
      if(mounted) {
        setState(() {

          RentalBookingdatum? rentalDetails;
          rentalDetails = RentalBookingdatum.fromJson(data.data!.toJson());

          widget.rentalBooking = rentalDetails;

          ratting = 3.0;
          status = widget.rentalBookingDetails!.data!.bookingStatus!;
          images = [null];
          openDisputeImages = [null];

          if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
            widget.request = true;
          } else {
            widget.request = false;
          }
          if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
            if (widget.rentalBookingDetails!.data!.bookingStatus == "accepted") {

              btnText = "Cancel";
            }
            if ((widget.rentalBookingDetails!.data!.bookingStatus ==
                "accepted")) {
              btnText = "Mark as Rented";

            }else
            if (widget.rentalBookingDetails!.data!.bookingStatus == "inprogress") {

              btnText = "Confirm Return";

            }else
            if (widget.rentalBookingDetails!.data!.bookingStatus == "completed") {
              btnText = "Repost";
              if (widget.rentalBookingDetails!.data!.is_repost == "1" ) {
                repostColor = Colors.grey;
              } else {
                repostColor = Style.redColor;
              }
            }
          }
          else {
            if (widget.rentalBookingDetails!.data!.bookingStatus ==
                "accepted") {
              btnText = "Cancel";

            }else

            if (widget.rentalBookingDetails!.data!.bookingStatus ==
                "inprogress") {
              widget.isMark = true;
              widget.isAccept = false;

              btnText = "Mark as Return";


              if (widget.rentalBookingDetails!.data!.returned == "1") {
                color = Colors.grey;
              }
            }else

            if (widget.rentalBookingDetails!.data!.bookingStatus ==
                "completed") {

              btnText = "Rate & Review";
              color = Style.redColor;

              if (widget.rentalBookingDetails!.data!.rating != null) {
                color = Colors.grey;
              } else {
                color = Style.redColor;
              }
            }
          }
        });
      }
      hideLoading();
    }, onError: (error) {
      hideLoading();
      showToast(error);
    }, jsonData: {});


  }

  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
          if(mounted) {
            setState(() {
              userObj = user;
              if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
                widget.request = true;
              } else {
                widget.request = false;
              }
              if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
                if (widget.rentalBooking!.bookingStatus == "accepted") {
                  btnText = "Mark as Rented";
                }else
                if (widget.rentalBooking!.bookingStatus == "inprogress") {

                  btnText = "Confirm Return";
                }else
                if (widget.rentalBooking!.bookingStatus == "completed") {
                  btnText = "Repost";
                  if (widget.rentalBookingDetails!.data!.is_repost == "1") {
                    repostColor = Colors.grey;
                  } else {
                    repostColor = Style.redColor;
                  }
                }
              }
              else {
                if (widget.rentalBookingDetails!.data!.bookingStatus ==
                    "accepted") {
                  btnText = "Cancel";
                }

                if (widget.rentalBookingDetails!.data!.bookingStatus ==
                    "inprogress") {


                  btnText = "Mark as Return";

                  if (widget.rentalBookingDetails!.data!.returned == "1") {
                    color = Colors.grey;
                  }
                }

                if (widget.rentalBookingDetails!.data!.bookingStatus ==
                    "completed") {
                  btnText = "Rate & Review";
                  color = Style.redColor;
                  if (widget.rentalBookingDetails!.data!.rating != null) {
                    color = Colors.grey;
                  } else {
                    color = Style.redColor;
                  }
                }
              }
            });
          }
      });
  }




  Widget getHostingDemo(String? value) {
    if (value == "Yes") {
      return Image.asset(
          Style.getIconImage("outline-check-icon-blue@2x.png"));
    }else if (value == "No") {
        return Image.asset(
            Style.getIconImage("checkbox_checked_icon@2x.png"));
    }else {
      return Image.asset(
          Style.getIconImage("checkbox_checked_icon@2x.png"));
    }
  }




  @override
  Widget build(BuildContext context) {
    navigationViewModel = HomeNavigationViewModel();

    var size = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        setState(() {
          // status = "In progress";
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: size - 300,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              // height: size,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                    SizedBox(
                    width: 44.0,
                    height: 44.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child:   widget.rentalBookingDetails!.data!.rentar!.id != userObj!.id ? circularImageView(image: widget.rentalBookingDetails!.data!.rentar!.imageUrl!) :   widget.rentalBookingDetails!.data!.rentar!.id == userObj!.id ? circularImageView(image: widget.rentalBookingDetails!.data!.owner!.imageUrl!) : Image.asset("src/placeholder.png")
                    ),
                  ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.70,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  widget.rentalBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget.rentalBookingDetails!.data!.rentar!.name}" :   widget.rentalBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget.rentalBookingDetails!.data!.owner!.name}" :"${userObj!.name}" ,
                                  style: Style.getBoldFont(
                                    18.sp
                                  ), maxLines: 2,textWidthBasis: TextWidthBasis.parent,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 8.w,),

                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.rentalBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget.rentalBookingDetails!.data!.rentar!.mobileNo}" :   widget.rentalBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget.rentalBookingDetails!.data!.owner!.mobileNo}" :"${userObj!.mobileNo}" ,
                              style: Style.getBoldFont(16.sp,
                                  color: Style.textBlackColorOpacity80),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "\$${widget.rentalBookingDetails!.data!.totalCharges ?? ""}",
                      textAlign: TextAlign.left,
                      style: Style.getBoldFont(20.sp,
                          color: Style.redColor) ,maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Duration",
                    style: Style.getBoldFont(
                      14.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [durationWidget("${widget.rentalBookingDetails!.data!.duration ?? 0} Hours"), Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [ disputeWidget(status) ,SizedBox(height: 5.h,),statusWidget(status) ],)],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Additional Comments",
                    style: Style.getBoldFont(
                      14.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.rentalBookingDetails!.data!.details ?? "",
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    style: Style.getMediumFont(
                      12.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child:  widget.rentalBooking!.product!.hostingDemos!.isNotEmpty  ?  getHostingDemo(widget.rentalBooking!.product!.hostingDemos!) : Image.asset(
                            Style.getIconImage("checkbox_checked_icon@2x.png")),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Hosting & Demonstration Required",
                        style: Style.getSemiBoldFont(
                          12.sp,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Security License",
                    style: Style.getSemiBoldFont(
                      14.sp,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImagePreviewer(urlString: widget.rentalBookingDetails!.data!.license![0].fileUrl! ,
                                  ))).then((value) {
                            setState(() {});
                          });
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: FadeInImage(
                          width: 150.w,
                          height: 94.w,
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeInExpo,
                          fadeOutCurve: Curves.easeOutExpo,

                          placeholder: const AssetImage("src/placeholder.png"),
                          image:   widget.rentalBookingDetails!.data!.license!.isNotEmpty ?  NetworkImage(widget.rentalBookingDetails!.data!.license![0].fileUrl! ) :  Image.asset("src/placeholder.png" , height: 94.w , width: 150.w,).image,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("src/placeholder.png" , height: 94.w , width: 150.w,);
                          },
                          fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 6,),
                      InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImagePreviewer(urlString: widget.rentalBookingDetails!.data!.license![1].fileUrl! ,
                                  ))).then((value) {
                            setState(() {});
                          });
                        },
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          child: widget.rentalBookingDetails!.data!.license!.isNotEmpty ?  circularImageView(image: widget.rentalBookingDetails!.data!.license!.length > 1 ? "${widget.rentalBookingDetails!.data!.license![1].fileUrl}" : "" , size: 150.w) : Image.asset("src/placeholder.png")
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  userObj!.id == widget.rentalBookingDetails!.data!.owner!.id! ? btnAcceptRejectWidget() : customButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // widget.rentalBookingDetails!.data!.license!.length > 1
  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , fit: BoxFit.cover,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
            fit: BoxFit.cover,
          )),
      height: 94.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 600,
      maxWidthDiskCache: 600,
    );
  }

  Widget statusWidget(String statusText) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: statusText == "pending"
              ? const Color(0xFF707070).withOpacity(0.20)
              : statusText == "completed"
              ? Style.lightGreenColor
              : Style.blueColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
        child: Text(
          statusText,
          style: Style.getBoldFont(14.sp,
              color: statusText == "pending"
                  ? Style.textBlackColor
                  : Style.textWhiteColor),
        ),
      ),
    );
  }

  Widget disputeWidget(String statusText) {
    if (statusText == "completed") {
      return InkWell(
        onTap: () {
            openDisputeImages = [null];
            disputeValue = null;
            disputeValueContr!.text = "";
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) =>
                  disputePopUp()
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Style.redColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            child: Text(
              "Dispute",
              style: Style.getBoldFont(14.sp,
                  color: Style.textWhiteColor),
            ),
          ),
        ),
      );
    }else {
      return const SizedBox();
    }
  }

  Widget durationWidget(String duration) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Style.redColor, width: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
        child: Text(
          duration,
          textAlign: TextAlign.justify,
          style: Style.getBoldFont(12.sp, color: Style.redColor),
        ),
      ),
    );
  }

  Widget imageAttachWidget(String img) {
    return GestureDetector(
      onTap: (() => setState(() {
        widget.isMark = true;
        btnText = "Mark as Returned";
        openBottomSheet(context);
      })),
      child: Container(
          height: 90.h,
          width: 150.w ,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Style.textBlackColor, width: 0.5)),
          child: Image.asset(
            img,
            fit: BoxFit.cover,
          )),
    );
  }

  Widget customButton(BuildContext context) {

    if (status! == "rejected" || status! == "cancelled") {
      return const SizedBox();
    }else {
      return (status! != "pending")
          ? Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
                btnText: btnText!,
                color: color!,
                radius: 50,
                width: 350,
                fontstyle: TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: Const.aventa,
                  fontStyle:  FontStyle.normal,
                  fontSize: 18.sp,
                ),
                onPressed: () {

                  setState(() {
                    if (btnText! == "Mark as Return") {

                      if (widget.rentalBookingDetails!.data!.returned == "0") {
                        _selectImagesForRetrunItems(context);
                      }else {

                      }

                    }

                    if (btnText! == "Cancel") {
                      showLoading();
                      var jsonParam = {
                        "type": "status",
                        "_method": "PUT",
                        "booking_status": "cancell",
                      };

                      updateBookingDetails(jsonData: jsonParam, slug: "${widget.rentalBookingDetails!.data!.slug}", onSuccess: (data){
                        hideLoading();
                        widget.rentalBookingDetails = data;
                        if(mounted) {
                          setState(() {

                            status = widget.rentalBookingDetails!.data!.bookingStatus!;
                            load();
                          });
                        }

                      }, onError: (error){
                        hideLoading();
                        toast(error);
                      }, files: []);


                    }

                    if (btnText! == "Rate & Review") {
                      //Implementation of Ratting popup

                      if (widget.rentalBookingDetails!.data!.rating != null) {

                      }else {
                        _displayRateReivew(context);
                      }
                    }
                  });
                }),
          )
          :
      SizedBox(
        height: 50,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: (() {

            }),
            child:
            Text(
              "Pending Confirmation",
              textAlign: TextAlign.center,
              style: Style.getBoldFont(18.sp, color: Style.blueColor),
            ),
          ),
        ),
      );

    }

  }

  Widget btnAcceptRejectWidget() {
    if (status! == "rejected" || status! == "cancelled"){
      return const SizedBox();
    }else {
      return showBtnOnBookingStatus();
    }

  }

  Widget showBtnOnBookingStatus(){
    if (status! == "pending" ) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomOutlineButton(
              width: 150.w,
              height: 50.w,
              btnText: "Reject",
              fontstyle: const TextStyle(
                color:  Color.fromRGBO(255, 0, 55, 1.0),
                fontWeight: FontWeight.w600,
                fontFamily: Const.aventa,
                fontStyle:  FontStyle.normal,
                fontSize: 15,
              ),
              onPressed: () {
                showLoading();
                var jsonParam = {
                  "type": "status",
                  "_method": "PUT",
                  "booking_status": "reject",
                };

                updateBookingDetails(jsonData: jsonParam, slug: "${widget.rentalBookingDetails!.data!.slug}", onSuccess: (data){
                  setState((){
                    widget.rentalBookingDetails = data;
                    status = widget.rentalBookingDetails!.data!.bookingStatus!;
                    load();
                  });
                  hideLoading();
                }, onError: (error){
                  hideLoading();
                  toast(error);
                }, files: []);

              }),
          SizedBox(
            width: 12.w,
          ),
          CustomButton(
              width: 155.w,
              height: 50.w,
              radius: 25.w,
              btnText: "Accept",
              color: Style.redColor,
              fontstyle:  const TextStyle(
                color:  Colors.white,
                fontWeight: FontWeight.w300,
                fontFamily: Const.aventa,
                fontStyle:  FontStyle.normal,
                fontSize: 15,
              ),
              onPressed: () {
                  showLoading();
                  var jsonParam = {
                    "type": "status",
                    "_method": "PUT",
                    "booking_status": "accept",
                  };

                  updateBookingDetails(jsonData: jsonParam, slug: "${widget.rentalBookingDetails!.data!.slug}", onSuccess: (data){
                    widget.rentalBookingDetails = data;
                    if(mounted) {
                      setState(() {

                        status =
                            widget.rentalBookingDetails!.data!.bookingStatus!;

                        btnText = "Mark as Rented";
                        load();
                        toast("Successfully Accepted!");
                      });
                    }
                    hideLoading();
                  }, onError: (error){
                    hideLoading();
                    toast(error);
                  }, files: []);

              })
        ],
      );
    }else {
      return Align(
        alignment: Alignment.bottomCenter,
        child: CustomButton(
            btnText: btnText!,
            color: repostColor ?? Style.redColor,
            radius: 50,
            width: 350,
            fontstyle: TextStyle(
              color:  Colors.white,
              fontWeight: FontWeight.w300,
              fontFamily: Const.aventa,
              fontStyle:  FontStyle.normal,
              fontSize: 18.sp,
            ),
            onPressed: () {
              if (btnText! == "Mark as Rented") {
                if (userObj!.isPayoutInfo == 1) {

                    showLoading();
                    var jsonParam = {
                      "type": "status",
                      "_method": "PUT",
                      "booking_status": "rented",
                    };

                    updateBookingDetails(jsonData: jsonParam,
                        slug: "${widget.rentalBookingDetails!.data!.slug}",
                        onSuccess: (data) {
                          if(mounted) {
                            setState(() {
                              widget.rentalBookingDetails = data;
                              status =
                              widget.rentalBookingDetails!.data!.bookingStatus!;
                              btnText = "Confirm Return";
                              load();
                            });
                          }
                          hideLoading();
                        },
                        onError: (error) {
                          hideLoading();
                          toast(error);
                        },
                        files: []);

                }else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          paymentPopUp()
                  );
                }
              }else if (btnText! == "Confirm Return") {
                  showLoading();
                  var jsonParam = {
                    "type": "return_confirmed",
                    "_method": "PUT",
                    "return_confirmed" : "1",
                  };

                  updateBookingDetails(jsonData: jsonParam, slug: "${widget.rentalBookingDetails!.data!.slug}", onSuccess: (data){
                    widget.rentalBookingDetails = data;
                        status = widget.rentalBookingDetails!.data!.bookingStatus!;
                          btnText = "Repost";
                        setState((){});


                    hideLoading();
                  }, onError: (error){
                    hideLoading();
                    toast(error);
                  }, files: []);

              }else if (btnText! == "Repost") {
                if (widget.rentalBookingDetails!.data!.is_repost == "0") {
                  setState(() {
                    openBottomSheet(context);
                  });
                }else {

                }

              }
            }),
      );
    }
  }
  FocusNode charges = FocusNode();

  KeyboardActionsConfig _buildConfigCharges(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode:charges ),

      ],
    );
  }

  openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape:  const RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ) ,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
              return SizedBox(
                height: 600,
                child: KeyboardActions(
                  config: _buildConfigCharges(context),
                  autoScroll: true,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: autoValidate
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 16.h,),
                        Center(child: SizedBox(height: 30.h,child: Text("Repost Ad" , style: TextStyle(fontFamily: Const.aventaBold , fontWeight: FontWeight.w800 , fontSize: 18.sp),),)),
                        ListTile(
                          leading: isRentSelected ? Image.asset(Style.getIconImage("round_check_selected_icon@2x.png") , scale: 2.0,) : Image.asset(Style.getIconImage("round_check_unselected_icon@2x.png") , scale: 2.0,),
                          title: Text(
                            "Rent",
                            style: Style.getSemiBoldFont(14.sp),
                          ),
                          onTap: () {
                            setState((){
                              isRentSelected = true;
                              isSaleSelected = false;
                            });


                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFDFE1E5),
                          ),
                        ),
                        ListTile(
                          leading: isSaleSelected ? Image.asset(Style.getIconImage("round_check_selected_icon@2x.png") , scale: 2.0,) : Image.asset(Style.getIconImage("round_check_unselected_icon@2x.png") , scale: 2.0,),
                          title: Text(
                            "Sale",
                            style: Style.getSemiBoldFont(
                              14.sp,
                            ),
                          ),
                          onTap: () {
                            setState((){
                              isSaleSelected = true;
                              selectedvalue = "sale";
                              isRentSelected = false;
                            });

                            // _displayThankYouDialog(context);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFDFE1E5),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        if (isSaleSelected == true && isRentSelected == false)
                          SizedBox(height: 6.h),
                        if (isSaleSelected == true && isRentSelected == false)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20.w , right: 16.w),
                              child: Text(
                                "Charges",
                                textAlign: TextAlign.start,
                                style: Style.getSemiBoldFont(14.sp,
                                    color: Style.textBlackColorOpacity80),
                              ),
                            ),
                          ),
                        if (isSaleSelected == true && isRentSelected == false)
                        SizedBox(height: 6.h),
                        if (isSaleSelected == true && isRentSelected == false)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w , right: 16.w),
                          child: EditText(
                            context: context,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.number,
                            hintText: "Sell Charges",
                            controller: productCharges,
                            currentFocus: charges,
                            validator:validateField,

                            // nextFocus: productSSNNoFocus,
                            prefixiconData: Icons.attach_money,
                            onSaved: (text) {
                              pCharges = text;

                            },
                            onChange: (text) {
                              pCharges = text;
                            },
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        CustomButton(btnText: "Submit",fontstyle: TextStyle(
              color:  Colors.white,
              fontWeight: FontWeight.w300,
              fontFamily: Const.aventa,
              fontStyle:  FontStyle.normal,
              fontSize: 18.sp,
              ),
                            width: 220.w,
                            radius: 50.h ,
                            height: 50.h,
                            onPressed: () {
                              if (_validateInputs()) {
                                //Repost APi .....
                                if (isSaleSelected == true &&
                                    isRentSelected == false) {

                                  var jsonParam = {
                                    "product_id": widget.rentalBooking
                                        ?.productId,
                                    "is_repost": "yes",
                                    "is_sell": "1",
                                    "sell_price": pCharges,
                                    "booking_id" : widget.rentalBooking?.id

                                  };
                                  showLoading();
                                  rePostAds(
                                      jsonData: jsonParam, onSuccess: (data) {
                                    hideLoading();
                                    toast(data);
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            thankYoupopUp()
                                    );
                                  }, onError: (error) {
                                    hideLoading();
                                    showToast(error);
                                  });
                                } else {

                                  var jsonParam = {
                                    "product_id": widget.rentalBooking
                                        ?.productId,
                                    "is_repost": "yes",
                                    "booking_id" : widget.rentalBooking?.id,
                                  };
                                  showLoading();
                                  rePostAds(
                                      jsonData: jsonParam, onSuccess: (data) {
                                    hideLoading();
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            thankYoupopUp()
                                      //thankYouDialog(navigationViewModel,context)
                                    );
                                  }, onError: (error) {
                                    hideLoading();
                                    toast(error);
                                  });
                                }
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              );
          }

          );
        });
  }

  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }


  Widget paymentPopUp() => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Rentarbo",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Please enter payout details to begin rental request.",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomButton(
                    btnText: "Payout",
                    radius: 25.w,
                    height: 50.w,
                    width: 110.w,
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
                      Navigator.of(context).pushNamed(Payout.route);
                    },
                  ),
                  SizedBox(width: 10.w,),
                  CustomButton(
                    btnText: "Cancel",
                    radius: 25.w,
                    height: 50.w,
                    width: 110.w,
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
                      Navigator.of(context).pop();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );



  Widget disputePopUp() => StatefulBuilder(
      builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
        return KeyboardActions(
          config: _buildConfig(context),
          autoScroll: true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            content: Form(
              key:_formKey ,
              autovalidateMode: autoValidate
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: SizedBox(
                height: 410,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Open Dispute",
                        style: Style.getBoldFont(
                          22.sp,
                        ),
                      ),
                      SizedBox(height: 14.w,),
                      Container(
                        height: 115.h,
                        width: 230.w,
                        margin: EdgeInsets.only(left: 0.w , right: 2.5.w ),
                        padding: EdgeInsets.only(top: 0.5.w , left: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(color: Colors.grey, spreadRadius: 1.5),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 17 ,right: 8.0 ),
                          child: TextField(
                            // textAlign: TextAlign.center,
                              maxLines: 3,
                              focusNode: disputeComment,
                              controller: disputeValueContr!,
                              onChanged: (value) {
                                disputeValue = value;
                              },
                              onSubmitted: (value) {
                                disputeValue = value;
                              },
                              decoration: const InputDecoration.collapsed(hintText: "Please write dispute details")



                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Text("Upload images for dispute."),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding: const EdgeInsets.only(left: 16 , right: 16 , top: 5 , bottom: 5),
                        child: SizedBox(
                          height: 60.h,
                          width: MediaQuery.of(context).size.width ,
                          child:ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: openDisputeImages!.length,
                            itemBuilder: (context, index) =>

                                openDisputeShowImages(index,setState),

                            separatorBuilder: (context, index) => SizedBox(
                              width: 8.w,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomButton(
                            btnText: "Cancel",
                            radius: 25.w,
                            height: 50.w,
                            width: 110.w,
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
                              openDisputeImages = [null];
                              disputeValue = null;
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(width: 5.w,),
                          CustomButton(
                            btnText: "Dispute",
                            radius: 25.w,
                            height: 50.w,
                            width: 110.w,
                            fontSize: 12.sp,
                            fontstyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: Const.aventa,
                              fontStyle: FontStyle.normal,
                              fontSize: 18.sp,
                            ),
                            onPressed: () {
                              if(_validateInputs()) {
                                if (disputeValue != null) {
                                  var icount = 0;
                                  if (openDisputeImages!.length > 1) {
                                    openDisputeImages!.removeAt(0);
                                    for (var values in openDisputeImages!) {
                                      disputeImageFiles!.add({
                                        "name": "images[$icount]",
                                        "path": values!.path
                                      });
                                      icount = icount + 1;
                                    }

                                    showLoading();
                                    openDisputeApi(module: "bookings",
                                        module_id: "${widget
                                            .rentalBookingDetails
                                            ?.data
                                            ?.id}",
                                        description: disputeValue,
                                        files: disputeImageFiles!,
                                        onSuccess: (data) {
                                          toast(data.message);
                                          Navigator.of(context).pop();
                                          hideLoading();
                                        },
                                        onError: (error) {
                                          toast(error);
                                          setState(() {
                                            openDisputeImages = [null];
                                          });
                                          hideLoading();
                                        });
                                  } else {
                                    toast("images required.");
                                  }
                                } else {
                                  toast("description required.");
                                }
                              }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

  );


  Widget thankYoupopUp() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: SizedBox(
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
                "Your Ad has been reposted successfully.",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
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



  _displayRateReivew(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 50),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: Colors.white.withAlpha(100),
              body: Center(
                child: Container(
                  height: 355.h,
                  width: 330.w,

        decoration: const BoxDecoration(
            color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0),)),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 // crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   SizedBox(height: 13.w,),
                   Center(child:
                   ClipRRect(
                     borderRadius: BorderRadius.circular(60),
                     child: FadeInImage(
                       height: 60,
                       width: 60,
                         fadeInDuration: const Duration(milliseconds: 500),
                         fadeInCurve: Curves.easeInExpo,
                         fadeOutCurve: Curves.easeOutExpo,
                         placeholder: const AssetImage("src/placeholder.png"),
                         image: NetworkImage(userObj?.imageUrl ?? Const.IMG_DEFUALT,
                             scale: 3.5),
                         imageErrorBuilder: (context, error, stackTrace) {
                           return Image.asset("src/placeholder.png" , height: 60, width: 60,);
                         },
                         fit: BoxFit.cover),
                   ),
                   ),
                   SizedBox(height: 5.5.h,),
                   Text(userObj?.name ?? "" ,style: const TextStyle(fontFamily: "Aventa" , fontWeight: FontWeight.bold),),
                   SizedBox(height: 15.5.w,),
              Padding(
                padding: EdgeInsets.only(left: 40.w ,right: 40.w ),
                child: RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  glow: false,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratting = rating;
                  },
                ),
              ),
                   SizedBox(height: 16.w,),
                   Container(
                     height: 90.w,
                     margin: EdgeInsets.only(left: 35.w , right: 35.w ),
                     padding: EdgeInsets.only(top: 0.5.w , left: 18.w),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(10),
                       color: Colors.white,
                       boxShadow: const [
                         BoxShadow(color: Colors.grey, spreadRadius: 1.5),
                       ],
                     ),
                     child: Padding(
                       padding: const EdgeInsets.only(top: 17 ,right: 8.0 ),
                       child: TextField(
                         // textAlign: TextAlign.center,
                         maxLines: 3,

                         onChanged: (value) {
                           commentValue = value;
                         },
                           onSubmitted: (value) {
                           commentValue = value;
                           },
                           decoration: const InputDecoration.collapsed(hintText: "Please write your review")



                       ),
                     ),
                   ),
                  SizedBox(height: 12.5.w,),
                   Padding(
                     padding:  EdgeInsets.only(left: 28.w , right: 28.w),
                     child: CustomButton(
                         btnText: "Submit",
                         color: Style.redColor,
                         radius: 50,
                         width: 350,
                         fontstyle: TextStyle(
                           color:  Colors.white,
                           fontWeight: FontWeight.w300,
                           fontFamily: Const.aventa,
                           fontStyle:  FontStyle.normal,
                           fontSize: 18.sp,
                         ),
                         onPressed: () {

                           if (commentValue != null || commentValue!.isNotEmpty) {
                             showLoading();
                             var jsonParam = {
                               "booking_id": "${widget.rentalBookingDetails?.data?.id}",
                               "comment": commentValue ?? "",
                               "rating": ratting ?? 0.0.round()
                             };
                             addCommentForBooking(jsonData: jsonParam, onSuccess: (data) {
                               hideLoading();
                               setState(() {
                                 Navigator.pushNamedAndRemoveUntil(context, Dashboard.route, (route) => false);
                               });
                             }, onError: (error) {
                                hideLoading();
                                toast(error);
                             });
                           }else {
                             toast("Comment field required.");
                           }
                         }),
                   ),
                 ],
               )
                ),
              ),
            ));
      },
    );
  }

  _selectImagesForRetrunItems(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 50),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
            return  SafeArea(
                top: false,
                child: Scaffold(
                  backgroundColor: Colors.white.withAlpha(100),
                  body: Center(
                    child: Container(
                        height: 300.h,
                        width: 330.w,

                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0),)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h,),
                            Center(child: Text("Upload Images" , style: TextStyle(fontSize: 22.sp , fontFamily: Const.aventaBold),)),
                            SizedBox(height:24.h ,),
                            const Center(child: Text("Select or capture images for return item.")),
                            SizedBox(height: 24.h,),
                            Padding(
                              padding: const EdgeInsets.only(left: 16 , right: 16),
                              child: SizedBox(
                                height: 90.h,
                                // width: MediaQuery.of(context).size.width - 200,
                                child:ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images!.length,
                                  itemBuilder: (context, index) =>

                                      showImages(index,setState),

                                  separatorBuilder: (context, index) => SizedBox(
                                    width: 8.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h,),
                            Padding(
                              padding: EdgeInsets.only(left: 16.w , right: 8.w),
                              child: Row(
                                children: [
                                  CustomOutlineButton(btnText: "Cancel",
                                      fontstyle: const TextStyle(color: Colors.redAccent , fontFamily: Const.aventaBold),
                                      width: 135.w,
                                      height: 50.h,
                                      onPressed: (){
                                      Navigator.of(context).pop();
                                  }),
                                  SizedBox(width: 15.w, ),
                                  CustomButton(btnText: "Submit",
                                      height: 50.h,
                                      radius: 50.h,
                                      fontstyle: const TextStyle(fontFamily:Const.aventaBold ),

                                      onPressed: () {
                                        showLoading();
                                        var jsonParam = {
                                          "type": "return",
                                          "_method": "PUT",
                                          "return" : "1",
                                        };
                                        var icount = 0;
                                        images!.removeAt(0);
                                        for (var values in images!){
                                          imageFiles!.add({"name":"images[$icount]","path":values!.path});
                                          icount = icount + 1;
                                        }
                                        updateBookingDetails(jsonData: jsonParam, slug: "${widget.rentalBookingDetails?.data?.slug ?? 0}", onSuccess: (data){
                                          setState((){
                                            widget.rentalBookingDetails = data;
                                            status = widget.rentalBookingDetails?.data?.bookingStatus ?? "";
                                            Navigator.of(context).pop();
                                          });
                                         setState((){
                                           updateMarkasReturn();
                                         });
                                          hideLoading();
                                        }, onError: (error){
                                          hideLoading();
                                          toast(error);
                                          setState((){

                                            imageFiles = [];
                                            images = [null];
                                          });
                                        }, files: imageFiles!);
                                  }),
                                ],
                              ),
                            )

                          ],
                        )
                    ),
                  ),
                ));
          }

        );
      },
    );
  }

  void updateMarkasReturn(){
    setState((){
      if (widget.rentalBookingDetails?.data?.returned == "1") {
        color = Colors.grey;
      }
    });
  }
  Widget showImages(int index , StateSetter setStatemain) {
    if (index == 0) {

      return Stack(
        children: [
          SizedBox(
            height: 90.h,
            child: GestureDetector(
              onTap: () {
                if(images![0] == null) {
                  showImageSelectOption(
                      context, false, (image, isVideo, imagethump) async {
                    if (mounted) {
                      setStatemain(() {
                        images!.add(image);
                      });
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    // boxShadow: [
                    //   BoxShadow(
                    //       color: Colors.grey.withOpacity(0.3),
                    //       spreadRadius: 3,
                    //       offset: const Offset(0, 10),
                    //       blurRadius: 10
                    //   )
                    // ]
                ),

                height: 90.h,
                width: 120.w,
                child: Image.asset("src/FrontImg@3x.png", scale: 6,),
              ),
            ),

          ),
        ],


      );
    }else  {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
            ),

            height: 90.h,
            width: 120.w,
            child: images![index] != null ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(images![index]! , fit: BoxFit.fill))   : Image.asset("src/FrontImg@3x.png", scale: 6,),
          ),
          if(images![index] == null)
            Positioned(
              right: 22.w,
              bottom: 3.h,
              child: Text("Back Image" , style: TextStyle(fontFamily: Const.aventa , fontSize: 12.sp),),
            ),
          if(images![index] != null)
            Positioned(
              right: 4.25.w,
              top: 8.h,
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: GestureDetector(
                  onTap: () async {


                    if(mounted){
                      setStatemain((){

                        images!.removeAt(index);

                      });
                    }



                  },
                  child: Image.asset("src/closebtn@3x.png"),
                ),
              ),
            ),

        ],


      );

    }
  }

  Widget openDisputeShowImages(int index , StateSetter setStatemain) {
    if (index == 0) {

      return Stack(
        children: [
          SizedBox(
            height: 90.h,
            child: GestureDetector(
              onTap: () {
                if(openDisputeImages![0] == null) {
                  showImageSelectOption(
                      context, false, (image, isVideo, imagethump) async {
                    if (mounted) {
                      setStatemain(() {
                        openDisputeImages!.add(image);
                      });
                    }
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          offset: const Offset(0, 10),
                          blurRadius: 6
                      )
                    ]
                ),

                height: 90.h,
                width: 90.w,
                child: Image.asset("src/FrontImg@3x.png", scale: 6,),
              ),
            ),

          ),
        ],


      );
    }else  {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      offset: const Offset(0, 10),
                      blurRadius: 6
                  )
                ]
            ),

            height: 90.h,
            width: 90.w,
            child: openDisputeImages![index] != null ? ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(openDisputeImages![index]! , fit: BoxFit.fill))   : Image.asset("src/FrontImg@3x.png", scale: 6,),
          ),
          if(openDisputeImages![index] == null)
            Positioned(
              right: 22.w,
              bottom: 3.h,
              child: Text("Back Image" , style: TextStyle(fontFamily: Const.aventa , fontSize: 12.sp),),
            ),
          if(openDisputeImages![index] != null)
            Positioned(
              right: 4.25.w,
              top: 8.h,
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: GestureDetector(
                  onTap: () async {


                    if(mounted){
                      setStatemain((){

                        openDisputeImages!.removeAt(index);

                      });
                    }



                  },
                  child: Image.asset("src/closebtn@3x.png"),
                ),
              ),
            ),

        ],


      );

    }
  }


  Widget thankYouWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Style.thankYouBaclgroundColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Style.getIconImage("ic_thankyou.png")),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Thank You!",
              style: Style.getBoldFont(22.sp, color: Style.textWhiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Proin ex ipsum, facilisis id tincidunt sed,",
              style: Style.getSemiBoldFont(16.sp, color: Style.textWhiteColor),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => setState(() {
                widget.isConfirm = true;
                widget.isthank = false;
              }),
              child: Text(
                "Continue",
                style: Style.getSemiBoldFont(14.sp, color: Style.blueColor),
              ),
            ),
          ]),
    );
  }

  Widget rateReviewPopUpWiget(BuildContext context) {
    return Container(height: 200,width: 200, color: Colors.red,);
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
        navigationViewModel = HomeNavigationViewModel();

     showLoading();
     getRentalBookingDetails(
         slug: map!["slug"].toString(), onSuccess: (data) {
       // RentalBookingDetails
       // rentalBookingDetails = data;
       widget.rentalBookingDetails = data;
       if(mounted) {
         setState(() {

           RentalBookingdatum? rentalDetails;
           rentalDetails = RentalBookingdatum.fromJson(data.data!.toJson());

           widget.rentalBooking = rentalDetails;

           ratting = 3.0;
           status = widget.rentalBookingDetails?.data?.bookingStatus ?? "";
           images = [null];
           load();

           if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
             widget.request = true;
           } else {
             widget.request = false;
           }
           if (userObj!.id != widget.rentalBookingDetails!.data!.userId!) {
             if (widget.rentalBookingDetails!.data!.bookingStatus  == "accepted") {
                btnText = "Cancel";

             }
             if (widget.rentalBookingDetails!.data!.bookingStatus == "accepted") {
               btnText = "Mark as Rented";

             }else
             if (widget.rentalBookingDetails!.data!.bookingStatus == "inprogress") {

               btnText = "Confirm Return";


             }else
             if (widget.rentalBookingDetails!.data!.bookingStatus == "completed") {
               btnText = "Repost";


               if (widget.rentalBookingDetails!.data!.is_repost == "1") {
                 repostColor = Colors.grey;
               } else {
                 repostColor = Style.redColor;
               }

             }
           }
           else {
             if (widget.rentalBookingDetails!.data!.bookingStatus ==
                 "accepted") {
               btnText = "Cancel";

             }else

             if (widget.rentalBookingDetails!.data!.bookingStatus ==
                 "inprogress") {

               btnText = "Mark as Return";


               if (widget.rentalBookingDetails!.data!.returned == "1") {
                 color = Colors.grey;
               }
             }else

             if (widget.rentalBookingDetails!.data!.bookingStatus ==
                 "completed") {
               btnText = "Rate & Review";
               load();
               color = Style.redColor;
               if (widget.rentalBookingDetails!.data!.rating != null) {
                 color = Colors.grey;
               } else {
                 color = Style.redColor;
               }
             }
           }
         });
       }
       hideLoading();
     }, onError: (error) {
       hideLoading();
       showToast(error);
     }, jsonData: {});



  }

  }