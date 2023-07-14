import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Controllers/account.dart';
import '../Controllers/inbox.dart';
import '../Controllers/more.dart';

import '../Controllers/Home.dart';
import '../Extensions/style.dart';
import 'PostAdView.dart';

class Dashboard extends StatefulWidget {
  static const String route = "Dashboard";
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  final List<Widget> screens = [
     Home(),
    InboxTab(),
    PostAd(),
    AccountTab(),
    MoreTab(),

  ];
  late AnimationController _controller;

  final PageStorageBucket bucket = PageStorageBucket();
  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    super.initState();
  }

  int _previousScreenIndex = 0;
  int currentScreenIndex = 0;

  getCurrentScreenIndex() {
    return currentScreenIndex;
  }

  updateToPreviousScreen() {
    updateCurrentScreen(_previousScreenIndex);
  }

  updateCurrentScreen(int index) {
    currentScreenIndex = index;
    if (index != 2) {
      _previousScreenIndex = index;
    }
    setState(()
    {

    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: PageStorage(
        bucket: bucket,
        child: screens[getCurrentScreenIndex()],
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 20,
                      offset: Offset(0, -3), // changes position of shadow
                    ),
                  ],
                ),
                width: size.width,
                height: 80 + (MediaQuery.of(context).padding.bottom / 2),
              )),
          Positioned(
            width: size.width,
            bottom: 20 + (MediaQuery.of(context).padding.bottom / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: 20.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    //Navigator.pushNamed(context, Home.route);
                    if (getCurrentScreenIndex() == 2) {
                      // _controller.reverse();
                    }
                    updateCurrentScreen(0);

                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: getCurrentScreenIndex() ==
                              0
                              ? Image.asset(
                              Style.getIconImage("home-selected-icon@2x.png"))
                              : Image.asset(Style.getIconImage(
                              "home-unselected-icon@2x.png"))),
                      SizedBox(height: 6),
                      Text(
                        "Home",
                        style: Style.getMediumFont(12,
                            color:
                            getCurrentScreenIndex() == 0
                                ? Style.redColor
                                : Style.textBlackColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                   // Navigator.pushNamed(context, InboxTab.route);
                    if (getCurrentScreenIndex() == 2) {
                      _controller.reverse();
                    }

                    updateCurrentScreen(1);

                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child: getCurrentScreenIndex() ==
                              1
                              ? Image.asset(
                              Style.getIconImage("inbox-selected-icon@2x.png"))
                              : Image.asset(Style.getIconImage(
                              "inbox-unselected-icon@2x.png"))),
                      SizedBox(height: 6),
                      Text(
                        "Inbox",
                        style: Style.getRegularFont(12,
                            color:
                            getCurrentScreenIndex() == 1
                                ? Style.redColor
                                : Style.textBlackColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 34.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (getCurrentScreenIndex() == 2) {
                      updateToPreviousScreen();

                      _controller.forward();
                    } else {
                      updateCurrentScreen(2);

                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: SizedBox(
                      //color: Colors.green,
                      width: 44,
                      height: 44,
                      child: Stack(children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: Image.asset(
                            Style.getIconImage("add-unselected-icon@3x.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity:
                          getCurrentScreenIndex() == 2
                              ? 0.0
                              : 1.0,
                          duration: const Duration(milliseconds: 400),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Image.asset(
                              Style.getIconImage("add-selected-icon@3x.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                ),
                SizedBox(width: 30.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {

                   // Navigator.pushNamed(context, AccountTab.route);
                    if (getCurrentScreenIndex() == 2) {
                      _controller.reverse();
                    }

                    updateCurrentScreen(3);

                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child:
                          getCurrentScreenIndex() == 3
                              ? Image.asset(Style.getIconImage(
                              "account-selected-icon@2x.png"))
                              : Image.asset(Style.getIconImage(
                              "account-unselected-icon@2x.png"))),
                      SizedBox(height: 6),
                      Center(
                        child: Text(
                          "Account",
                          textAlign: TextAlign.center,
                          style: Style.getRegularFont(12,
                              color:
                              getCurrentScreenIndex() ==
                                  3
                                  ? Style.redColor
                                  : Style.textBlackColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 30.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    //Navigator.pushNamed(context, MoreTab.route);
                    if (getCurrentScreenIndex() == 2) {
                      _controller.reverse();
                    }
                    updateCurrentScreen(4);

                  },
                  child: Column(
                    children: [
                      SizedBox(
                          width: 24,
                          height: 24,
                          child:getCurrentScreenIndex() ==
                              4
                              ? Image.asset(
                              Style.getIconImage("more-selected-icon@2x.png"))
                              : Image.asset(Style.getIconImage(
                              "more-unselected-icon@2x.png"))),
                      SizedBox(height: 6),
                      Text(
                        "More",
                        style: Style.getRegularFont(12,
                            color:
                            getCurrentScreenIndex() == 4
                                ? Style.redColor
                                : Style.textBlackColor),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
          )
        ],
      ),
    );
  }
}
