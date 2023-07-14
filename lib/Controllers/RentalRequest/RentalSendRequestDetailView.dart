import 'dart:ffi';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:rentarbo_flutter/Controllers/Payment/PaymentDetails.dart';
import 'package:rentarbo_flutter/Controllers/RentalRequest/PurchaseRequestView.dart';
import 'package:rentarbo_flutter/Controllers/RentalRequest/RentalSendRequestView.dart';
import 'package:rentarbo_flutter/Controllers/Reviews.dart';
import '../../Controllers/Dashboard.dart';
import '../../Extensions/colors_utils.dart';
import '../../Models/Ads.dart';
import '../../Models/HomeNavigationModel.dart';
import '../../Models/User.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../component/Spinner.dart';
import '../../component/custom_button.dart';
import '../../utils/style.dart';


class RentalSendRequestDetailView extends StatefulWidget {
  static const String route = "RentalSendRequestDetailView";
  AdsObj? adobj;
  bool? isfromOwner;

  // const RentalSendRequestDetailView({Key? key}) : super(key: key);
  RentalSendRequestDetailView({this.adobj, this.isfromOwner});

  @override
  _RentalSendRequestDetailViewState createState() =>
      _RentalSendRequestDetailViewState();
}

class _RentalSendRequestDetailViewState
    extends State<RentalSendRequestDetailView> {
  String status = "Pending",
      btnText = "Cancel";
  ScrollController scrollController = new ScrollController();
  late HomeNavigationViewModel navigationViewModel;
  bool isMark = false,
      isConfirm = false,
      isComplete = false,
      isthank = false,
      isAccept = true,
      visible = true;

  bool request = false;

  FocusScopeNode? currentfocus;

  //required Data
  String? nameOfPerson;
  String? phoneNumber;
  String? additionalDetails;
  String? duration;
  bool? hostingDemonstration;
  List<Map<String,dynamic>>? imageFiles = [];
  Country _selectedDialogCountry = Country(isoCode: "US", iso3Code: "USA", phoneCode: "1", name: "USA");
  TextEditingController? fromTextController;
  TextEditingController?   toTextController;
  var toDate;
  var fromDate;
  var fromtime;
  var tofinalDate;
  var fromfinalDate;
  var totime;
  bool? dobIssue = true;

  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
        print(userObj?.imageUrl);
      });
    });
  }

  Future<void> _selectTime(BuildContext context, String type) async {
    // var picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        // selectableDayPredicate: _predicate,
        // firstDate: DateTime.now(),
        // lastDate: DateTime(2025),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              primaryColor: ColorUtils.primary,
              accentColor: ColorUtils.primary,
              colorScheme: ColorScheme.light(primary: ColorUtils.primary),
              disabledColor: Colors.brown,
              textTheme:
              TextTheme(bodyText1: TextStyle(color: ColorUtils.primary)),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != DateTime.now()){
      print(picked);
      if(type == "from"){
        setState(() {
          fromTextController?.text = picked.toString().replaceAll("TimeOfDay(", "").replaceAll(")", "");
          fromtime = picked.toString().replaceAll("TimeOfDay(", "").replaceAll(")", "");
        });
      }
      else{
        setState(() {
          toTextController?.text = picked.toString().replaceAll("TimeOfDay(", "").replaceAll(")", "");
          totime = picked.toString().replaceAll("TimeOfDay(", "").replaceAll(")", "");
        });
      }
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigationViewModel = HomeNavigationViewModel();
    print(widget.adobj?.hostingDemos);
    images = [null , null];
    print("------------Screen Size------------");
    print(((widget.adobj!.tags!.length! / 100) * 50 ));
    print("------------Screen Size------------");
    hostingDemonstration = false;
    fromTextController = TextEditingController();
    toTextController = TextEditingController();
    load();
  }

  bool sendRequest = false;

  facilites() {
    for (var value in this.widget.adobj!.tags!) {
      facilitiesView("${value}");
      SizedBox(width: 8,);
    }
  }


  FocusNode nameOfPersonFocus = FocusNode(),
      phoneNumberFocus = FocusNode(),
      additionalDetailsFocus = FocusNode(),
      starTimeFocus = FocusNode(),
      endTimeFocus = FocusNode(),
      selectDateFocus = FocusNode();



  bool autoValidate = false,
      obsure = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(
      debugLabel: 'sendRequest');

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: nameOfPersonFocus),
        KeyboardActionsItem(focusNode: phoneNumberFocus),
        KeyboardActionsItem(focusNode: additionalDetailsFocus),
        KeyboardActionsItem(focusNode: starTimeFocus),
        KeyboardActionsItem(focusNode: endTimeFocus),
        KeyboardActionsItem(focusNode: selectDateFocus),

      ],
    );
  }


  List<String>? durations = ["2 Hour Durtion","5 Hour Duration" , "12 Hour Duration"];
  List<File?>? images = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: (MediaQuery
          .of(context)
          .size
          .height) - (widget.adobj!.description!.length! - 330),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: SingleChildScrollView(
        controller: scrollController,
        // physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            height: size <= 750
                ? MediaQuery
                .of(context)
                .size
                .height *  1.62 + ((widget.adobj!.tags!.length! / 100) * 320 )
                : MediaQuery
                .of(context)
                .size
                .height *  1.45 + ((widget.adobj!.tags!.length! / 100) * 50 ),
            child: !sendRequest
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${this.widget.adobj?.name ?? ""}",
                        style: TextStyle(overflow: TextOverflow.clip ,fontFamily: Const.aventa , fontSize: 22.sp , fontWeight: FontWeight.w800),

                      ),
                    ),
                    Row(
                      children: [
                        Image.asset(
                            Style.getIconImage("ic_rating@2x.png")),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "(${this.widget.adobj?.rating ?? ""})",
                          style: Style.getBoldFont(
                            22.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${this.widget.adobj?.category?.name ?? ""}",
                      style: Style.getBoldFont(16.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Reviews.route , arguments: {'reviewsAvg' : this.widget.adobj!.rating.toString() , 'reviewsCount' : this.widget.adobj!.reviews , 'product_id' : this.widget.adobj!.id});
                      },
                      child: Text(
                        "Reviews (${this.widget.adobj?.reviews ?? ""})",
                        style: Style.getRegularFont(12.sp,
                            color: Style.blueColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\$${widget.adobj?.rentCharges ?? ""}\/${widget.adobj
                            ?.rentType ?? ""}",
                        style: TextStyle(fontFamily: Const.aventa,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: Style.redColor),
                      ),
                      Spacer(),
                      widget.adobj!.isSell == 1 ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Sale Price" , style:  TextStyle(fontFamily: Const.aventa,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w900,
                              color: Style.redColor),),
                          Text("\$${widget.adobj!.sellPrice}",style:  TextStyle(fontFamily: Const.aventa,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w900,
                              color: Style.redColor)),

                        ],
                      ) : SizedBox()

                      // SizedBox(width: 8.w,),
                      // facilitiesView( returnRentType("${widget.adobj?.rentType ?? ""}") ?? "")

                    ]

                ),
                // Text(
                //   "\$${widget.adobj?.rentCharges ?? ""}",
                //   style: Style.getBoldFont(20.sp, color: Style.redColor),
                // ),
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
                  "${this.widget.adobj?.description ?? ""}",
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
                  spacing: 0.5,
                  runSpacing: 0.5,

                  children: [
                    for(var values in widget.adobj?.tags ?? [])
                      Container(
                        padding: EdgeInsets.all(9),
                        child: facilitiesView(values),)

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
                  "${this.widget.adobj?.pickUpLocationAddress ?? ""}",
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
                  "${this.widget.adobj?.dropLocationAddress ?? ""}",
                  textAlign: TextAlign.justify,
                  style: Style.getMediumFont(
                    12.sp,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if(widget.adobj!.hostingDemos == "1")
                  facilitiesView("Hosting & Demonstration Required"),
                const SizedBox(
                  height: 20,
                ),
                if (widget.isfromOwner ?? false == false)
                  Row(
                    children: [
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
                              image: NetworkImage(
                                  "${widget.adobj?.owner?.imageUrl ?? "" }"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                    child: Image.asset("src/placeholder.png"));
                              },
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        "${this.widget.adobj?.owner?.name ?? ""}",
                        style: Style.getBoldFont(
                          16.sp,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.isfromOwner ?? false == false)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Column(
    children: [CustomButton(
        btnText: "Rent Request",
        color: Style.redColor,
        fontstyle: TextStyle(fontFamily: Const.aventa,
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w400),
        radius: 50,
        width: MediaQuery.of(context).size.width,
        onPressed: () {
          setState(() {
            if (userObj?.isCardInfo == 1){
              scrollController.jumpTo(0.0);
              moveToRequestScreen();
            }else {

              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) =>
                      PaymentPopUp()
                //thankYouDialog(navigationViewModel,context)
              );
            }

          });
        }),
      SizedBox(height: 12.w,),
      //Working on Alpha requirement.
      if(widget.adobj?.isSell == 1)
      CustomButton(
          btnText: "Purchase Request",
          color: Style.redColor,
          fontstyle: TextStyle(fontFamily: Const.aventa,
              fontSize: 18.sp,
              color: Colors.white,
              fontWeight: FontWeight.w400),
          radius: 50,
          width: MediaQuery.of(context).size.width,
          onPressed: () {
            setState(() {

              if (userObj?.isCardInfo == 1){
                scrollController.jumpTo(0.0);
                moveToPurchaseScreen();
              }else {

                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) =>
                        PaymentPopUp()
                  //thankYouDialog(navigationViewModel,context)
                );
              }

            });
          }),],
    )

                  ),
              ],
            )
                : SizedBox(),
          ),
        ),
      ),
    );
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


  void moveToPurchaseScreen(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PurchaseRequestView(adsObj: widget.adobj! , )));
  }

  void moveToRequestScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RentalSendRequestView(adsObj: widget.adobj! , )));
  }

  Widget sendRequestWidget(context) {
    final nameTextEditing = TextEditingController();
    final phoneTextEditing = TextEditingController();
    final additionalDetailTextEditing = TextEditingController();
    final durationTextEditing = TextEditingController();

    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: GestureDetector(
          onTap: () {
            print("working tap");

            if (!additionalDetailsFocus.hasPrimaryFocus) {
              additionalDetailsFocus.unfocus();

              print("unfocus ");
            }
          },
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                SizedBox(height: 36.h),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "Name of Person",
                textAlign: TextAlign.start,
                style: Style.getSemiBoldFont(14.sp,
                    color: Style.textBlackColorOpacity80),
              ),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              // height: 45,
              child: EditText(
                context: context,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
                filledColor: const Color(0xFFF7F7F7),
                borderColor: Color(0xFFF7F7F7),
                isFilled: true,
                hintText: "Nick Johannson",
                validator: validateName,
                currentFocus: nameOfPersonFocus,
                nextFocus: phoneNumberFocus,


                onSaved: (text) {
                  nameOfPerson = text;
                },
                onChange: (text) {
                  nameOfPerson = text;
                },


              ),),
            SizedBox(height: 16.h),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Text(
                  "Phone Number",
                  textAlign: TextAlign.start,
                  style: Style.getSemiBoldFont(14.sp,
                      color: Style.textBlackColorOpacity80),
                ),
              ),
            ),
            SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _openCountryPickerDialog();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: ColoredBox(
                            color: Color.fromRGBO(247, 247, 247, 1.0),
                            child: SizedBox(
                              height: 50.h,
                              width: 70.w,
                              child: Center(
                                child: Text(
                                  "+${_selectedDialogCountry.phoneCode}",
                                  style: TextStyle(
                                      color: const Color(0xff1f1f1f),
                                      fontWeight: FontWeight.w300,
                                      fontFamily: Const.aventa,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 14.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),

                        ),
                      ),
                      SizedBox(width: 12.w,),
                      EditText(
                        width: 240.w,
                        context: context,
                        textInputType: Platform.isAndroid ? TextInputType.phone : TextInputType.numberWithOptions(signed: true, decimal: true),
                        textInputAction: TextInputAction.next,
                        filledColor: const Color(0xFFF7F7F7),
                        borderColor: Color(0xFFF7F7F7),
                        isFilled: true,
                        hintText: "Phone Number",
                        // validator: validateMobile,
                        currentFocus: phoneNumberFocus,
                        // nextFocus: additionalDetailsFocus,
                        // controller: phoneTextEditing,
                        //
                        onSaved: (text) {
                          phoneNumber = "+${_selectedDialogCountry.phoneCode}-${text}";

                        },
                        onChange: (text) {
                          phoneNumber = text;
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "Additional Details",
                textAlign: TextAlign.start,
                style: Style.getSemiBoldFont(14.sp,
                    color: Style.textBlackColorOpacity80),
              ),
            ),
            SizedBox(height: 6.h),
            EditText(
              context: context,
              textInputType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              filledColor: const Color(0xFFF7F7F7),
              borderColor: Color(0xFFF7F7F7),
              isFilled: true,
              maxLines: 4,
              hintText: "write down details here....",
              validator: validateName,
              currentFocus: additionalDetailsFocus,
              // nextFocus: nameOfPersonFocus,



              onSaved: (text) {
                additionalDetails = text;
                FocusScope.of(context).requestFocus(additionalDetailsFocus);
                setState(() {
                  additionalDetails = text;
                });

              },
              onChange: (text) {
                setState((){
                  additionalDetails = text;

                });

              },


            ),
      SizedBox(height: 16.h),
      SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: widget?.adobj?.rentType == "hr" ? Text(
                "Duration in Time",
                textAlign: TextAlign.start,
                style: Style.getSemiBoldFont(14.sp,
                    color: Style.textBlackColorOpacity80),
              ) : Text(
                "Duration in Days",
                textAlign: TextAlign.start,
                style: Style.getSemiBoldFont(14.sp,
                    color: Style.textBlackColorOpacity80),
              ),
            ),
      ),
      SizedBox(height: 6.h),
                  widget?.adobj?.rentType == "day" ?
                      //Per Hour
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     InkWell(
                       onTap: () async {

                         if (dobIssue == true) {
                           toDate = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime(1900),
                             lastDate: DateTime(2030),
                           );
                           // print("selectedDate:"+selectedDate);

                           tofinalDate =
                               DateFormat("yyyy-MM-dd").format(toDate);
                           // print(DateFormat("yyyy-MM-dd").format(selectedDate));
                           print(tofinalDate);
                           setState(() {});
                         }
                       },
                       child: Spinner(
                         width: true,
                         //  dropdownValue: widget.choreData?.jobDate.toString(),
                         hint: tofinalDate == null
                             ? ('Start Date')
                             : tofinalDate,
                         value: tofinalDate,
                         array: const <String>[],
                         filledColor: ColorsConstant.spruce6,
                         placeholderTextColor: (tofinalDate == null ||
                             toDate == null)
                             ? Color.fromARGB(255, 69, 79, 99)
                             : Colors.black,
                         arrowIcon: Icons.calendar_month,
                         onChange: (newValue) {
                           // gender = newValue;
                         },
                       ),
                     ),
                     SizedBox(width: 10.w,),
                     InkWell(
                       onTap: () async {

                         if (dobIssue == true) {
                           fromDate = await showDatePicker(
                             context: context,
                             initialDate: DateTime.now(),
                             firstDate: DateTime(1900),
                             lastDate: DateTime(2030),
                           );
                           // print("selectedDate:"+selectedDate);

                           fromfinalDate =
                               DateFormat("yyyy-MM-dd").format(fromDate);
                           // print(DateFormat("yyyy-MM-dd").format(selectedDate));
                           print(fromDate);
                           setState(() {});
                         }
                       },
                       child: Spinner(
                         width: true,
                         //  dropdownValue: widget.choreData?.jobDate.toString(),
                         hint: fromDate == null
                             ? ('End Date')
                             : fromfinalDate,
                         value: fromfinalDate,
                         array: const <String>[],
                         filledColor: ColorsConstant.spruce6,
                         placeholderTextColor: (fromfinalDate == null ||
                             fromDate == null)
                             ? Color.fromARGB(255, 69, 79, 99)
                             : Colors.black,
                         arrowIcon: Icons.calendar_month,
                         onChange: (newValue) {
                           // gender = newValue;
                         },
                       ),
                     )
                   ],
                 )
                  //Per Day
              :  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Per Hour
                  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                             _selectTime(context, "to");
                            },
                            child: Spinner(
                              width: true,
                              //  dropdownValue: widget.choreData?.jobDate.toString(),
                              hint: totime == null
                                  ? ('Start Time')
                                  : totime,
                              value: totime,
                              array: const <String>[],
                              filledColor: ColorsConstant.spruce6,
                              placeholderTextColor: (toTextController == null ||
                                  totime == null)
                                  ? Color.fromARGB(255, 69, 79, 99)
                                  : Colors.black,
                              arrowIcon: Icons.access_time_filled,
                              onChange: (newValue) {
                                // gender = newValue;
                              },
                            ),
                          ),
                          SizedBox(width: 10.w,),
                          InkWell(
                            onTap: () async {

                              _selectTime(context, "from");
                            },
                            child: Spinner(
                              width: true,
                              //  dropdownValue: widget.choreData?.jobDate.toString(),
                              hint: fromtime == null
                                  ? ('End Time')
                                  : fromtime,
                              value: fromtime,
                              array: const <String>[],
                              filledColor: ColorsConstant.spruce6,
                              placeholderTextColor: (fromTextController == null ||
                                  fromtime == null)
                                  ? Color.fromARGB(255, 69, 79, 99)
                                  : Colors.black,
                              arrowIcon: Icons.access_time_filled,
                              onChange: (newValue) {
                                // gender = newValue;
                              },
                            ),
                          )
                        ],
                      ),
                  SizedBox(height: 15.h,),
                  Text(
                    " Select Date",
                    textAlign: TextAlign.start,
                    style: Style.getSemiBoldFont(14.sp,
                        color: Style.textBlackColorOpacity80),
                  ),
                  SizedBox(height: 3.5.h,),
                  InkWell(
                    onTap: () async {

                      if (dobIssue == true) {
                        fromDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2030),
                        );
                        // print("selectedDate:"+selectedDate);

                        fromfinalDate =
                            DateFormat("yyyy-MM-dd").format(fromDate);
                        // print(DateFormat("yyyy-MM-dd").format(selectedDate));
                        print(fromDate);
                        setState(() {});
                      }
                    },
                    child: Spinner(
                      width: true,
                      //  dropdownValue: widget.choreData?.jobDate.toString(),
                      hint: fromDate == null
                          ? ('Select Date')
                          : fromfinalDate,
                      value: fromfinalDate,
                      array: const <String>[],
                      filledColor: ColorsConstant.spruce6,
                      placeholderTextColor: (fromfinalDate == null ||
                          fromDate == null)
                          ? Color.fromARGB(255, 69, 79, 99)
                          : Colors.black,
                      arrowIcon: Icons.calendar_month,
                      onChange: (newValue) {
                        // gender = newValue;
                      },
                    ),
                  )
                ],
              ),
      SizedBox(height: 16.h),
      SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "Upload Security License",
                textAlign: TextAlign.start,
                style: Style.getSemiBoldFont(14.sp,
                    color: Style.textBlackColorOpacity80),
              ),
            ),
      ),
      SizedBox(height: 6.h),
      SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
            child: Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: Text(
                "Attach your driving license (Front - Back)",
                textAlign: TextAlign.start,
                style: Style.getRegularFont(
                  12.sp,
                ),
              ),
            ),
      ),
      SizedBox(height: 16.h),
                  Center(
                    child: Container(
                      height: 70.h,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0),)),

                      // width: MediaQuery.of(context).size.width - 200,
                      child:ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: images?.length ?? 0,
                        itemBuilder: (context, index) =>

                            showImages(index),

                        separatorBuilder: (context, index) => SizedBox(
                          width: 8.w,
                        ),
                      ),
                    ),
                  ),
      SizedBox(height: 16.h),
      Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState((){
                    hostingDemonstration = !hostingDemonstration!;
                  });
                },
                child: SizedBox(
                    height: 24.h,
                    width: 24.h,
                    child: Image.asset(
                        // outline-check-icon-blue
                           hostingDemonstration! ? Style.getIconImage("checkbox_checked_icon@2x.png") :  Style.getIconImage("checkbox_unchecked_icon@2x.png"))   ),
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
            height: 20,
      ),
      Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
                btnText: "Send Request",
                color: Style.redColor,
                fontstyle: TextStyle(fontFamily: Const.aventa,
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
                radius: 50,
                width: 350,
                onPressed: () {

    if (_validateInputs()) {
      Map<String , dynamic> jsonParam = {};

            if(widget.adobj!.rentType == "hr") {
            jsonParam = {
              "product_id": widget.adobj?.id,
              "rentar_name": nameOfPerson,
              "phone_no" : phoneNumber,
              "details" : additionalDetails,
              // "duration" : durationCalc(duration!),
              "total_charges" : widget.adobj?.rentCharges,
              "demo_hosting" : demo_host(hostingDemonstration!) ,
              "device_type":  Platform.isAndroid ? "android":'ios',
              "from_time" : widget.adobj!.rentType == "hr" ? totime : toDate ,
              "to_time" :  widget.adobj!.rentType == "hr" ? fromtime : fromDate ,
              "booking_date" : widget.adobj!.rentType == "hr" ?  fromDate  : "",

              // "device_token": Prefs.getFCMToken,
            };
            }else {
            jsonParam = {
              "product_id": widget.adobj?.id,
              "rentar_name": nameOfPerson,
              "phone_no" : phoneNumber,
              "details" : additionalDetails,
              // "duration" : durationCalc(duration!),
              "total_charges" : widget.adobj?.rentCharges,
              "demo_hosting" : demo_host(hostingDemonstration!) ,
              "device_type":  Platform.isAndroid ? "android":'ios',
              "from_time" : widget.adobj!.rentType == "hr" ? totime : toDate ,
              "to_time" :  widget.adobj!.rentType == "hr" ? fromtime : fromDate ,


              // "device_token": Prefs.getFCMToken,
            };
            }


      var icount = 0;
      imageFiles = [];
      for (var values in images!){

            imageFiles!.add({"name":"driving_license[$icount]","path":values!.path});
            icount = icount + 1;
            print(imageFiles!);
      }
      showLoading();
      createBookingAds(jsonData: jsonParam, files: imageFiles!, onSuccess: (data) {
            _displayThankYouDialog(context);
       hideLoading();
      }, onError: (error) {

            hideLoading();
            toast(error);
      });


      print("${nameOfPerson}  ${phoneNumber}  ${additionalDetails}  ${duration}   ${hostingDemonstration}"  );

    }



                  // _displayThankYouDialog(context);
                }),
      ),
      ],

    ),
          ),
        ),)
    ,
    );
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


  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select your phone code'),
            onValuePicked: (Country country) =>

                setState(() => _selectedDialogCountry = country),
            // itemFilter: (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
            itemBuilder: _buildDialogItem)),
  );

  Widget _buildDialogItem(Country country) => Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(width: 8.0),
      Text("+${country.phoneCode}"),
      SizedBox(width: 8.0),
      Flexible(child: Text(country.name))
    ],
  );
  
  
  
  int durationCalc(String value) {
    if (value == "2 Hour Duration") {
      return  2;
    }else if (value == "5 Hour Duration") {
      return 5;
    }else if (value == "12 Hour Duration") {
      return 12;
    }else {
      return 0;
    }
  }

  String demo_host(bool value) {
    if (value) {
      return "yes";
    }else {
      return "no";
    }
  }

  _displayThankYouDialog(context) {
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
              backgroundColor: Style.thankYouBaclgroundColor,
              body: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: Image.asset(
                              Style.getIconImage("ic_thankyou@2x.png"))),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Thank You!",
                        style: Style.getBoldFont(22.sp,
                            color: Style.textWhiteColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                      "Your rent request has been sent successfully.",textAlign: TextAlign.center,
                        style: Style.getSemiBoldFont(16.sp,
                            color: Style.textWhiteColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() {
                              if (request) {
                                Navigator.pushReplacementNamed(
                                    context, Dashboard.route);
                              }
                              Navigator.pushNamedAndRemoveUntil(
                                  context, Dashboard.route, (route) => false);
                            }),
                        child: Text(
                          "Continue",
                          style: Style.getSemiBoldFont(14.sp,
                              color: Style.blueColor),
                        ),
                      ),
                    ]),
              ),
            ));
      },
    );
  }



  String? returnRentType(String? value) {
    if (value == "day") {
      return "Rent as per Day";
    } else {
      return "Rent as per Hour";
    }
  }

  Widget showImages(int index) {
    if (index == 0) {

        return Stack(
          children: [
            Container(
              child: GestureDetector(
                onTap: () {
                  if(images![0] == null)
                  showImageSelectOption(
                      context, false, (image, isVideo, imagethump) async {


                    if (mounted) {
                      setState(() {
                        images![0] = image;
                      });
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            offset: Offset(0, 10),
                            blurRadius: 10
                        )
                      ]
                  ),

                  height: 67.spMax,
                  width: 120.w,
                  child: images![0] != null? Image.file(images![0]! , fit: BoxFit.cover,)  : Image.asset("src/FrontImg@3x.png", scale: 6,),
                ),
              ),

            ),
            if(images![0] == null)
            Positioned(
              right: 22.w,
              bottom: 3.h,
              child: Text("Front Image" , style: TextStyle(fontFamily: Const.aventa , fontSize: 12.sp),),
            ),
            if(images![0] != null)
              Positioned(
                right: 4.25.w,
                top: 8.h,
                child: SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: GestureDetector(
                    onTap: () async {


                      if(mounted){
                        setState((){

                          images![0] = null;

                        });
                      }



                    },
                    child: Image.asset("src/closebtn@3x.png"),
                  ),
                ),
              ),
          ],


        );
    }else if (index == 1) {
      return Stack(
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                if(images![1] == null)
                showImageSelectOption(
                    context, false, (image, isVideo, imagethump) async {
                  if (mounted) {
                    setState(() {
                      images![1] = image;
                    });
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          offset: Offset(0, 10),
                          blurRadius: 10
                      )
                    ]
                ),

                height: 67.spMax,
                width: 120.w,
                child: images![1] != null ? Image.file(images![1]! , fit: BoxFit.cover)   : Image.asset("src/FrontImg@3x.png", scale: 6,),
              ),
            ),

          ),
          if(images![1] == null)
          Positioned(
            right: 22.w,
            bottom: 3.h,
            child: Text("Back Image" , style: TextStyle(fontFamily: Const.aventa , fontSize: 12.sp),),
          ),
          if(images![1] != null)
            Positioned(
              right: 4.25.w,
              top: 8.h,
              child: SizedBox(
                width: 16.w,
                height: 16.w,
                child: GestureDetector(
                  onTap: () async {


                    if(mounted){
                      setState((){

                        images![1] = null;

                      });
                    }



                  },
                  child: Image.asset("src/closebtn@3x.png"),
                ),
              ),
            ),

        ],


      );

    }else {
      return SizedBox();
    }
  }

}
