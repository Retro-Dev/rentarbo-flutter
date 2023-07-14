import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:oktoast/oktoast.dart';
import '../Controllers/verification.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import '../component/custom_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  static const String route = "SignUp";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool autoValidate = false, pobscure = true, cobscure = true, agree = false ,passObsure = true , confirmObsure = true, obsure = false;
 bool isapplied_validate = true;
  String? fName,lName, email, phone, location, pass, confrimpass,deviceType;
  double? lat, lng;
  FocusNode fNameFocus = FocusNode(),
      lNameFocus = FocusNode(),
      phoneFocus = FocusNode(),
      emailFocus = FocusNode(),
      passFocus = FocusNode(),
      comfrmPassFocus = FocusNode();
      // locationFocus = FocusNode();

  GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: '_signUp');

  TextEditingController fNameTextController = TextEditingController(),
      lNameTextController = TextEditingController(),
      phoneTextController = TextEditingController(),
      emailTextController = TextEditingController(),
      passTextController = TextEditingController(),
      confirmPassTextController = TextEditingController();

   Country _selectedDialogCountry = Country(isoCode: "US", iso3Code: "USA", phoneCode: "1", name: "USA");

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: fNameFocus),
        KeyboardActionsItem(focusNode: lNameFocus),
        KeyboardActionsItem(focusNode: phoneFocus),
        KeyboardActionsItem(focusNode: emailFocus),
        KeyboardActionsItem(focusNode: passFocus),
        KeyboardActionsItem(focusNode: comfrmPassFocus),
      ],
    );
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
              "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop("true");
          },
        ),
        centerTitle: true,
        title: SizedBox(
            width: 55,
            height: 62,
            child: Image.asset("src/app-logo@2x.png", fit: BoxFit.contain)),
      ),
      body: RegisterBodyView(context),
    );
  }




  Widget RegisterBodyView(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Text(
                      "Create Account",
                      style: const TextStyle(
                          color: const Color(0xff1f1f1f),
                          fontWeight: FontWeight.w700,
                          fontFamily: Const.aventa,
                          fontStyle: FontStyle.normal,
                          fontSize: 28.0),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Opacity(
                          opacity: 0.6000000238418579,
                          child: Text("Fill in your information below to register",
                              style: const TextStyle(
                                  color: const Color(0xff1f1f1f),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Const.aventa,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0),
                              textAlign: TextAlign.left),
                        )),
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("First Name",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    // TextFormField(
                    // keyboardType: TextInputType.name,
                    // textInputAction: TextInputAction.next,
                    // autocorrect: false,
                    // style: Style.getRegularFont(14.sp,
                    // color: Style.textBlackColor),
                    // decoration: InputDecoration(
                    // filled: true,
                    // contentPadding: const EdgeInsets.all(10),
                    // fillColor: const Color(0xFFF7F7F7),
                    // hintText: "First Name",
                    // focusedBorder: Style.outlineInputBorder,
                    // enabledBorder: Style.outlineInputBorder,
                    // )),

                    EditText(
                      context: context,
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "First Name",
                      controller: fNameTextController,
                      validator: validateName,
                      currentFocus: fNameFocus,
                      nextFocus: lNameFocus,


                      onSaved: (text) {
                      fName = text;
                      },
                      onChange: (text) {
                      fName = text;
                      },
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("Last Name",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    // TextFormField(
                    // keyboardType: TextInputType.name,
                    // textInputAction: TextInputAction.next,
                    // autocorrect: false,
                    // style: Style.getRegularFont(14.sp,
                    // color: Style.textBlackColor),
                    // decoration: InputDecoration(
                    // filled: true,
                    // contentPadding: const EdgeInsets.all(10),
                    // fillColor: const Color(0xFFF7F7F7),
                    // hintText: "Last Name",
                    // focusedBorder: Style.outlineInputBorder,
                    // enabledBorder: Style.outlineInputBorder,
                    // )),
                    EditText(
                      context: context,
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Last Name",
                      validator: validateName,
                      currentFocus: lNameFocus,
                      nextFocus: phoneFocus,
                      controller: lNameTextController,

                      //
                      onSaved: (text) {
                      lName = text;
                      },
                      onChange: (text) {
                      lName = text;
                      },
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("Phone Number",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    // TextFormField(
                    // keyboardType: TextInputType.name,
                    // textInputAction: TextInputAction.next,
                    // autocorrect: false,
                    // style: Style.getRegularFont(14.sp,
                    // color: Style.textBlackColor),
                    // decoration: InputDecoration(
                    // filled: true,
                    // contentPadding: const EdgeInsets.all(10),
                    // fillColor: const Color(0xFFF7F7F7),
                    // hintText: "Phone Number",
                    // focusedBorder: Style.outlineInputBorder,
                    // enabledBorder: Style.outlineInputBorder,
                    // )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                         children : [ InkWell(
                            onTap: () {
                              _openCountryPickerDialog();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              child: ColoredBox(
                                color: Color.fromRGBO(247, 247, 247, 1.0),
                                child: SizedBox(
                                  height: 60.h,
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
                           // if (isapplied_validate)
                            isapplied_validate ? SizedBox(height: 0,)  : Text(
                                "data"  , style: TextStyle(color: Colors.white),) ,

              ]
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
                          validator: validateMobile,
                          currentFocus: phoneFocus,
                          nextFocus: emailFocus,
                          controller: phoneTextController,
                          //
                          onSaved: (text) {
                            phone = "+${_selectedDialogCountry.phoneCode}-${text}";

                          },
                          onChange: (text) {
                            phone = text;
                            setState(() {
                              if (validateMobile(phone?? "") == "Phone number must be 1234567890."){
                                isapplied_validate = false;
                              }else {
                                isapplied_validate = true;
                              }

                            });
                          },
                        ),
                      ],
                    ),


                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("Email Address",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    // TextFormField(
                    // keyboardType: TextInputType.name,
                    // textInputAction: TextInputAction.next,
                    // autocorrect: false,
                    // style: Style.getRegularFont(14.sp,
                    // color: Style.textBlackColor),
                    // decoration: InputDecoration(
                    // filled: true,
                    // contentPadding: const EdgeInsets.all(10),
                    // fillColor: const Color(0xFFF7F7F7),
                    // hintText: "xyz@mail.com",
                    // focusedBorder: Style.outlineInputBorder,
                    // enabledBorder: Style.outlineInputBorder,
                    // )),
                    EditText(

                      context: context,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Email Address",
                      validator: validateEmail,
                      currentFocus: emailFocus,
                      nextFocus: passFocus,
                      controller: emailTextController,
                      //
                      onSaved: (text) {
                      email = text;
                      },
                      onChange: (text) {
                      email = text;
                      },
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("Password",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    EditText(
                      context: context,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Password",
                      validator: validatePassword,
                      currentFocus: passFocus,
                      nextFocus: comfrmPassFocus,
                      isPassword: true,
                      obscure: passObsure,

                      icon: passObsure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      suffixClick: () {
                        setState(() {
                          passObsure = !passObsure;
                        });
                      },
                      onChange: (text) {
                        pass = text;
                      },

                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text("Confirm Password",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0),
                                textAlign: TextAlign.left),
                          )),
                    ),
                    SizedBox(height: 6),
                    //
                    EditText(

                      context: context,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Confirm Password",
                      obscure: confirmObsure,
                      currentFocus: comfrmPassFocus,
                      validator: validatePassword,
                      isPassword: true,

                      icon: confirmObsure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      suffixClick: () {
                        setState(() {
                          confirmObsure = !confirmObsure;
                        });
                      },
                      onChange: (text) {
                        confrimpass = text;
                      },

                    ),
                    SizedBox(height: 24),
                    Row(children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                        },
                        child: SizedBox(
                            width: 23,
                            height: 23,
                            child: GestureDetector(
                              onTap: () {
                                obsure = !obsure;
                                setState((){});
                              },
                              child: Image.asset(obsure
                                  ? "assets/images/icons/checkbox_checked_icon@2x.png"
                                  : "assets/images/icons/checkbox_unchecked_icon@2x.png"),
                            )),
                      ),
                      SizedBox(width: 8),
                      Text("I agree to the",
                          style: const TextStyle(
                              color: const Color(0xff1f1f1f),
                              fontWeight: FontWeight.w400,
                              fontFamily: Const.aventa,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.left),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          // Navigator.of(context).pushNamed(Constants.tnc);
                        },
                        child: Text(
                          " Terms & Conditions",
                          style: TextStyle(
                              color: const Color(0xff1d80d5),
                              fontWeight: FontWeight.w600,
                              fontFamily: Const.aventa,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                      )
                    ]),
                    SizedBox(height: 55),
                    CustomButton(btnText: "Register" , radius: 25.w,height: 50.w, width: MediaQuery.of(context).size.width, fontSize : 12.sp ,fontstyle: TextStyle(
                      color:  Colors.white,
                      fontWeight: FontWeight.w300,
                      fontFamily: Const.aventa,
                      fontStyle:  FontStyle.normal,
                      fontSize: 18.sp,
                    ),onPressed: () {
                      if (_validateInputs()) {
                        //check further
                        if (obsure == false ||
                            fName == null ||
                            lName == null ||
                            phone == null ||
                            email == null ||
                            pass == null ||
                            confrimpass == null
                        // lat == null||
                        // lng == null
                        )
                          if (obsure == true) {
                            toast('All fields are required');
                          }else {
                            toast('please accept term & conditions');
                          }

                        else {
                          // Validated
                          if(Platform.isAndroid){
                            deviceType = "android";
                          }else if (Platform.isIOS){
                            deviceType = "ios";
                          }
                          Map<String, dynamic>  jsonParam = {};
                          String? deviceToken;
                          Prefs.getFCMToken.then((value) {
                            deviceToken = value;
                            var jsonParam = { "first_name": fName,
                              "last_name" : lName,
                              "email":email,
                              "mobile_no": "${phone}",
                              "address":location,
                              "latitude":"$lat",
                              "longitude":"$lng",
                              "password": pass,
                              "confirm_password":confrimpass,
                              "device_type":deviceType,
                              "device_token":deviceToken,
                            };
                            showLoading();
                            signUp(jsonData: jsonParam, onSuccess: (user,message) {
                              hideLoading();
                              if (user.isEmailVerify == "0")
                              {
                                showToast(message);
                                Navigator.pop(context);
                                hideLoading();
                              }
                              Navigator.pushNamed(context, OTPVerification.route);
                            }, onError: (error) {
                              hideLoading();
                              toast(error);
                            });
                          });

                        }
                      } else {
                      }
                    }),
                    SizedBox(height: 46),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: const TextStyle(
                              color: const Color(0xff1f1f1f),
                              fontWeight: FontWeight.w600,
                              fontFamily: Const.aventa,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            " Sign in",
                            style: TextStyle(
                              color: Color(0xffff0037),
                              fontFamily: Const.aventa,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  bool _validateInputs() {
    FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    // WidgetsBinding.instance.addPostFrameCallback((_) => _textEditingController.clear());
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();

      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        autoValidate = true;
      });

      setState(() {
        isapplied_validate = false;
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
}


