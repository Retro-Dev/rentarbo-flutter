import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Extensions/style.dart';
import 'package:rentarbo_flutter/component/custom_button.dart';
import 'package:rentarbo_flutter/component/custom_outline_button.dart';

import '../../Models/SellBookingDetails.dart';
import '../../Models/User.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/Sell_Services.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../Payment/PaymentDetails.dart';
import '../Payment/Payout.dart';

class SellDetailsRequest extends StatefulWidget {
  // const EditPostAd({Key? key}) : super(key: key);
  static const String route = "SellDetailsRequest";
  SellBookingDetails? sellBookingDetails;

  SellDetailsRequest({this.sellBookingDetails});

  @override
  _SellDetailsRequestState createState() => _SellDetailsRequestState();
}

class _SellDetailsRequestState extends State<SellDetailsRequest> with Observer {
  Color delivered = Style.redColor;
  Color picked = Style.redColor;
  String? disputeValue;
  List<File?>? openDisputeImages = [];
  List<Map<String,dynamic>>? disputeImageFiles = [];
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
    disputeValueContr = TextEditingController();
    openDisputeImages = [null];
    load();
    showLoading();
    getSellBookingDetails(
        slug: widget.sellBookingDetails?.data?.slug ?? "",
        onSuccess: (data) {
          // RentalBookingDetails
          if(mounted) {
            setState(() {
              widget.sellBookingDetails = data;
            });
          }
          hideLoading();
        },
        onError: (error) {
          hideLoading();
          showToast(error);
        },
        jsonData: {});
    print("-------------- Status-------------");
    print(widget.sellBookingDetails?.data?.sellStatus);
    print("---------------Status--------------");
    if (widget.sellBookingDetails?.data?.deliveredStatus == "1") {
      delivered = Colors.grey;
    }

    if (widget.sellBookingDetails?.data?.pickedUpStatus == "1") {
      picked = Colors.grey;
    }

