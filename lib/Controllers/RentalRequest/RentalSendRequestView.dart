import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:rentarbo_flutter/Models/Ads.dart';

import '../../Extensions/colors_utils.dart';
import '../../Extensions/style.dart';
import '../../Models/ReturnStatus.dart';
import '../../Models/User.dart';
import '../../Utils/BookingAds.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../component/Spinner.dart';
import '../../component/custom_button.dart';
import '../Dashboard.dart';
import '../ImagePreviewer.dart';


class RentalSendRequestView extends StatefulWidget {
  static const String route = "RentalSendRequestView";
  ReturnDatum? product;
  AdsObj adsObj;
  RentalSendRequestView({required this.adsObj});
  @override
  _RentalSendRequestViewState createState() => _RentalSendRequestViewState();
}

class _RentalSendRequestViewState extends State<RentalSendRequestView> {


  int _current = 0;
  final CarouselController _controller = CarouselController();

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
        print(userObj?.imageUrl);
        setState((){
          nameofPersion.text = userObj?.name ?? "";
          mobileNumber.text = userObj?.mobileNo ?? "";
        });
      });
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();



    load();


    print(widget.adsObj?.hostingDemos);
    images = [null , null];
    print("------------Screen Size------------");
    print(((widget.adsObj!.tags!.length! / 100) * 50 ));
    print("------------Screen Size------------");
    hostingDemonstration = false;
    fromTextController = TextEditingController();
    toTextController = TextEditingController();
  }

  FocusNode nameOfPersonFocus = FocusNode(),
      phoneNumberFocus = FocusNode(),
      additionalDetailsFocus = FocusNode(),
      starTimeFocus = FocusNode(),
      endTimeFocus = FocusNode(),
      selectDateFocus = FocusNode();
  List<File?>? images = [];


  bool autoValidate = false,
      obsure = true;

  String? nameOfPerson;
  String? phoneNumber;
  String? additionalDetails;
  String? duration;
  bool? hostingDemonstration;
  TextEditingController nameofPersion = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
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
      height: 300.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 600,
      maxWidthDiskCache: 600,
      // imageBuilder: (context, imageProvider) => CircleAvatar(
      // backgroundImage: imageProvider,
      // radius: 50.r,
      // ),
      // fit: BoxFit.cover,
    );
  }


  Widget carouselWidget(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 300.w,
          enlargeCenterPage: true,
          viewportFraction: 1,
          onPageChanged: (position, reason) {
            debugPrint(reason.toString());
            print(CarouselPageChangedReason.controller);
            _current = position;
            if (this.mounted) {
              setState(() {});
            }
          },
          enableInfiniteScroll: false,
        ),

        items: widget.adsObj!.media!.map<Widget>((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(children: [
                Container(

                  width: MediaQuery.of(context).size.width - 0,
                  margin : EdgeInsets.only(left : 0 , right: 0),
                  child :  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [ Colors.transparent,
                            Colors.black.withAlpha(200)],
                        ).createShader(Rect.fromLTRB(0, 0, 0, 330));
                      },
                      blendMode: BlendMode.srcOver,
                      child:  circularImageView(image: i?.fileUrl ?? "" , size: 300.h)
                    ),),),
                Positioned(
                  top: 10.h,
                  left: 25.w,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 180.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                      ],
                    ),
                  ),
                )
              ]);
            },
          );
        }).toList(),
      ),
      // Positioned(
      //   bottom: 10.w,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: widget.product.product!.media!.asMap().entries.map((entry) {
      //       return GestureDetector(
      //         onTap: () => _controller.animateToPage(entry.key),
      //         child: Container(
      //           width: 8.0.w,
      //           height: 8.0.w,
      //           margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      //           decoration: BoxDecoration(
      //               shape: BoxShape.circle,
      //               color: (Theme.of(context).brightness == Brightness.light
      //                   ? Colors.white
      //                   : Colors.black)
      //                   .withOpacity(_current == entry.key ? 0.9 : 0.4)),
      //         ),
      //       );
      //     }).toList(),
      //   ),
      // ),
    ]);
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: null,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              // fit: StackFit.expand,
                children: [
                  carouselWidget(context),
                  Positioned(top: 250.h, child:SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      clipBehavior: Clip.hardEdge,
                      child: ColoredBox(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 12.w , right: 12.w),
                          child: KeyboardActions(
                            autoScroll: false,
                            config: _buildConfig(context),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
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
                                  EditText(
                                    context: context,
                                    textInputType: TextInputType.text,
                                    controller: nameofPersion,
                                    textInputAction: TextInputAction.next,
                                    filledColor: const Color(0xFFF7F7F7),
                                    borderColor: Color(0xFFF7F7F7),
                                    isFilled: true,
                                    setEnable: false,
                                    hintText: "Nick Johannson",
                                    validator: validateName,
                                    currentFocus: nameOfPersonFocus,
                                    nextFocus: phoneNumberFocus,


                                    onSaved: (text) {
                                      // nameOfPerson = text;
                                    },
                                    onChange: (text) {
                                      // nameOfPerson = text;
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
                                      child: Text(
                                        "Phone Number",
                                        textAlign: TextAlign.start,
                                        style: Style.getSemiBoldFont(14.sp,
                                            color: Style.textBlackColorOpacity80),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  SizedBox(height: 6.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      EditText(
                                        width: 240.w,
                                        context: context,
                                        controller: mobileNumber,
                                        textInputType: Platform.isAndroid ? TextInputType.phone : TextInputType.numberWithOptions(signed: true, decimal: true),
                                        textInputAction: TextInputAction.next,
                                        filledColor: const Color(0xFFF7F7F7),
                                        borderColor: Color(0xFFF7F7F7),
                                        isFilled: true,
                                        setEnable: false,
                                        hintText: "Phone Number",
                                        // validator: validateMobile,
                                        currentFocus: phoneNumberFocus,
                                        // nextFocus: additionalDetailsFocus,
                                        // controller: phoneTextEditing,
                                        //
                                        onSaved: (text) {
                                          // phoneNumber = "+${_selectedDialogCountry.phoneCode}-${text}";

                                        },
                                        onChange: (text) {
                                          // phoneNumber = text;
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
                                      child: widget?.adsObj?.rentType == "hr" ? Text(
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
                                  widget?.adsObj?.rentType == "day" ?
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
                                              firstDate: DateTime.now(),
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
                                              firstDate: DateTime.now(),
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
                                              firstDate: DateTime.now(),
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
                                      height: 90.h,
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


                                            if(widget.adsObj!.rentType == "hr") {
                                              if (totime == null) {
                                                toast("Start Time required.");
                                              }
                                              else if (fromtime == null) {
                                                toast("End Time required.");
                                              }else if (fromDate == null ) {
                                                toast("Date required.");
                                              }else  {

                                              }
                                            }else {
                                              if (toDate == null) {
                                                toast("Start Date required.");
                                              }else if (fromDate == null) {
                                                toast("End Date required.");
                                              }else {

                                              }
                                            }

                                            if(images?[0] == null) {
                                              toast("Front Image required.");
                                            }

                                            if (images?[1] == null) {
                                              toast("Back Image required.");
                                            }

                                            if(widget.adsObj!.rentType == "hr") {
                                              jsonParam = {
                                                "product_id": widget.adsObj?.id,
                                                "rentar_name": nameofPersion.text,
                                                "phone_no" : mobileNumber.text,
                                                "details" : additionalDetails,
                                                // "duration" : durationCalc(duration!),
                                                "total_charges" : widget.adsObj?.rentCharges,
                                                "demo_hosting" : demo_host(hostingDemonstration!) ,
                                                "device_type":  Platform.isAndroid ? "android":'ios',
                                                "from_time" : widget.adsObj!.rentType == "hr" ? totime : toDate ,
                                                "to_time" :  widget.adsObj!.rentType == "hr" ? fromtime : fromDate ,
                                                "booking_date" : widget.adsObj!.rentType == "hr" ?  fromDate  : "",

                                                // "device_token": Prefs.getFCMToken,
                                              };
                                            }else {
                                              jsonParam = {
                                                "product_id": widget.adsObj?.id,
                                                "rentar_name": nameofPersion.text,
                                                "phone_no" : mobileNumber.text,
                                                "details" : additionalDetails,
                                                // "duration" : durationCalc(duration!),
                                                "total_charges" : widget.adsObj?.rentCharges,
                                                "demo_hosting" : demo_host(hostingDemonstration!) ,
                                                "device_type":  Platform.isAndroid ? "android":'ios',
                                                "from_time" : widget.adsObj!.rentType == "hr" ? totime : toDate ,
                                                "to_time" :  widget.adsObj!.rentType == "hr" ? fromtime : fromDate ,


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
                                  SizedBox(height: 300.h,),
                                 ]
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  Positioned( top : 63.h , child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: InkWell(
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
                  ), )
                ]),
          ),
        ));
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

  String demo_host(bool value) {
    if (value) {
      return "yes";
    }else {
      return "no";
    }
  }


  Widget sendRequestWidget(context) {
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

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
              EditText(
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
                  child: widget?.adsObj?.rentType == "hr" ? Text(
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
              widget?.adsObj?.rentType == "day" ?
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
                          firstDate: DateTime.now(),
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
                          firstDate: DateTime.now(),
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
                          firstDate: DateTime.now(),
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

                        if(widget.adsObj!.rentType == "hr") {
                          jsonParam = {
                            "product_id": widget.adsObj?.id,
                            "rentar_name": nameOfPerson,
                            "phone_no" : phoneNumber,
                            "details" : additionalDetails,
                            // "duration" : durationCalc(duration!),
                            "total_charges" : widget.adsObj?.rentCharges,
                            "demo_hosting" : demo_host(hostingDemonstration!) ,
                            "device_type":  Platform.isAndroid ? "android":'ios',
                            "from_time" : widget.adsObj!.rentType == "hr" ? totime : toDate ,
                            "to_time" :  widget.adsObj!.rentType == "hr" ? fromtime : fromDate ,
                            "booking_date" : widget.adsObj!.rentType == "hr" ?  fromDate  : "",

                            // "device_token": Prefs.getFCMToken,
                          };
                        }else {
                          jsonParam = {
                            "product_id": widget.adsObj?.id,
                            "rentar_name": nameOfPerson,
                            "phone_no" : phoneNumber,
                            "details" : additionalDetails,
                            // "duration" : durationCalc(duration!),
                            "total_charges" : widget.adsObj?.rentCharges,
                            "demo_hosting" : demo_host(hostingDemonstration!) ,
                            "device_type":  Platform.isAndroid ? "android":'ios',
                            "from_time" : widget.adsObj!.rentType == "hr" ? totime : toDate ,
                            "to_time" :  widget.adsObj!.rentType == "hr" ? fromtime : fromDate ,


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
        ),)
      ,
    );
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0.2,
                          offset: Offset(1, -1),
                          blurRadius: 10
                      )
                    ]
                ),

                height: 100.h,
                width: 120.w,
                child: images![0] != null? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.file(images![0]! , fit: BoxFit.cover,))  : Image.asset("src/FrontImg@3x.png", scale: 6,),
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
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 0.2,
                          offset: Offset(1, -1),
                          blurRadius: 10
                      )
                    ]
                ),

                height: 100.h,
                width: 120.w,
                child: images![1] != null ? ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.file(images![1]! , fit: BoxFit.cover))   : Image.asset("src/FrontImg@3x.png", scale: 6,),
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
