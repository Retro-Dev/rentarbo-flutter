import 'dart:async';
import 'dart:io';
// import 'dart:js';


import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';


import '../Extensions/style.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';
import '../main.dart';
import 'Const.dart';
import 'Prefs.dart';
import '../View/views.dart';
//
class Dialogs {
//   static Widget SpinnerPicker(
//       {@required TextEditingController controller,
//       @required List list,
//       @required Function onSelectedItemChanged}) {
//     return CupertinoPicker(
//       backgroundColor: Colors.white,
//       onSelectedItemChanged: onSelectedItemChanged,
//       itemExtent: 32.0,
//       children: list.map((e) {
//         return Text(e.toString());
//       }).toList(),
//     );
//   }
//
//   static Future<void> showLoadingDialog(BuildContext context) async {
//     return showDialog<void>(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return new WillPopScope(
//             onWillPop: () async => false,
//             child: SimpleDialog(
// //                  key: key,
//               backgroundColor: Colors.black54,
//               children: <Widget>[
//                 Center(
//                   child: Column(
//                     children: [
//                       CircularProgressIndicator(),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "Please Wait....",
//                         style: TextStyle(color: accentColor),
//                       )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           );
//         });
//   }
//
//   static void hideDialog(BuildContext context) {
//     Navigator.of(context, rootNavigator: true).pop();
//   }
//
//   static Future<void> infoDialog(BuildContext context,
//       {title = "Title",
//       message = "Message",
//       color = accentColor,
//       buttonText = "Close",
//       onTap}) async {
//     Widget dialogContent(context) {
//       return Container(
//         padding: EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             SizedBox(
//               width: 200,
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             AppButton(
//               text: buttonText,
//               onTap: onTap,
//               color: color,
//             )
//           ],
//         ),
//       );
//     }
//
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
// //              Padding(
// //                padding: const EdgeInsets.only(right: 20),
// //                child: Icon(
// //                  Icons.close,
// //                  color: Colors.white,
// //                ),
// //              ),
//               Dialog(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: color, width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 elevation: 0.0,
//                 backgroundColor: primaryColor,
//                 child: dialogContent(context),
//               ),
//             ],
//           );
//         });
//   }
//
//   static Future<void> logoutDialog(BuildContext context,
//       {title = "Title", message = "Message", onTap}) async {
//     Widget dialogContent(context) {
//       return Container(
//         padding: EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               title,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             SizedBox(
//               width: 200,
//               child: Text(
//                 message,
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 AppButton(
//                   text: 'Logout',
//                   width: 20,
//                   height: 5,
//                   onTap: () {
//                     Dialogs.hideDialog(context);
//                     onTap();
//                   },
//                   color: accentColor,
//                 ),
//                 SizedBox(
//                   width: 30,
//                 ),
//                 AppButton(
//                   text: 'Cancel',
//                   width: 20,
//                   height: 5,
//                   onTap: () {
//                     Dialogs.hideDialog(context);
//                   },
//                   color: accentColor,
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     }
//
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Dialog(
//                 shape: RoundedRectangleBorder(
//                   side: BorderSide(color: accentColor, width: 2),
//                   borderRadius: BorderRadius.circular(25),
//                 ),
//                 elevation: 0.0,
//                 backgroundColor: primaryColor,
//                 child: dialogContent(context),
//               ),
//             ],
//           );
//         });
//   }
//
//   // static void stripeDialog(
//   //     {Function(String) onSuccess, Function(String) onError}) {
//   //   StripePayment.setOptions(StripeOptions(
//   //       publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
//   //       merchantId: "Test",
//   //       androidPayMode: 'test'));
//   //   StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
//   //       .then((paymentMethod) {
//   //     onSuccess(paymentMethod.id);
//   //   }).catchError((error) {
//   //     onError(error.toString());
//   //   });
//   // }
//
//   static Future<void> paymentTypeDialog(BuildContext context,
//       {color = accentColor,
//       buttonText = "Next",
//       Function(bool isPayOnline) onTap}) async {
//     List<String> methodsList = ["Pay Online", "Pay Cash"];
//     bool isPayOnline = true;
//     Widget dialogContent(context) {
//       return Container(
//         padding: EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Text(
//               "Select Payment",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: ScreenConfig.safeHorizontalPercent * 6, //28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//             // RadioGroup(
//             //   list: methodsList,
//             //   initValue: methodsList[0],
//             //   color: color,
//             //   onChanged: (value) {
//             //     isPayOnline = (value == methodsList[0]);
//             //   },
//             // ),
//             SizedBox(
//               height: 30,
//             ),
//             AppButton(
//               text: buttonText,
//               onTap: () => onTap(isPayOnline),
//               color: color,
//             )
//           ],
//         ),
//       );
//     }
//
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (context) {
//           return
// //            Material(
// //            color: Colors.transparent,
// //            child: Stack(
// //              children: <Widget>[
// //                Align(
// //                  alignment: Alignment.bottomCenter,
// //                  child: Padding(
// //                    padding: const EdgeInsets.all(40),
// //                    child: IconButton(
// //                      iconSize: 80,
// //                      icon: Image.asset(
// //                        'src/cancel.png',
// //                      ),
// //                      onPressed: () => Navigator.pop(context),
// //                    ),
// //                  ),
// //                ),
//               Dialog(
//             shape: RoundedRectangleBorder(
//               side: BorderSide(color: color, width: 2),
//               borderRadius: BorderRadius.circular(25),
//             ),
//             elevation: 0.0,
//             backgroundColor: primaryColor,
//             child: dialogContent(context),
//           );
// //              ],
// //            ),
// //          );
//         });
//   }
//
// //   static Future<void> selectDateTimeDialog(BuildContext context,
// //       {User user,
// //       color = accentColor,
// //       buttonText = "Challenge",
// //       Function(String Date, String Time) onTap}) async {
// //     String date, time;
// //     Widget dialogContent(context) {
// //       return Container(
// //         padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
// // //        decoration: BoxDecoration(
// // //          image: DecorationImage(
// // //            image: AssetImage('src/popup_bg.png'),
// // //            fit: BoxFit.fill,
// // //          ),
// // //        ),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.stretch,
// //           children: <Widget>[
// //             if (user != null)
// //               MyDrawerHeader(
// //                 name: user.username,
// //                 image: user.image_url,
// //                 desc:
// //                     "${DateTime.now().year - int.parse(user.dob.substring(user.dob.length - 4, user.dob.length))} years | ${user.gender}",
// //               )
// //             else
// //               Column(
// //                 children: <Widget>[
// //                   SizedBox(
// //                     height: 30,
// //                   ),
// //                   Text('Book Schedule',
// //                       style: TextStyle(
// //                         color: Colors.white,
// //                         fontSize: 24,
// //                         letterSpacing: 0.5,
// //                         fontWeight: FontWeight.bold,
// //                       )),
// //                   Text('You can book a time schedule for shooting.',
// //                       textAlign: TextAlign.center,
// //                       style: TextStyle(
// //                         color: Colors.grey,
// //                         fontSize: 12,
// //                       )),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                 ],
// //               ),
// //             datePicker(
// //               buildContext: context,
// //               color: color,
// //               onChange: (text) {
// //                 date = text;
// //               },
// //             ),
// //             SizedBox(
// //               height: 20,
// //             ),
// //             timePicker(
// //               buildContext: context,
// //               color: color,
// //               onChange: (text) {
// //                 time = text;
// // //                String hour = time.substring(0,2);
// // //                String minutes = time.substring(3,5);
// // //                if(time.contains("PM"))
// // //                  hour = (int.parse(hour)+12).toString();
// // //                else{
// // //                  if(hour == "12")
// // //                    hour= "00";
// // //                }
// // //                time = '$hour:$minutes';
// //               },
// //             ),
// //             if (user == null)
// //               Text("\t\t\t*Every Slot will be of 3 Mins.",
// //                   style: TextStyle(
// //                       color: Colors.grey[500], fontSize: 10, height: 2.3)),
// //             SizedBox(
// //               height: 30,
// //             ),
// //             AppButton(
// //               text: buttonText,
// //               onTap: () => onTap(date, time),
// //               color: color,
// //             )
// //           ],
// //         ),
// //       );
// //     }
// //
// //     return showDialog(
// //         context: context,
// //         barrierDismissible: true,
// //         builder: (context) {
// // //          return Material(
// // //            color: Colors.transparent,
// // //            child: Stack(
// // //              children: <Widget>[
// //           return Dialog(
// //             shape: RoundedRectangleBorder(
// //               side: BorderSide(color: color, width: 2),
// //               borderRadius: BorderRadius.circular(25),
// //             ),
// //             elevation: 0.0,
// //             backgroundColor: primaryColor,
// //             child: dialogContent(context),
// //           );
// // //              ],
// // //            ),
// // //          );
// //         });
// //   }
//
  static Widget alertDialog({
    required String title,
    required String content,
    Widget? contentWidget,
    double height = 18,
    double width = 30,
    TextEditingController? reasonController,
    bool reason = false,
    String? leftBtnText,
    String? rightBtnText,
    Function? leftBtnTap,
    Function? rightBtnTap,
    required BuildContext context,
  }) {
    return AlertDialog(
      scrollable: true,
      title: title != null
          ? Text(title,
          style: TextStyle(
            fontFamily: 'Gibson',
            color: Color(0xff000000),
            fontSize: 24,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
            letterSpacing: 0.48,
          ))
          : SizedBox(
        height: 5,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contentWidget != null)
            contentWidget
          else
            Text(content,
                style: TextStyle(
                  fontFamily: Const.aventa,
                  color: Color(0xff000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 0.28,
                )),
          if (reason)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 6,
                ),
                Text("Enter reason",
                    style: TextStyle(
                      fontFamily: Const.aventa,
                      color: Color(0xff000000),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.28,
                    )),
                SizedBox(
                  height: 6,
                ),
               TextField(),
              ],
            ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomOutlineButton(onPressed: () async {
                Navigator.pop(context);



              } , btnText: "Cancel", color: Style.redColor ,fontstyle: TextStyle(fontFamily: Const.aventa , fontSize: 14.sp , color: Style.redColor) ,width: 90.w,),
             SizedBox(width: 5,),
             CustomButton(onPressed: () async {
               Navigator.pop(context);
               await Geolocator.openAppSettings();


             } , btnText: "Go to Settings",color: Colors.red,fontstyle: TextStyle(fontFamily: Const.aventa , fontSize: 13.sp , color: Colors.white),width: 130.w,),
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: new BorderRadius.circular(23)),
    );
  }
}
//
//   static Widget alertInputDialog({
//     @required String title,
//     @required Widget content,
//     @required String leftBtnText,
//     @required String rightBtnText,
//     String midBtnText,
//     @required Function leftBtnTap,
//     @required Function rightBtnTap,
//     Function midBtnTap,
//   }) {
//     return AlertDialog(
//       title: Text(title,
//           style: TextStyle(
//             fontFamily: 'Gibson',
//             color: Color(0xff000000),
//             fontSize: 24,
//             fontWeight: FontWeight.w600,
//             fontStyle: FontStyle.normal,
//             letterSpacing: 0.48,
//           )),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           content,
//           SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               leftBtnText != ""
//                   ? TextButton(
//                       child: Text(leftBtnText,
//                           style: TextStyle(
//                             fontFamily: 'Gibson',
//                             color: Color(0xff78849e),
//                             fontSize: 14,
//                             fontWeight: FontWeight.w400,
//                           )),
//                       onPressed: leftBtnTap,
//                     )
//                   : Text(''),
//               AppButton(
//                 height: 18,
//                 width: 30,
//                 text: rightBtnText,
//                 borderRadius: 23,
//                 color: buttonBackground,
//                 textColor: Colors.white,
//                 onTap: rightBtnTap,
//               )
//             ],
//           ),
//           if (midBtnText != null)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Expanded(
//                     child: AppButton(
//                       height: 18,
//                       // width: 30,
//                       text: midBtnText,
//                       borderRadius: 23,
//                       color: buttonBackground,
//                       textColor: Colors.white,
//                       onTap: midBtnTap,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       shape:
//           RoundedRectangleBorder(borderRadius: new BorderRadius.circular(23)),
//     );
//   }
//
//   static Widget pastDatePickerDialog(
//       {@required DateTime currentDate, @required Function onDateTimeChanged}) {
//     DateTime ageRestrictionTime = currentDate;
//     // DateTime(currentDate.year - 17, currentDate.month, currentDate.day);
//     return CupertinoDatePicker(
//       initialDateTime: ageRestrictionTime,
//       maximumDate: ageRestrictionTime,
//       maximumYear: ageRestrictionTime.year,
//       mode: CupertinoDatePickerMode.date,
//       onDateTimeChanged: onDateTimeChanged,
//     );
//   }
//
//   static Widget futureDateAndTimePickerDialog(
//       {@required DateTime currentDate,
//       @required Function onDateTimeChanged,
//       @required CupertinoDatePickerMode mode,
//       bool use24HourMode = true}) {
//     return CupertinoDatePicker(
//       initialDateTime: currentDate,
//       minimumDate: currentDate,
//       minimumYear: currentDate.year,
//       mode: mode,
//       use24hFormat: use24HourMode,
//       onDateTimeChanged: onDateTimeChanged,
//     );
//   }
// }
//
// class timePicker extends StatefulWidget {
//   Function(String) onChange;
//   String initVal;
//   Color color;
//   BuildContext buildContext;
//
//   timePicker({this.onChange, this.initVal, this.color, this.buildContext});
//
//   @override
//   _timePickerState createState() => _timePickerState();
// }
//
// class _timePickerState extends State<timePicker> {
//   String val = 'Select Time';
//
//   Future _selectTime() async {
//     DateTime time = DateTime.now();
//     time = DateTime(time.year, time.month, time.day, time.hour, 0);
//     return showCupertinoModalPopup<void>(
//       context: context,
// //            semanticsDismissible: true,
//       builder: (BuildContext context) {
//         DateTime _newDateTime = time;
//         return _BottomPicker(
//           child: Column(
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   TextButton(
//                     child: Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.white, fontSize: 13),
//                     ),
//                     onPressed: () {
//                       Dialogs.hideDialog(context);
//                     },
//                   ),
//                   TextButton(
//                     child: Text(
//                       "Submit",
//                       style: TextStyle(color: Colors.white, fontSize: 13),
//                     ),
//                     onPressed: () {
//                       if (_newDateTime != null) {
//                         Dialogs.hideDialog(context);
//                         setState(() {
//                           val = DateFormat("hh:mm a").format(_newDateTime);
//                           widget.onChange(val);
//                         });
//                       } else {
//                         toast("please select time");
//                       }
//                     },
//                   ),
//                 ],
//               ),
//               Expanded(
//                 child: CupertinoTheme(
//                   data: CupertinoThemeData(
//                     textTheme: CupertinoTextThemeData(
//                       dateTimePickerTextStyle:
//                           TextStyle(fontSize: 20, color: Colors.white),
//                     ),
//                   ),
//                   child: CupertinoDatePicker(
//                     backgroundColor: secondaryColor,
//                     mode: CupertinoDatePickerMode.time,
//                     minuteInterval: 3,
//                     initialDateTime: time,
//                     onDateTimeChanged: (DateTime newDateTime) {
//                       _newDateTime = newDateTime;
//                       /*setState(() {
//                         val = DateFormat("hh:mm a").format(newDateTime);
//                         widget.onChange(val);
//                         return val;
// //                        return time = newDateTime;
//                       });
//                       */
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//     DateTime dateTime = DateTime.now();
//     TimeOfDay pickedTime = await showTimePicker(
//         context: widget.buildContext,
//         initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
//         builder: (context, child) {
//           return Theme(
//             data: ThemeData.dark(),
//             child: child,
//           );
//         });
//
//     if (pickedTime != null) {
//       setState(() {
//         val = DateFormat("hh:mm a").format(DateTime(
//             dateTime.year,
//             dateTime.month,
//             dateTime.day,
//             pickedTime.hour,
//             pickedTime.minute)); // => 21-04-2019
//         widget.onChange(val);
//         return val;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return paymentTimeDatePickerLayout(
//         _selectTime, val, widget.color, 'clock', 'down_arrow');
//   }
// }
//
// class _BottomPicker extends StatelessWidget {
//   const _BottomPicker({
//     Key key,
//     @required this.child,
//   })  : assert(child != null),
//         super(key: key);
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 250.0,
//       padding: const EdgeInsets.only(top: 6.0),
// //      color: Colors.blue,
//       decoration: BoxDecoration(
//           color: secondaryColor,
//           borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))),
//       child: DefaultTextStyle(
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 22.0,
//         ),
//         child: GestureDetector(
//           // Blocks taps from propagating to the modal sheet and popping.
// //          onTap: () { toast("click");},
//           child: SafeArea(
//             top: false,
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class datePicker extends StatefulWidget {
//   Function(String) onChange;
//   String initVal;
//   Color color;
//   BuildContext buildContext;
//
//   datePicker({this.onChange, this.initVal, this.color, this.buildContext});
//
//   @override
//   _datePickerState createState() => _datePickerState();
// }
//
// class _datePickerState extends State<datePicker> {
//   String val = 'Select Date';
//
//   Future _selectDate() async {
//     DateTime currTime = DateTime.now();
//     DateTime monthsAfter =
//         DateTime(currTime.year, currTime.month + 2, currTime.day);
// //    DateTime hoursAfter = DateTime.now().add(Duration(hours: 4));
//     DateTime picked = await showDatePicker(
//       context: widget.buildContext,
//       initialDate: currTime,
//       firstDate: currTime.subtract(Duration(days: 1)),
//       lastDate: monthsAfter,
//       builder: (BuildContext context, Widget child) {
//         return Theme(
//           data: ThemeData.dark(),
//           child: child,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         val = DateFormat("dd-MM-yyyy").format(picked); // => 21-04-2019
//         widget.onChange(val);
//         return val;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return paymentTimeDatePickerLayout(
//         _selectDate, val, widget.color, 'calender', 'calender');
//   }
// }
//
// Widget paymentTimeDatePickerLayout(
//     picker, val, color, leadingImageEndpoint, trailingImageEndpoint) {
//   return InkWell(
//     onTap: picker,
//     child: Container(
//       decoration: BoxDecoration(
//         color: secondaryColor,
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Expanded(
//             flex: 2,
//             child: Container(
//               height: 50,
//               width: 50,
//               padding: EdgeInsets.all(11),
//               decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(10),
//                     bottomLeft: Radius.circular(10),
//                   )),
//               child: Image.asset(
//                 'src/$leadingImageEndpoint.svg', color: Colors.black,
//                 height: 30,
//                 width: 30,
// //                scale: 3,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 8,
//             child: Text(
//               '\t\t\t$val',
//               style: TextStyle(
//                 color: Colors.grey[500],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Container(
//               height: 35,
//               width: 35,
//               child: Image.asset(
//                 'src/$trailingImageEndpoint.svg', color: Colors.grey[700],
//                 height: 20,
//                 width: 20, fit: BoxFit.scaleDown,
// //                scale: 3,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
//
// Timer _timer;
//
// Future<void> showLoading() {
//   _timer = Timer(Duration(seconds: 25), () {
//     if (EasyLoading.isShow) {
//       hideLoading();
//       EasyLoading.showToast("Something went Wrong!, Try Again");
//     }
//   });
//
//   return EasyLoading.show(
//     status: "Loading..",
//     maskType: EasyLoadingMaskType.black,
//   );
// }
//
// Future<void> hideLoading() {
//   _timer?.cancel();
//   return EasyLoading.dismiss();
// }
//
// class PreSigInPage extends StatefulWidget {
//   bool _obscure = true;
//   Function(User) callback;
//
//   PreSigInPage({this.callback});
//
//   @override
//   _PreSigInPageState createState() => _PreSigInPageState();
// }
//
// class _PreSigInPageState extends State<PreSigInPage> {
//   var emailFocusNode = FocusNode();
//   var passwordFocusNode = FocusNode();
//   var emailController = TextEditingController();
//   var passwordController = TextEditingController();
//   var _form = GlobalKey<FormState>();
//   UserProvider _provider;
//   String deviceToken;
//
//   signIn() {
//     if (!_form.currentState.validate()) {
//       return;
//     }
//     showLoading();
//     String email = emailController.text;
//     String password = passwordController.text;
//     // print("FCM Token Check: ${await Prefs.getFCMToken}");
//     Prefs.getFCMToken.then((value) {
//       login(
//           email: email,
//           password: password,
//           deviceToken:
//               deviceToken != null ? deviceToken : "Not available right now",
//           deviceType: 'dasdssd',
//           onSuccess: (baseModel) {
//             hideLoading();
//             if (baseModel.status) {
//               var newUser = User.fromJson(baseModel.data);
//               _provider.saveUser(newUser);
//               Provider.of<MenuProvider>(context, listen: false)
//                   .updateCurrentPage(0);
//               Navigator.pop(context);
//               if (widget.callback != null) widget.callback(newUser);
//               toast(baseModel.message);
//             } else {
//               toast(baseModel.message);
//             }
//           },
//           onError: (error) {
//             hideLoading();
//             toast(error);
//           });
//     }).catchError((onError) {
//       toast(onError);
//     });
//   }
//
//   socialSignIn(SocialUser socialUser) async {
//     if (socialUser.socialPlatform == describeEnum(SOCIAL_PLATFORM.APPLE) &&
//         socialUser.email == null) {
//       var dialog = Dialogs.alertDialog(
//         title: "Apple Login",
//         content:
//             "iProWide need to access your info. please do step goto your iphone settings -> tap on your apple ID -> Password and Security -> Apps using Apple ID -> select iProWide app and Stopping using Apple ID ",
//         leftBtnText: "",
//         rightBtnText: "OKAY",
//         rightBtnTap: () {
//           Navigator.pop(context);
//         },
//         leftBtnTap: () {},
//       );
//       showDialog(context: context, builder: (BuildContext context) => dialog);
//       return;
//     } else {
//       showLoading();
//       String deviceToken = await Prefs.getFCMToken;
//       socialLogin(
//           social_id: socialUser.socialID,
//           deviceToken:
//               deviceToken != null ? deviceToken : "Not available right now",
//           deviceType: Platform.isIOS ? 'ios' : 'android',
//           onSuccess: (baseModel) {
//             hideLoading();
//             if (baseModel.status) {
//               User newUser = User.fromJson(baseModel.data);
//               _provider.saveUser(newUser);
//               Provider.of<MenuProvider>(context, listen: false)
//                   .updateCurrentPage(0);
//               Navigator.pop(context);
//               widget.callback(newUser);
//               toast(baseModel.message);
//             } else {
//               toast(baseModel.message);
//             }
//           },
//           onError: (error) {
//             hideLoading();
//             // toast(error);
//             if (error.contains("not found")) {
//               Navigator.pop(context);
//               bottomSheetDialog(
//                   context: context,
//                   pageName: RolePage(
//                     socialUser: socialUser,
//                   )); //Social SignUp
//             }
//           });
//     }
//   }
//
//   @override
//   void initState() {
//     Prefs.getFCMToken.then((value) {
//       deviceToken = value;
//     });
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _provider = Provider.of<UserProvider>(context, listen: false);
//     });
//     super.initState();
//   }
//
//   bool enabled = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Form(
//         key: _form,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text("Please Login to your account",
//                   style: TextStyle(
//                     fontFamily: 'Gibson',
//                     color: Color(0xff279cd9),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                   )),
//             ),
//             SizedBox(
//               height: 5,
//             ),
//             Text(
//               "To post an ad or chat, you need to sign into your account",
//               style: TextStyle(
//                 color: Colors.black,
//                 fontFamily: 'Axiforma',
//                 fontSize: 21,
//                 fontWeight: FontWeight.w800,
//                 fontStyle: FontStyle.normal,
//               ),
//             ),
//             SizedBox(
//               height: 22,
//             ),
//             EditText(
//               validator: (value) {
//                 if (value.trim().isEmpty) {
//                   return 'Email address ${Const.EMPTY}';
//                 }
//                 if (!HelpingMethods().isEmailValid(value.toString())) {
//                   return 'Email address ${Const.INVALID}';
//                 }
//                 return null;
//               },
//               controller: emailController,
//               focusBorderRadius: 5,
//               textInputType: TextInputType.emailAddress,
//               textInputAction: TextInputAction.next,
//               currentFocus: emailFocusNode,
//               nextFocus: passwordFocusNode,
//               enableBorderRadius: 5,
//               focusBordercolor: focusBorderColor,
//               hintText: "Email address",
//               backgroundColor: textFieldBackground,
//               fontFamily: 'Gibson',
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             EditText(
//               onFieldSubmitted: (_) {
//                 signIn();
//               },
//               validator: (value) {
//                 if (value.trim().isEmpty) {
//                   return 'Password ${Const.EMPTY}';
//                 }
//                 return null;
//               },
//               controller: passwordController,
//               focusBorderRadius: 5,
//               currentFocus: passwordFocusNode,
//               focusBordercolor: focusBorderColor,
//               enableBorderRadius: 5,
//               obscure: widget._obscure,
//               suffixClick: () {
//                 setState(() {
//                   widget._obscure = widget._obscure ? false : true;
//                 });
//               },
//               fontFamily: 'Gibson',
//               hintText: "Password",
//               isPassword: true,
//               icon: widget._obscure
//                   ? Icons.visibility_off_outlined
//                   : Icons.visibility_outlined,
//               backgroundColor: textFieldBackground,
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pushNamed(context, ForgotPasswordPage.route);
//                 },
//                 child: Text(
//                   "Forgot Password?",
//                   style: TextStyle(
//                     color: Color(0xff1e263f),
//                     fontSize: 12,
//                     fontFamily: 'Gibson',
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 22.5,
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               child: AppButton(
//                 height: 18,
//                 text: 'SIGN IN',
//                 letterSpacing: 0.8,
//                 color: buttonBackground,
//                 textColor: Colors.white,
//                 onTap: () {
//                   signIn();
//                 },
//               ),
//             ),
//             SizedBox(
//               height: 22.5,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                     width: 110,
//                     height: 1,
//                     decoration: new BoxDecoration(
//                       color: Color(0xffbebebe),
//                     )),
//                 SizedBox(
//                   width: 15.5,
//                 ),
//                 Text(
//                   "or",
//                   style: TextStyle(
//                     color: Color(0xffbebebe),
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                     fontStyle: FontStyle.normal,
//                   ),
//                 ),
//                 SizedBox(
//                   width: 15.5,
//                 ),
//                 Container(
//                     width: 110,
//                     height: 1,
//                     decoration: new BoxDecoration(
//                       color: Color(0xffbebebe),
//                     )),
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             // buildContainer(
//             //     context: context,
//             //     leadingImage: 'src/fb_icon.png',
//             //     title: "Continue with Apple",
//             //     onClick: () {
//             //       print("clicked");
//             //     }),
//             // SizedBox(
//             //   height: 10,
//             // ),
//             buildContainer(
//                 context: context,
//                 leadingImage: 'src/fb_icon.png',
//                 title: "Continue with Facebook",
//                 onClick: () {
//                   if (enabled) {
//                     enabled = false;
//                     facebookLogIn(/*FacebookLogin(),*/ (SocialUser socialUser) {
//                       socialSignIn(socialUser);
//                     }, (String e) {
//                       toast(e);
//                     });
//                     Timer(Duration(seconds: 2), () => enabled = true);
//                   }
//                 }),
//             SizedBox(
//               height: 10,
//             ),
//             buildContainer(
//                 context: context,
//                 leadingImage: 'src/google_icon.png',
//                 title: "Continue with Google",
//                 onClick: () {
//                   googleLogin((SocialUser socialUser) {
//                     socialSignIn(socialUser);
//                   }, (String e) {
//                     toast(e);
//                   });
//                 }),
//             if (Platform.isIOS)
//               SizedBox(
//                 height: 10,
//               ),
//             if (Platform.isIOS)
//               buildContainer(
//                   context: context,
//                   leadingImage: 'src/apple_login.png',
//                   title: "Continue with Apple",
//                   onClick: () {
//                     appleLogin((SocialUser socialUser) {
//                       socialSignIn(socialUser);
//                     }, (String e) {
//                       toast(e);
//                     });
//                   }),
//             SizedBox(
//               height: 10,
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 bottomSheetDialog(
//                     context: context, pageName: RolePage()); //Normal SignUp
//               },
//               child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "Don’t have an account? ",
//                       style: TextStyle(
//                         color: Color(0xff2b3248),
//                         fontFamily: 'Gibson',
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                       )),
//                   TextSpan(
//                       text: "Register Now",
//                       style: TextStyle(
//                         fontFamily: 'Gibson',
//                         color: buttonBackground,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         fontStyle: FontStyle.normal,
//                       )),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     emailFocusNode.dispose();
//     passwordFocusNode.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
// }
//
// class RolePage extends StatefulWidget {
//   SocialUser socialUser;
//
//   RolePage({this.socialUser});
//
//   @override
//   _RolePageState createState() => _RolePageState();
// }
//
// class _RolePageState extends State<RolePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Please select to continue",
//               style: TextStyle(
//                 color: Color(0xff279cd9),
//                 fontFamily: 'Gibson',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 fontStyle: FontStyle.normal,
//               )),
//           SizedBox(
//             height: 8,
//           ),
//           Text("Select your role",
//               style: TextStyle(
//                 color: Color(0xff1e263f),
//                 fontSize: 33,
//                 fontFamily: 'Gibson',
//                 fontWeight: FontWeight.w600,
//                 fontStyle: FontStyle.normal,
//               )),
//           SizedBox(
//             height: 20,
//           ),
//           buildContainer(
//               context: context,
//               leadingImage: 'src/user_icon.png',
//               title: "I am here to Find Local Provider",
//               onClick: () {
//                 signUpPage(false, socialUser: widget.socialUser);
//               }),
//           SizedBox(
//             height: 10,
//           ),
//           buildContainer(
//               context: context,
//               leadingImage: 'src/provider_icon.png',
//               title: "I am here to make money\n (I am a Service Provider)",
//               onClick: () {
//                 signUpPage(true, socialUser: widget.socialUser);
//               }),
//           SizedBox(
//             height: 10,
//           ),
//           buildContainer(
//               context: context,
//               leadingImage: 'src/unknown_icon.png',
//               title: "I don’t know who I am",
//               onClick: () {
//                 Navigator.pushNamed(context, InfoScreen.route, arguments: {
//                   "title": "How it Works",
//                 });
//               }),
//           SizedBox(
//             height: 5,
//           ),
//           Center(
//             child: TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 bottomSheetDialog(pageName: PreSigInPage(), context: context);
//               },
//               child: RichText(
//                 text: TextSpan(children: [
//                   TextSpan(
//                       text: "Already have an account? ",
//                       style: TextStyle(
//                         color: Color(0xff000000),
//                         fontSize: 12,
//                         fontFamily: 'Gibson',
//                         fontWeight: FontWeight.w400,
//                         fontStyle: FontStyle.normal,
//                       )),
//                   TextSpan(
//                       text: "SIGN IN",
//                       style: TextStyle(
//                         fontFamily: 'Gibson',
//                         color: buttonBackground,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         fontStyle: FontStyle.normal,
//                       )),
//                 ]),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   signUpPage(bool isServiceProvider, {SocialUser socialUser}) {
//     Navigator.pushNamed(context, SignUpPage.route, arguments: {
//       'isServiceProvider': isServiceProvider,
//       "socialUser": socialUser
//     }).then((value) {
//       if (value != null) {
//         if (value) {
//           Navigator.pop(context);
//         } else {
//           Navigator.pop(context);
//           bottomSheetDialog(context: context, pageName: PreSigInPage());
//         }
//       }
//     });
//   }
// }
//
// Future<Widget> bottomSheetDialog(
//     {@required BuildContext context, @required Widget pageName}) {
//   return showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (context) => Container(
//       color: Colors.white,
//       child: pageName,
//     ),
//   );
// }
//
// Widget imagePickerDialog({Function onGalleryTap, Function onCameraTap}) {
//   return AlertDialog(
//     title: Text("Select image or take photo",
//         style: TextStyle(
//           fontFamily: 'Gibson',
//           color: Color(0xff000000),
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           fontStyle: FontStyle.normal,
//           letterSpacing: 0.48,
//         )),
//     content: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         imagePickerTile(
//             title: 'Gallery', icon: Icons.image, onTap: onGalleryTap),
//         Divider(),
//         imagePickerTile(
//             title: 'Camera', icon: Icons.camera_alt, onTap: onCameraTap),
//       ],
//     ),
//     backgroundColor: Colors.white,
//     shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
//   );
// }
