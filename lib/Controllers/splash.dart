import 'dart:ui';
import '../Controllers/Dashboard.dart';
import '../Controllers/onBoardingScreen/onBoardingScreen.dart';
import '../Utils/Prefs.dart';
import 'package:flutter/material.dart';
import '../Models/User.dart';
import 'login.dart';

class Splash extends StatefulWidget {
  static const String route = "Splash";
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    load();
    Future.delayed(Duration(seconds: 2), () {
      navigate(context);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: null,
      bottomSheet: null,
      backgroundColor: Color.fromRGBO(36, 36, 36, 1.0),
      body: SafeArea(
        child: Center(
          child:Image.asset('src/splash_bg.png',width: double.infinity , height: double.infinity,fit: BoxFit.cover,alignment: Alignment.center,),
        ),
      ),
    );
  }
  User? userObj;

  load() async {
    Prefs.getUser((User? user) {
      setState(() {
        this.userObj = user;
        print(userObj?.imageUrl);
      });
    });
  }


 String? returnRoute() {

      if (userObj != null) {
        if (userObj?.isMobileVerify  == "0") {
          return Login.route;
        } else {
          return Dashboard.route;
        }
      }else {
        return OnBoardingScreen.route;
      }

  }

  void navigate(context) {
            Navigator.pushReplacementNamed(
              context, returnRoute() ?? OnBoardingScreen.route ,);
    }



}