    Observable.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 280,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 10.h),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(80.0),
                      child: FadeInImage(
                          width: 80,
                          height: 80,
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeInExpo,
                          fadeOutCurve: Curves.easeOutExpo,
                          placeholder: AssetImage("src/placeholder.png"),
                          image: NetworkImage(
                              widget.sellBookingDetails!.data!.rentar!.id != userObj!.id ? widget.sellBookingDetails!.data!.rentar!.imageUrl ?? Const.INVALID :   widget.sellBookingDetails!.data!.rentar!.id == userObj!.id ? widget.sellBookingDetails!.data!.owner!.imageUrl ?? Const.INVALID  :"${userObj!.imageUrl}",
                              scale: 3.5),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("src/placeholder.png");
                          },
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            widget.sellBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget.sellBookingDetails!.data!.rentar!.name}" :   widget.sellBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget.sellBookingDetails!.data!.owner!.name}" :"${userObj!.name}" ,
                            style: TextStyle(
                                fontFamily: Const.aventaBold,
                                fontWeight: FontWeight.w800,
                                fontSize: 18.sp)),
                        SizedBox(
                          height: 2.5,
                        ),
                        Text(
                          widget.sellBookingDetails!.data!.rentar!.id != userObj!.id ? "${widget.sellBookingDetails!.data!.rentar!.mobileNo}" :   widget.sellBookingDetails!.data!.rentar!.id == userObj!.id ? "${widget.sellBookingDetails!.data!.owner!.mobileNo}" :"${userObj!.mobileNo}" ,
                          style: Style.getBoldFont(18.sp),
                        )
                      ],
                    ),
                  ),
                  Text("\$${widget.sellBookingDetails?.data?.totalCharges}",
                      style: TextStyle(
                          fontFamily: Const.aventaBold,
                          fontWeight: FontWeight.w800,
                          fontSize: 18.sp,
                          color: Style.redColor)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          disputeWidget(widget.sellBookingDetails?.data?.sellStatus ?? ""),
                        SizedBox(height: 4,),
                          statusWidget(
                              widget.sellBookingDetails?.data?.sellStatus ?? ""),

                      ],)),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    "Additional Comments",
                    style: TextStyle(
                        fontFamily: Const.aventaBold,
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp),
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                      padding: EdgeInsets.only(left: 16.w, top: 10.h , right: 16.w),
                      child: Text(
                        "${widget.sellBookingDetails?.data?.additionalInfo}",
                        style: TextStyle(
                            fontFamily: Const.aventaRegular, fontSize: 12.sp),
                      )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: widget!.sellBookingDetails!.data!.product!
                              .hostingDemos!.isNotEmpty
                          ? getHostingDemo(widget!
                              .sellBookingDetails!.data!.product!.hostingDemos!)
                          : Image.asset(Style.getIconImage(
                              "checkbox_checked_icon@2x.png")),
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
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.sellBookingDetails?.data?.rentar?.id !=
                  userObj?.id) // Request(s)
                if (widget.sellBookingDetails?.data?.sellStatus == "pending")
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10.w, right: 10.w, top: 25.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomOutlineButton(
                            btnText: "Reject",
                            height: 50.h,
                            radius: 50.h,
                            fontstyle: TextStyle(
                                fontFamily: Const.aventa,
                                color: Style.redColor,
                                fontSize: 15.sp),
                            onPressed: () {
                              if(mounted) {
                                setState(() {
                                  showLoading();
                                  var jsonParam = {
                                    "type": "status",
                                    "_method": "PUT",
                                    "sell_status": "rejected",
                                    // "device_token": Prefs.getFCMToken,
                                  };

                                  updateSellBookingDetails(
                                      jsonData: jsonParam,
                                      slug:
                                      "${widget.sellBookingDetails?.data
                                          ?.slug ?? 0}",
                                      onSuccess: (data) {
                                        print(
                                            "------------------Data Response --------------------");
                                        print(data);
                                        if(mounted) {
                                          setState(() {
                                            widget.sellBookingDetails = data;
                                            // status = widget.rentalBookingDetails?.data
                                            //         ?.bookingStatus ??
                                            //     "";
                                            // btnText = "Mark as Rented";

                                            toast("Successfully Accepted!");
                                          });
                                        }
                                        print(
                                            "------------------Data Response --------------------");
                                        hideLoading();
                                      },
                                      onError: (error) {
                                        hideLoading();
                                        toast(error);
                                      },
                                      files: []);
                                });
                              }
                            }),
                        SizedBox(
                          width: 15.w,
                        ),
                        CustomButton(
                            btnText: "Accept",
                            color: Style.redColor,
                            radius: 50.h,
                            height: 50.h,
                            fontstyle: TextStyle(
                                fontFamily: Const.aventa,
                                color: Colors.white,
                                fontSize: 15.sp),
                            onPressed: () {
                              if(mounted) {
                                setState(() {
                                  showLoading();
                                  var jsonParam = {
                                    "type": "status",
                                    "_method": "PUT",
                                    "sell_status": "accepted",
                                    // "device_token": Prefs.getFCMToken,
                                  };

                                  updateSellBookingDetails(
                                      jsonData: jsonParam,
                                      slug:
                                      "${widget.sellBookingDetails?.data
                                          ?.slug ?? 0}",
                                      onSuccess: (data) {
                                        print(
                                            "------------------Data Response --------------------");
                                        print(data);
                                        if(mounted) {
                                          setState(() {
                                            widget.sellBookingDetails = data;
                                            // status = widget.rentalBookingDetails?.data
                                            //         ?.bookingStatus ??
                                            //     "";
                                            // btnText = "Mark as Rented";

                                            toast("Successfully Accepted!");
                                          });
                                        }
                                        print(
                                            "------------------Data Response --------------------");
                                        hideLoading();
                                      },
                                      onError: (error) {
                                        hideLoading();
                                        toast(error);
                                      },
                                      files: []);
                                });
                              }
                            })
                      ],
                    ),
                  ),
              if (widget.sellBookingDetails?.data?.rentar?.id != userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "accepted")
                  Padding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 25.h),
                      child: CustomButton(
                          btnText: "Mark as Deliver",
                          color: delivered,
                          radius: 50.h,
                          height: 50.h,
                          width: MediaQuery.of(context).size.width,
                          fontstyle: TextStyle(
                              fontFamily: Const.aventa,
                              color: Colors.white,
                              fontSize: 15.sp),
                          onPressed: () {
                            if(mounted) {
                              setState(() {
                                if (widget.sellBookingDetails?.data
                                    ?.deliveredStatus ==
                                    "0") {
                                  showLoading();

                                  if (userObj?.isPayoutInfo == 0) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PayOUTPopUp()
                                      //thankYouDialog(navigationViewModel,context)
                                    );
                                  } else {
                                    var jsonParam = {
                                      "type": "deliver",
                                      "_method": "PUT",
                                      "delivered_status": "1",
                                      // "device_token": Prefs.getFCMToken,
                                    };

                                    updateSellBookingDetails(
                                        jsonData: jsonParam,
                                        slug:
                                        "${widget.sellBookingDetails?.data
                                            ?.slug ?? 0}",
                                        onSuccess: (data) {
                                          print(
                                              "------------------Data Response --------------------");
                                          print(data);
                                          if(mounted) {
                                            setState(() {
                                              widget.sellBookingDetails = data;

                                              if (widget.sellBookingDetails
                                                  ?.data
                                                  ?.deliveredStatus == "1") {
                                                delivered = Colors.grey;
                                              }
                                              // status = widget.rentalBookingDetails?.data
                                              //         ?.bookingStatus ??
                                              //     "";
                                              // btnText = "Mark as Rented";

                                              toast("Successfully Accepted!");
                                            });
                                          }
                                          print(
                                              "------------------Data Response --------------------");
                                          hideLoading();
                                        },
                                        onError: (error) {
                                          hideLoading();
                                          toast(error);
                                        },
                                        files: []);
                                  }
                                } else {}
                              });
                            }
                          })),
              if (widget.sellBookingDetails?.data?.rentar?.id != userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                  SizedBox(
                    height: 50,
                  ),
              if (widget.sellBookingDetails?.data?.rentar?.id != userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                  if (widget.sellBookingDetails?.data?.pickedUpStatus == "1")
                    if (widget.sellBookingDetails?.data?.deliveredStatus != "1")
                    Padding(
                        padding:
                        EdgeInsets.only(left: 16.w, right: 16.w, top: 25.h),
                        child: CustomButton(
                            btnText: "Mark as Deliver",
                            color: delivered,
                            radius: 50.h,
                            height: 50.h,
                            width: MediaQuery.of(context).size.width,
                            fontstyle: TextStyle(
                                fontFamily: Const.aventa,
                                color: Colors.white,
                                fontSize: 15.sp),
                            onPressed: () {
                              if(mounted) {
                                setState(() {
                                  if (widget.sellBookingDetails?.data
                                      ?.deliveredStatus ==
                                      "0") {
                                    // showLoading();

                                    if (userObj?.isPayoutInfo == 0) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              PayOUTPopUp()
                                        //thankYouDialog(navigationViewModel,context)
                                      );
                                    } else {
                                      var jsonParam = {
                                        "type": "deliver",
                                        "_method": "PUT",
                                        "delivered_status": "1",
                                        // "device_token": Prefs.getFCMToken,
                                      };

                                      updateSellBookingDetails(
                                          jsonData: jsonParam,
                                          slug:
                                          "${widget.sellBookingDetails?.data
                                              ?.slug ?? 0}",
                                          onSuccess: (data) {
                                            print(
                                                "------------------Data Response --------------------");
                                            print(data);
                                            if(mounted) {
                                              setState(() {
                                                widget.sellBookingDetails = data;

                                                if (widget.sellBookingDetails
                                                    ?.data
                                                    ?.deliveredStatus == "1") {
                                                  delivered = Colors.grey;
                                                }
                                                // status = widget.rentalBookingDetails?.data
                                                //         ?.bookingStatus ??
                                                //     "";
                                                // btnText = "Mark as Rented";

                                                toast("Successfully Accepted!");
                                              });
                                            }
                                            print(
                                                "------------------Data Response --------------------");
                                            hideLoading();
                                          },
                                          onError: (error) {
                                            hideLoading();
                                            toast(error);
                                          },
                                          files: []);
                                    }
                                  } else {}
                                });
                              }
                            })),
              if (widget.sellBookingDetails?.data?.rentar?.id != userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                  if (widget.sellBookingDetails?.data?.deliveredStatus == "1")
              Padding(
                padding: EdgeInsets.only(left: 16.w , right: 16.w),
                child: CustomButton(btnText: "Item has been sold",
                    height: 50.h,
                    radius: 50.h,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    fontstyle: TextStyle(
                        fontFamily: Const.aventa,
                        color: Colors.white,
                        fontSize: 15.sp),
                    onPressed: (){}),
              ),
              if (widget.sellBookingDetails?.data?.rentar?.id ==
                  userObj?.id) // Send Requests
                if (widget.sellBookingDetails?.data?.sellStatus ==
                    "pending") // Pending status
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.w, right: 16.w, top: 25.h),
                    child: CustomOutlineButton(
                        btnText: "Pending Confirmation",
                        height: 50.h,
                        radius: 50.h,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.blue,
                        fontstyle: TextStyle(
                            fontFamily: Const.aventa,
                            color: Style.blueColor,
                            fontSize: 15.sp),
                        onPressed: () {}),
                  ),
              if (widget.sellBookingDetails?.data?.rentar?.id == userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "accepted")
                  Padding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 25.h),
                      child: CustomButton(
                          btnText: "Mark as Pick up",
                          color: picked,
                          radius: 50.h,
                          height: 50.h,
                          width: MediaQuery.of(context).size.width,
                          fontstyle: TextStyle(
                              fontFamily: Const.aventa,
                              color: Colors.white,
                              fontSize: 15.sp),
                          onPressed: () {
                            if(mounted) {
                              setState(() {
                                if (widget.sellBookingDetails?.data
                                    ?.pickedUpStatus ==
                                    "0") {
                                  showLoading();

                                  if (userObj?.isCardInfo == 1) {
                                    var jsonParam = {
                                      "type": "pick_up",
                                      "_method": "PUT",
                                      "picked_up_status": "1",
                                      // "device_token": Prefs.getFCMToken,
                                    };

                                    updateSellBookingDetails(
                                        jsonData: jsonParam,
                                        slug:
                                        "${widget.sellBookingDetails?.data
                                            ?.slug ?? 0}",
                                        onSuccess: (data) {
                                          print(
                                              "------------------Data Response --------------------");
                                          print(data);
                                          if(mounted) {
                                            setState(() {
                                              widget.sellBookingDetails = data;
                                              // status = widget.rentalBookingDetails?.data
                                              //         ?.bookingStatus ??
                                              //     "";
                                              // btnText = "Mark as Rented";

                                              toast("Successfully Accepted!");
                                            });
                                          }
                                          print(
                                              "------------------Data Response --------------------");
                                          hideLoading();
                                        },
                                        onError: (error) {
                                          hideLoading();
                                          toast(error);
                                          print(error);
                                        },
                                        files: []);
                                  } else {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) =>
                                            PaymentPopUp()
                                      //thankYouDialog(navigationViewModel,context)
                                    );
                                  }
                                } else {

                                }
                              });
                            }
                          })),
              if (widget.sellBookingDetails?.data?.rentar?.id == userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                  SizedBox(
                    height: 10,
                  ),
              if (widget.sellBookingDetails?.data?.rentar?.id == userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                   if (widget.sellBookingDetails?.data?.pickedUpStatus == "1")
                     if (widget.sellBookingDetails?.data?.deliveredStatus != "1")
                     Padding(
                         padding:
                         EdgeInsets.only(left: 16.w, right: 16.w, top: 25.h),
                         child: CustomButton(
                             btnText: "Mark as Pick up",
                             color: Colors.grey,
                             radius: 50.h,
                             height: 50.h,
                             width: MediaQuery.of(context).size.width,
                             fontstyle: TextStyle(
                                 fontFamily: Const.aventa,
                                 color: Colors.white,
                                 fontSize: 15.sp),
                             onPressed: () {})),
              if (widget.sellBookingDetails?.data?.rentar?.id == userObj?.id)
                if (widget.sellBookingDetails?.data?.sellStatus == "completed")
                  if (widget.sellBookingDetails?.data?.deliveredStatus == "1")
                 Padding(
                   padding: EdgeInsets.only(left: 16.w , right: 16.w),
                   child: CustomButton(btnText: "Item has been sold",
                       height: 50.h,
                       radius: 50.h,
                       width: MediaQuery.of(context).size.width,
                       color: Colors.grey,
                       fontstyle: TextStyle(
                           fontFamily: Const.aventa,
                           color: Colors.white,
                           fontSize: 15.sp),
                   onPressed: (){}),
                 ),
            ],
          ),
        ));
  }

  Widget PaymentPopUp() {
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
                "Rentarbo",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Please enter payment details to begin rental request.",
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
                    btnText: "Payment",
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
                      Navigator.of(context).pushNamed(PaymentDetails.route);
                    },
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
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
  }

  Widget PayOUTPopUp() {
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
                  SizedBox(
                    width: 10.w,
                  ),
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
          if (kDebugMode) {
            print("Dispute Api");
          }

          openDisputeImages = [null];
          disputeValue = null;
          disputeValueContr!.text = "";
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) =>
                  disputePopUp()
            //thankYouDialog(navigationViewModel,context)
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
                              decoration: const InputDecoration.collapsed(hintText: "Please write dispute details.")



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
                              //homeNavigationViewModel.currentScreenIndex = 0;
                              // Navigator.of(context).pushNamed(Payout.route);
                              if(_validateInputs()) {
                                print("Dispute APi");
                                print(disputeValue);
                                if (disputeValue != null) {
                                  var icount = 0;
                                  print("images dispute");
                                  print(openDisputeImages![0]);
                                  if (openDisputeImages!.length > 1) {
                                    openDisputeImages!.removeAt(0);
                                    for (var values in openDisputeImages!) {
                                      disputeImageFiles!.add({
                                        "name": "images[$icount]",
                                        "path": values!.path
                                      });
                                      icount = icount + 1;
                                      if (kDebugMode) {
                                        print(disputeImageFiles!);
                                      }
                                    }

                                    showLoading();
                                    openDisputeApi(module: "bookings",
                                        module_id: "${widget
                                            .sellBookingDetails
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
                                          print(error);
                                          setState(() {
                                            openDisputeImages = [null];
                                            // disputeValue = null;
                                            // disputeValueContr!.text = "";
                                          });
                                          hideLoading();
                                        });
                                  } else {
                                    toast("images required.");
                                    openDisputeImages = [null];
                                    // disputeImageFiles = [];
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
                borderRadius: BorderRadius.circular(20),
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

  Widget getHostingDemo(String? value) {
    if (value == "Yes") {
      return Image.asset(Style.getIconImage("outline-check-icon-blue@2x.png"));
    } else if (value == "No") {
      return Image.asset(Style.getIconImage("checkbox_checked_icon@2x.png"));
    } else {
      return Image.asset(Style.getIconImage("checkbox_checked_icon@2x.png"));
    }
  }

  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      if(mounted) {
        setState(() {
          this.userObj = user;
          print(userObj?.imageUrl);
        });
      }
    });
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    showLoading();
    getSellBookingDetails(
        slug: widget.sellBookingDetails?.data?.slug ?? "",
        onSuccess: (data) {
          // RentalBookingDetails
          if(mounted) {
            setState(() {
              widget.sellBookingDetails = data;
              if (widget.sellBookingDetails?.data?.deliveredStatus == "1") {
                delivered = Colors.grey;
              }

              if (widget.sellBookingDetails?.data?.pickedUpStatus == "1") {
                picked = Colors.grey;
              }
            });
          }
          hideLoading();
        },
        onError: (error) {
          hideLoading();
          showToast(error);
        },
        jsonData: {});
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

}
