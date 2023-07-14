import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import '../component/custom_button.dart';


class ForgotPassword extends StatefulWidget {

  static const String route = "ForgotPassword";
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool autoValidate = false, obsure = true;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: 'ForgetPassword');

   FocusNode? emailFocus;

  String? email, pass;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ForgotPasswordBodyView(context),
    );
  }


  Widget ForgotPasswordBodyView(BuildContext context) {

    final emailTextEditing = TextEditingController();

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: autoValidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                          width: 185,
                          height: 215,
                          child: Image.asset(
                              "assets/images/logos/forgot_logo@2x.png",
                              fit: BoxFit.fill)),
                    ),
                    SizedBox(height: 30),
                    Text("Forgot Password",
                        style: const TextStyle(
                        color:  const Color(0xff1f1f1f),
                fontWeight: FontWeight.w600,
                fontFamily: Const.aventa,
                fontStyle:  FontStyle.normal,
                fontSize: 28.0
            ),
              textAlign: TextAlign.left ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Opacity(
                          opacity : 0.6000000238418579,
                          child:   Text(
                              "Enter the email address associated with your account.",
                          style: const TextStyle(
                          color:  const Color(0xff1f1f1f),
                          fontWeight: FontWeight.w400,
                          fontFamily: Const.aventa,
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
                        textAlign: TextAlign.left
                    ),
                    ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Email Address",
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color:  const Color(0xff1f1f1f),
                              fontWeight: FontWeight.w600,
                              fontFamily: Const.aventa,
                              fontStyle:  FontStyle.normal,
                              fontSize: 14.0
                          ),

                        ),

                      ),
                    ),
                    SizedBox(height: 6),
                    EditText(
                      context: context,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor:Color(0xFFF7F7F7) ,
                      isFilled:true,
                      hintText: "Email",
                      validator: validateEmail,
                      currentFocus: emailFocus,

                      onSaved: (text) {
                        email = text;
                      },
                      onChange: (text) {
                        email = text;
                      },
                    ),
                    SizedBox(height: 40),
                    CustomButton(
                        btnText: "Submit",
                        radius: 25.w,
                        height: 50.w,
                        width: MediaQuery.of(context).size.width,
                        fontSize: 12.sp,
                        fontstyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontFamily: Const.aventa,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                        onPressed: () {
                          if (_validateInputs()) {
                            showLoading();
                            forgetPassword(
                                email: '$email',
                                onSuccess: (BaseModel baseModel) {
                                  hideLoading();
                                  toast(baseModel.message);
                                  Navigator.pop(context);
                                },
                                onError: (error) {
                                  hideLoading();
                                  toast(error);
                                });
                          } else {
                          }
                        }),
                    SizedBox(height: 40),
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
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
    if(mounted){
      setState(() {
        autoValidate = true;
      });
    }

      return false;
    }
  }
}
