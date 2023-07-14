import 'dart:io';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/main.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../Controllers/verification.dart';
import '../Extensions/style.dart';
import '../Utils/Prefs.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import '../component/custom_button.dart';
import 'Dashboard.dart';
import 'forgotPassword.dart';
import 'signup.dart';
import '../Utils/Const.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String route = "Login";
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Observer {

  FocusNode emailFocus = FocusNode(),
      passFocus = FocusNode() ,
       mobileFocus = FocusNode();

  String? email, pass, deviceToken , mobileno;

  bool autoValidate = false,
      obsure = true;
  TextEditingController? mobilenumber;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_Login');

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: emailFocus),
        KeyboardActionsItem(focusNode: passFocus),

      ],
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Country _selectedDialogCountry = Country(isoCode: "US", iso3Code: "USA", phoneCode: "1", name: "USA");

  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();

  String? errorMessage;

  @override
  void initState() {
    // TODO: implement initState
    Observable.instance.addObserver(this);
    TheAppleSignIn.onCredentialRevoked?.listen((_) {
    });
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: body(context),

    );
  }

  Widget body(BuildContext context) {
    return KeyboardActions(
      config: _buildConfig(context),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 55,
                        height: 62,
                        child: Image.asset("src/app-logo@2x.png", fit: BoxFit
                            .contain,),

                      ),
                    ),
                    SizedBox(height: 90),
                    Text("Welcome Back!",
                        style: const TextStyle(
                          color: const Color(0xff1f1f1f),
                          fontWeight: FontWeight.w500,
                          fontFamily: Const.aventaBold,
                          fontStyle: FontStyle.normal,
                          fontSize: 28,
                        ),
                        textAlign: TextAlign.left),
                    SizedBox(height: 8),
                    SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Opacity(
                          opacity: 0.6000000238418579,
                          child: Text(
                              "Login to continue using your account",
                              style: const TextStyle(
                                color: const Color(0xff1f1f1f),
                                // fontWeight: FontWeight.w400,
                                fontFamily: Const.aventa,
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0,
                              ),
                              textAlign: TextAlign.left
                          ),
                        )
                    ),
                    SizedBox(height: 36),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Opacity(
                            opacity: 0.800000011920929,
                            child: Text(
                                "Email Address",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0
                                ),
                                textAlign: TextAlign.left
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 6),
                    EditText(
                      context: context,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Email",
                      validator: validateEmail,
                      currentFocus: emailFocus,
                      nextFocus: passFocus,
                      onSaved: (text) {
                        email = text;
                      },
                      onChange: (text) {
                        email = text;
                      },


                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          child: Opacity(
                            opacity: 0.800000011920929,

                            child: Text(
                                "Password",
                                style: const TextStyle(
                                    color: const Color(0xff1f1f1f),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Const.aventa,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14.0
                                ),
                                textAlign: TextAlign.left
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 6),
                    EditText(
                      context: context,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      filledColor: const Color(0xFFF7F7F7),
                      borderColor: Color(0xFFF7F7F7),
                      isFilled: true,
                      hintText: "Password",
                      obscure: obsure,
                      currentFocus: passFocus,
                      validator: validatePassword,
                      isPassword: true,

                      icon: obsure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      suffixClick: () {
                        setState(() {
                          obsure = !obsure;
                        });
                      },
                      onChange: (text) {
                        pass = text;
                      },
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {

                            // applelogin();
                            Observable.instance.removeObserver(this);
                            Navigator.pushNamed(context, ForgotPassword.route)
                                .then((value) {
                              Observable.instance.addObserver(this);
                            });
                          },
                          child: Text(
                              "Forgot Password?",
                              style: const TextStyle(
                                  color: const Color(0xffff0037),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Const.aventa,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 16.0
                              ),
                              textAlign: TextAlign.right
                          )
                      ),
                    ),
                    SizedBox(height: 36),
                    CustomButton(
                        btnText: "Login",
                        radius: 25.w,
                        height: 50.w,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        fontSize: 12.sp,
                        fontstyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: Const.aventa,
                          fontStyle: FontStyle.normal,
                          fontSize: 18.sp,
                        ),
                        onPressed: () {
                          if (_validateInputs()) {
                            if (email == null ||
                                pass == null)
                              toast('All fields are required');
                            else {
                              String? deviceToken;
                              Map<String, dynamic> jsonParam = {};
                              Prefs.getFCMToken.then((value) {

                                if(value != null) {
                                  deviceToken = value;
                                  jsonParam = {
                                    "email": email,
                                    "password": pass,
                                    "device_type": Platform.isAndroid
                                        ? "android"
                                        : 'ios',
                                    "device_token": deviceToken,

                                  };
                                  showLoading();
                                  login(
                                      jsonData: jsonParam,
                                      onSuccess: (user) {
                                        hideLoading();
                                        if (user.isMobileVerify == "0") {
                                          Observable.instance.removeObserver(
                                              this);
                                          Navigator.pushNamed(
                                              context, OTPVerification.route)
                                              .then((value) {
                                            Observable.instance.addObserver(this);
                                          });
                                          hideLoading();
                                        } else {
                                          Observable.instance.removeObserver(
                                              this);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, Dashboard.route, (
                                              route) => false).then((value) {
                                            Observable.instance.addObserver(this);
                                          });
                                        }


                                        showToast("Login successfull");
                                        // Navigator.pushNamedAndRemoveUntil(
                                        //     context, Dashboard.route, (route) => false);


                                      },
                                      onError: (error) {
                                        hideLoading();
                                        toast(error);
                                      });
                                }else {
                                  getToken();
                                }


                              });


                            }
                          }
                        }),
                    SizedBox(height: 46),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            signup();
                          },
                          child: SizedBox(
                              width: 55,
                              height: 55,
                              child: Image.asset(
                                  "src/google-logo@2x.png",
                                  fit: BoxFit.contain)),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () {
                            facebookLoginApi();
                          },
                          child: SizedBox(
                              width: 55,
                              height: 55,
                              child: Image.asset(
                                  "src/facebook-logo@2x.png",
                                  fit: BoxFit.contain)),
                        ),
                        SizedBox(width: 16),

                      ],
                    ),
                    SizedBox(height: 15.h,),
                    if (Platform.isIOS)
              FutureBuilder<bool>(
              future: _isAvailableFuture,
              builder: (context, isAvailableSnapshot) {
                if (!isAvailableSnapshot.hasData) {
                  return Container(child: Text('Loading...'));
                }

                return isAvailableSnapshot.data!
                    ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16.h,
                      ),
                      AppleSignInButton(
                        onPressed: logIn,
                      ),
                      if (errorMessage != null) Text(errorMessage!),
                    ])
                    : Text(
                    'Sign in With Apple not available. Must be run on iOS 13+');
              }),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Don’t have an account?",
                          style: TextStyle(
                              color: const Color(0xff1f1f1f),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Aventa",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Observable.instance.removeObserver(this);
                            Navigator.pushNamed(context, SignUp.route).then((
                                value) {
                              Observable.instance.addObserver(this);
                            });
                          },
                          child: Text(" Create Account",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "Aventa",
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0,
                              color: Color(0xffff0037),
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

  void logIn() async {

    Prefs.getFCMToken.then((value) {
      deviceToken = value;
    });

    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

      // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential?.user);

        if (result.credential?.email != null) {
          await FlutterSecureStorage()
              .write(key: "email", value: result.credential?.email);
        }

        if (result.credential?.fullName?.givenName != null) {
          await FlutterSecureStorage()
              .write(key: "first_name", value: result.credential?.fullName?.givenName);
        }

        if (result.credential?.fullName?.familyName != null) {
          await FlutterSecureStorage()
              .write(key: "last_name", value: result.credential?.fullName?.familyName);
        }


        //Social Login.
        if (result.status == AuthorizationStatus.authorized) {

          final userId = await FlutterSecureStorage().read(key: "userId");
          final email = await FlutterSecureStorage().read(key: "email");
          final first_name = await FlutterSecureStorage().read(key: "first_name");
          final last_name = await FlutterSecureStorage().read(key: "last_name");

          var jsonParam = {
            "device_type": Platform.isAndroid ? "android" : 'ios',
            "device_token": deviceToken ?? "123456",
            "platform_id": "${result.credential?.user}",
            "platform_type": "${SocialLoginConstant.apple}",
            "address": "",
            "latitude": "0.0",
            "longitude": "0.0",
            "email": "${result.credential?.email}",
            "first_name": "${result.credential?.fullName?.givenName}",
            "last_name": "${result.credential?.fullName?.familyName}",
          };
          if (result.credential?.user == userId) {
            if (result.credential?.email == null) {
              jsonParam["email"] = "${email}";
            }

            if (result.credential?.fullName?.givenName == null) {
              jsonParam["first_name"] = "${first_name}";
            }

            if (result.credential?.fullName?.familyName == null) {
              jsonParam["last_name"] = "${last_name}";
            }
          }
          socialLoginApi(jsonParam ,"${result.credential?.fullName?.givenName}" ,"${result.credential?.fullName?.familyName}"  );
        }else {
          toast(result.error?.localizedDescription);
        }
        break;

      case AuthorizationStatus.error:
        setState(() {
          errorMessage = result.error?.localizedDescription;
          toast(result.error?.localizedDescription);
        });
        break;

      case AuthorizationStatus.cancelled:
        break;
    }
  }

  Widget socialButton(String text, String icon, VoidCallback onPress,{bool isApple=false}) {
    return MyButton(
        height: 48,

        //color: Colors.white70,
        onPress: onPress,
        child: Row(
          children: [
            if(isApple == true)
              SizedBox(width: 6,),
            Image.asset(
              icon,
              scale: 1.7,
            ),
            if(isApple == true)
              SizedBox(width: 15,),
            Spacer(
              flex: 2,
            ),
            Text(text,
                style: TextStyle(
                    color: Color(0xff2f394e),
                    fontWeight: FontWeight.w400,
                    fontFamily: Const.aventaBold,
                    fontSize: 16.0)),
            Spacer(
              flex: 3,
            )
          ],
        ));
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

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    setState(() {
    });
  }

  Future<void> signup() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn
        .signIn();
    if (googleSignInAccount != null) {

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);

      Prefs.getFCMToken.then((value) {
        deviceToken = value;
        var jsonParam = {
          "device_type": Platform.isAndroid ? "android" : 'ios',
          "device_token": deviceToken ?? "123456",
          "platform_id": "${result.user?.uid}",
          "platform_type": "${SocialLoginConstant.gmail}",
          "address": "",
          "latitude": "0.0",
          "longitude": "0.0",
          "email": "${result.user?.email}",
          "first_name": "${result.user?.displayName?.split(" ")[0]}",
          "last_name": "${result.user?.displayName?.split(" ")[1]}",
          "image_url" : result.user?.photoURL,
          "mobile_no" : result.user?.phoneNumber,


        };

        socialLoginApi(jsonParam ,"${result.user?.displayName?.split(" ")[0]}" ,"${result.user?.displayName?.split(" ")[1]}"  );

      });
    }
  }


  void socialLoginApi(Map<String, dynamic> params , String? firstName , String? lastName) {
    showLoading();
    Sociallogin(
        jsonData: params,
        onSuccess: (user) {
          hideLoading();
          if (user.isMobileVerify == "0") {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) =>
                    phoneNumberUpdate(user.slug , firstName , lastName)
              //thankYouDialog(navigationViewModel,context)
            );
          }else {
            Navigator.pushNamedAndRemoveUntil(
                context, Dashboard.route, (route) => false);
          }

        },
        onError: (error) {
          if (error == "The name field is required." &&
              params["platform_type"] == SocialLoginConstant.apple) {
            showToast(
                "Rentarbo App need to access your info. please do step goto your iphone settings -> tap on your apple ID -> Password and Security -> Apps using Apple ID -> select Tado app and Stoping using Apple ID ");
          }
          else {
            toast(error);
          }
          hideLoading();
        });
  }

  Future<void> facebookLoginApi() async {



    // Create an instance of FacebookLogin
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken? accessToken = result.accessToken;
      // get the user data
      // by default we get the userId, email,name and picture
      final profile = await FacebookAuth.instance.getUserData();

      String? id = accessToken?.userId;
      String? name = profile["name"];
      String? first_name = profile["first_name"];
      String? last_name = profile["last_name"];
      String? email = profile["email"];
      String? img = profile["picture"]["data"]["url"];


      if (accessToken?.token != null) {
        var image = profile["picture"];
        Prefs.getFCMToken.then((value) {

          if (value != null) {
            deviceToken = value;
            var jsonParam = {
              "device_type": Platform.isAndroid ? "android" : 'ios',
              "device_token": deviceToken ?? "123456",
              "platform_id": "$id",
              "platform_type": SocialLoginConstant.facebook,
              "address": "",
              "latitude": "0.0",
              "longitude": "0.0",
              "email": "$email",
              "first_name": "${profile["name"]?.split(" ")[0]}",
              "last_name": "${profile["name"]?.split(" ")[1]}",
              "mobile_no" : "${profile["mobile_no"]}",
              "image_url" : "${profile["picture"]["data"]["url"]}",

            };

            socialLoginApi(jsonParam,"${profile["name"]?.split(" ")[0]}" ,"${profile["name"]?.split(" ")[1]}" );
          }else {
            getToken();

          }

        });

      }
      //Logout
      await FacebookAuth.instance.logOut();
    } else {
      toast(result.message);
    }
  }


  Widget phoneNumberUpdate(String? slug,String? firstName ,String? lastName ) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: SizedBox(
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              "Please enter mobile number to begin.",
              textAlign: TextAlign.center,
              style: Style.getMediumFont(
                12.sp,
              ),
            ),
            SizedBox(height: 15.h,),
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
                SizedBox(width: 12.w,),
                EditText(
                  width: 150.w,
                  context: context,
                  textInputType: Platform.isAndroid ? TextInputType.phone : TextInputType.numberWithOptions(signed: true, decimal: true),
                  textInputAction: TextInputAction.next,
                  filledColor: const Color(0xFFF7F7F7),
                  borderColor: Color(0xFFF7F7F7),
                  isFilled: true,
                  hintText: "Phone Number",
                  validator: validateMobile,
                  currentFocus: mobileFocus,
                  nextFocus: emailFocus,
                  controller: mobilenumber,
                  //
                  onSaved: (text) {
                    mobileno = "+${_selectedDialogCountry.phoneCode}-${text}";

                  },
                  onChange: (text) {
                    mobileno = text;
                  },
                ),
              ],
            ),
            SizedBox(
              height: 22.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  btnText: "Continue",
                  radius: 25.w,
                  height: 50.w,
                  width: 190.w,
                  fontSize: 12.sp,
                  fontstyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: Const.aventa,
                    fontStyle: FontStyle.normal,
                    fontSize: 18.sp,
                  ),
                  onPressed: () {
                      if (validateMobile(mobileno) != "Phone number must be 1234567890.") {
                        editProfile(slug ?? "",firstName ,lastName);
                      }else{
                        toast(validateMobile(mobileno));
                      }
                  },
                ),
                SizedBox(width: 10.w,),

              ],
            )
          ],
        ),
      ),
    ),
  );

  editProfile(String? slug ,String? firstName , String? lastName)
  {
    showLoading();
    var jsonData = {'mobile_no':'+${_selectedDialogCountry.phoneCode}-$mobileno','_method':'PUT' , "first_name" : firstName , "last_name" : lastName};
    var urlString = 'user/${slug ?? ""}';
      editProfileApi(jsonData: jsonData, url: urlString, onSuccess: (userData){
        hideLoading();
        Prefs.setUser(userData);
        Observable.instance.removeObserver(
            this);
        Navigator.pushNamed(
            context, OTPVerification.route)
            .then((value) {
          Observable.instance.addObserver(this);
        });
      }, onError: (error)
      {
        hideLoading();
        toast(error);

      });
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





