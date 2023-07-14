import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import '../Controllers/selectCategory.dart';
import '../Models/User.dart';
import '../Utils/Const.dart';
import '../Utils/Prefs.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';



class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key}) : super(key: key);

  static const String route = "OTPVerification";

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  bool autoValidate = false, OtpVerification = false;

  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController pin5Controller = TextEditingController();

  FocusNode pin1Focus = FocusNode();
  FocusNode pin2Focus = FocusNode();
  FocusNode pin3Focus = FocusNode();
  FocusNode pin4Focus = FocusNode();
  FocusNode pin5Focus = FocusNode();

  bool pin1Filled = false;
  bool pin2Filled = false;
  bool pin3Filled = false;
  bool pin4Filled = false;
  bool pin5Filled = false;

  void checkOTP()
  {
    pin1Filled = pin1Controller.text.isNotEmpty;
    pin2Filled = pin2Controller.text.isNotEmpty;
    pin3Filled = pin3Controller.text.isNotEmpty;
    pin4Filled = pin4Controller.text.isNotEmpty;
    pin5Filled = pin5Controller.text.isNotEmpty;

  }

  bool getAllPinsFilled() {
    return true;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load();
  }

  User? userObj;
  load() async {
    Prefs.getUser((User? user){
      if(mounted) {
        setState(() {
          this.userObj = user;
          print(userObj?.imageUrl);
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        leading: IconButton(
          icon: SizedBox(
              width: 24,
              height: 24,
              child: Image.asset(
                "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: VerificationBodyView(context),
    );
  }

  Widget VerificationBodyView(BuildContext context)
  {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                      width: 185,
                      height: 215,
                      child: Image.asset(
                          getAllPinsFilled()
                                  ? "assets/images/logos/verification_enabled_logo.png"
                                  : "assets/images/logos/verification_disabled_logo.png",
                          fit: BoxFit.fill)),
                ),
                SizedBox(height: 30),
                Text("Verification Code",
                    style:
                    TextStyle(
                      color: Color(0xff1f1f1f),
                      fontSize: 28,
                      fontFamily: Const.aventaBold,
                      fontWeight: FontWeight.w700,
                    ),),
                SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: RichText(
                      text: TextSpan(
                          text:
                          "We have sent you a verification code to the Mobile number",
                          style: TextStyle(
                              color:  const Color(0xff1f1f1f),
                              fontWeight: FontWeight.w400,
                              fontFamily: Const.avantaMedium,
                              fontStyle:  FontStyle.normal,
                              fontSize: 16.0),
                          children: [
                            TextSpan(
                                text: " \"${userObj?.mobileNo ?? ""}\"",
                                style: TextStyle(
                                    color:  const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.avantaMedium,
                                    fontStyle:  FontStyle.normal,
                                    fontSize: 16.0),)
                          ])),
                ),
                SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 55,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: pin1Filled
                                ? const Color(0x1AFF0037)
                                : const Color(0xFFF7F7F7),
                            border: Border.all(
                                color: pin1Filled
                                    ? Color(0xFFFF0037)
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pin1Controller,
                              maxLength: 1,
                              focusNode: pin1Focus,
                              onChanged: (val) {

                                if (val.isEmpty) {
                                  pin1Focus.requestFocus();
                                }else {
                                  pin2Focus.requestFocus();
                                }
                                  setState(() {
                                    checkOTP();
                                  });
                              },
                              autocorrect: false,
                              style: TextStyle(fontSize: 22,
                                  color: pin1Filled
                                      ? Color(0xFFFF0037)
                                      : Colors.black),
                              decoration: const InputDecoration(
                                  counterText: "", border: InputBorder.none)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 55,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: pin2Filled
                                ? const Color(0x1AFF0037)
                                : const Color(0xFFF7F7F7),
                            border: Border.all(
                                color: pin2Filled
                                    ? Color(0xFFFF0037)
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pin2Controller,
                              maxLength: 1,
                              focusNode: pin2Focus,
                              onChanged: (val) {

                                if (val.isEmpty) {
                                  pin1Focus.requestFocus();
                                }else {
                                  pin3Focus.requestFocus();
                                }
                                  setState(() {
                                    checkOTP();
                                  });

                              },
                              autocorrect: false,
                              style: TextStyle(fontSize: 22,
                                  color: pin2Filled
                                      ? Color(0xFFFF0037)
                                      : Colors.black),
                              decoration: const InputDecoration(
                                  counterText: "", border: InputBorder.none)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 55,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: pin3Filled
                                ? const Color(0x1AFF0037)
                                : const Color(0xFFF7F7F7),
                            border: Border.all(
                                color: pin3Filled
                                    ? Color(0xFFFF0037)
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pin3Controller,
                              maxLength: 1,
                              focusNode: pin3Focus,
                              onChanged: (val) {

                                if (val.isEmpty) {
                                  pin2Focus.requestFocus();
                                }else {
                                  pin4Focus.requestFocus();
                                }
                                  setState(() {
                                    checkOTP();
                                  });
                              },
                              autocorrect: false,
                              style: TextStyle(fontSize: 22,
                                  color: pin3Filled
                                      ? Color(0xFFFF0037)
                                      : Colors.black),
                              decoration: const InputDecoration(
                                  counterText: "", border: InputBorder.none)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 55,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: pin4Filled
                                ? const Color(0x1AFF0037)
                                : const Color(0xFFF7F7F7),
                            border: Border.all(
                                color: pin4Filled
                                    ? Color(0xFFFF0037)
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pin4Controller,
                              maxLength: 1,
                              focusNode: pin4Focus,
                              onChanged: (val) {

                                if (val.isEmpty) {
                                  pin3Focus.requestFocus();
                                }else {
                                  pin5Focus.requestFocus();
                                }
                                  setState(() {
                                    checkOTP();
                                  });
                              },
                              autocorrect: false,
                              style: TextStyle(fontSize: 22,
                                  color: pin4Filled
                                      ? Color(0xFFFF0037)
                                      : Colors.black),
                              decoration: const InputDecoration(
                                  counterText: "", border: InputBorder.none)),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 55,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: pin5Filled
                                ? const Color(0x1AFF0037)
                                : const Color(0xFFF7F7F7),
                            border: Border.all(
                                color: pin5Filled
                                    ? Color(0xFFFF0037)
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: TextFormField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              controller: pin5Controller,
                              maxLength: 1,
                              focusNode: pin5Focus,
                              onChanged: (val) {

                                if (val.isEmpty) {
                                  pin4Focus.requestFocus();
                                }else {
                                  pin5Focus.unfocus();
                                }
                                  setState(() {
                                    checkOTP();
                                  });
                              },
                              autocorrect: false,
                              style: TextStyle(fontSize: 22,
                                  color: pin5Filled
                                      ? Color(0xFFFF0037)
                                      : Colors.black),
                              decoration: const InputDecoration(
                                  counterText: "", border: InputBorder.none)),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 70),
                MyButton(onPress: (){
                  Prefs.getUser((User? user){
                    print(user?.apiToken);
                  });
                     if (getAllPinsFilled())
                  {
                    var jsonParam = {
                      "code": "${pin1Controller.text}${pin2Controller.text}${pin3Controller.text}${pin4Controller.text}${pin5Controller.text}",

                    };

                    showLoading();
                    OTPVerificationApi(jsonData: jsonParam,
                        onSuccess: (user , msg) {
                      hideLoading();
                      if (user.isMobileVerify == "1") {
                        Navigator.pushNamed(context, SelectCategory.route , arguments: {'isCommingFromSignUp' : true});
                      }

                    }, onError: (error) {
                          showToast(error);
                          hideLoading();
                        });
                  }
                     },
                  text: 'Submit',
                  color:getAllPinsFilled()
                           ? Color(0xffff0037):Color(0xFFE7E7E7) ,
                  bordercolor:getAllPinsFilled()
                      ? Color(0xffff0037):Color(0xFFE7E7E7) ,
                  textcolor: getAllPinsFilled()
                          ? Colors.white
                           : const Color(0xFF363E51).withOpacity(0.6),
                  width: MediaQuery.of(context).size.width,
                  height: 54,circularRadius: 30,
                ),
                SizedBox(height: 25.w,),
                Center(
                  child: InkWell(
                    onTap: () {
                      print("On Click");
                      showLoading();
                      reSendVerifyCode(onSuccess: (data) {
                        toast(data.message ?? "");
                        hideLoading();
                      }, onError: (error) {
                        toast(error);
                        hideLoading();
                      });

                    },
                    child: Text("Didn't recieve code resend again?" ,style: TextStyle(color: Colors.blue , decoration: TextDecoration.underline, fontSize: 15.sp),),
                  ),
                ),
                SizedBox(height: 46),
                SizedBox(height: 40)
              ],
            ),
          ),
        ),
      ),
    );
  }

}
