
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Controllers/RentRequestDetail.dart';
import '../Controllers/SearchLocationWithItem.dart';
import '../Models/Ads.dart';
import '../Models/Banner.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import 'package:flutter/material.dart';
import '../Utils/helping_methods.dart';
import '../Utils/socket_sessions.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../Models/UserCategory.dart';
import '../View/views.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';
import '../Models/HomeModel.dart';
import 'Notifications.dart';

class Home extends StatefulWidget {
  static const String route = "Home";
   Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  HomeViewModel homeViewModel = HomeViewModel();
  List<Bannerobj> _categoryList = [];
  List<UserCategoryObj> _categoryObj = [];
  List<String> _radiusMiles = [];
  List<String> _rentType = [];
  List<AdsObj> _adsObj = [];
  List<bool> listBool = [];
  int? pcategoryId;
  String? pCategory;
  String? radius;
  String? rentType;
  GlobalKey? requestUpdate = GlobalKey();
  var clickedValue = false;
  int _current = 0;
   CarouselController? _controller = CarouselController();
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  LocationPermission? permission;
  Widget? notificationBadge;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() => _adsObj = []);
    }
    handlePermission();
    load();
    loadUserCategory();
    _refreshController = RefreshController(initialRefresh: false);
    loadMiles();
    loadRentType();
    ConnectSocket(onSuccess: (bool connected) {
      JoinSocket(
          onSuccess: (bool connected) {},
          onError: (String error) {
            hideLoading();
          });
    }, onError: (String error) {
      hideLoading();
    });
  }

  LatLng? currentPostion;
  bool? serviceEnabled;
  bool? serviceDenied;
  bool? locationDenied;
  double _value = 10;

  handlePermission() {
    HelpingMethods()
        .getCurrentLocation(
      buildContext: context,
      permission: permission ?? LocationPermission.denied,
      serviceEnabled: serviceEnabled ?? false,
    )
        .then((position) {
      if (position != null) {
        _getUserLocation();
      }
    }).catchError((error) {
      toast(error);
      if (error == 'services disabled') {
        serviceDenied = true;
        return;
      }
      if (error == 'permanently denied') locationDenied = true;
    });


     getnotificationBadge();

  }

  void getnotificationBadge(){

    getNotificationBadge(jsonData: {}, onSuccess: (data) {
      hideLoading();


      if (data?.unreadNoti == 0) {

          if(mounted){
            setState((){
              if (data?.unreadNoti?.first?.unread == 1) {
                notificationBadge =  Stack(clipBehavior: Clip.none, children: [
                  SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Image.asset(
                        Style.getIconImage("notification-icon@2x.png"),
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                      right: -2.w,
                      top: -2.w,
                      child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                              color: Style.redColor,
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.w))))),
                ]);
              }else {
                notificationBadge = Stack(clipBehavior: Clip.none, children: [
                  SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Image.asset(
                        Style.getIconImage("notification-icon@2x.png"),
                        fit: BoxFit.cover,
                      )),

                ]);
              }
            }); }

      }else {
        notificationBadge = Stack(clipBehavior: Clip.none, children: [
          SizedBox(
              width: 24.w,
              height: 24.w,
              child: Image.asset(
                Style.getIconImage("notification-icon@2x.png"),
                fit: BoxFit.cover,
              )),

        ]);
      }



    }, onError: (error) {
      hideLoading();
      setState((){
        notificationBadge =  Stack(clipBehavior: Clip.none, children: [
        SizedBox(
            width: 24.w,
            height: 24.w,
            child: Image.asset(
              Style.getIconImage("notification-icon@2x.png"),
              fit: BoxFit.cover,
            )),

      ]);
      });

    });
  }

  @override
  void dispose() {
    _controller = null;
    DefaultCacheManager manager = DefaultCacheManager();
    manager.emptyCache();
    super.dispose();

  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    if (mounted) {
      setState(() {
        // Your state change code goes here

        currentPostion = LatLng(position.latitude, position.longitude);

        loadAds();
      });
    }
  }

  loadRentType() {
    _rentType = ["Rent as Hours", "Rent as Days"];
  }

  loadMiles() {
    _radiusMiles = ["1 Miles", "2 Miles", "3 Miles", "4 Miles","5 Miles", "6 Miles", "7 Miles", "8 Miles","9 Miles", "10 Miles", "11 Miles", "12 Miles","13 Miles", "14 Miles", "15 Miles", "16 Miles","17 Miles", "18 Miles", "19 Miles", "20 Miles"];
  }

  load() async {
    _categoryList = [];

    getBanners(onSuccess: (list) {
      _categoryList = list;
      hideLoading();
      if (mounted) {
        setState(() {});
      }
    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }

  bool loadIfImg(int index) {
    if (_adsObj[index].media?.first?.fileType == "image") {
      return true;
    } else {
      return false;
    }
  }

  loadUserCategory() async {
    _categoryObj = [];

    getUserCategories(onSuccess: (list) {
      _categoryObj = list;
      loadAllCategory();
      loadBoolsCategory();
      hideLoading();
      if (mounted) {
        setState(() {});
      }
    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }

  loadAds() async {
    _adsObj = [];
    showLoading();
    getAds(
        type: "map",
        lat: currentPostion?.latitude.toString() ?? "",
        long: currentPostion?.longitude.toString() ?? "",
        keyword: "",
        rentType: "",
        category: 0,
        distance: "10",
        onSuccess: (list) {
          _adsObj = list;
          hideLoading();
          if (mounted) {
            setState(() {});
          }
        },
        onError: (error) {
          hideLoading();
          toast(error);
        });
  }

  loadBoolsCategory() async {
    for (var value in _categoryObj) {
      listBool.add(false);
    }
  }

  String? getRadiusFromValue(String? value) {
    if (value == "0 Miles") {
      return "";
    } else if (value == "1 Miles") {
      return "1";
    } else if (value == "1 Miles") {
      return "1";
    } else if (value == "2 Miles") {
      return "2";
    } else if (value == "3 Miles") {
      return "3";
    }else if (value == "4 Miles") {
      return "4";
    }else if (value == "5 Miles") {
      return "5";
    }else if (value == "6 Miles") {
      return "6";
    } else if (value == "7 Miles") {
      return "7";
    } else if (value == "8 Miles") {
      return "8";
    } else if (value == "9 Miles") {
      return "9";
    }else if (value == "10 Miles") {
      return "10";
    }else if (value == "11 Miles") {
      return "11";
    } else if (value == "12 Miles") {
      return "12";
    } else if (value == "13 Miles") {
      return "13";
    } else if (value == "14 Miles") {
      return "14";
    }else if (value == "15 Miles") {
      return "15";
    }else if (value == "16 Miles") {
      return "16";
    }else if (value == "17 Miles") {
      return "17";
    } else if (value == "18 Miles") {
      return "18";
    } else if (value == "19 Miles") {
      return "19";
    } else if (value == "20 Miles") {
      return "20";
    }

    return null;
  }

  loadAllCategory() async {
    CategoryUser? category;
    Map<String, dynamic> catJson = {
      "id": -1,
      "name": "All",
      "slug": "All",
      "description": "All Category",
      "image_url": "",
    };
    category = CategoryUser.fromJson(catJson);

    Map<String, dynamic> json = {
      "id": -1,
      "user_id": -1,
      "category_id": -1,
      "category": category.toJson()
    };

    UserCategoryObj? usrObjAll = UserCategoryObj.fromJson(json);
    _categoryObj.insert(0, usrObjAll);
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: 16.w,
            title: Text(
              "Home",
              textAlign: TextAlign.start,
              style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
            ),
            actions: [
              IconButton(
                icon: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Navigator.pushNamed(context, Constants.notification);


                    Navigator.pushNamed(context, Notifications.route)
                        .then((value) {
                      getnotificationBadge();
                      if (mounted) {
                        setState(() {
                          _adsObj = [];
                          _categoryObj = [];
                          _categoryList = [];
                          load();
                          loadAds();
                          loadAllCategory();
                          loadUserCategory();

                        });
                      }
                    });
                    // Navigator.pushNamed(context, LinearGraphView.route);
                  },
                  child: notificationBadge
                ),
                onPressed: () {
                  //Navigator.of(context).pop();
                },
              ),
            ]),
        body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: body(context: context)));
  }


  Widget body({context = BuildContext}) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(children: [
        Container(
            height: 8.w,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xFFF7F7F7)),
        SizedBox(height: 10.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: searchTextFieldWidget(context),
        ),
        SizedBox(height: 16.w),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1.w,
          color: const Color(0xFF707070).withOpacity(0.1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: InkWell(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => ThankYoupopUp()
                  //thankYouDialog(navigationViewModel,context)
                  );
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child:
                        Image.asset(Style.getIconImage("location-icon@2x.png")),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      "${radius ?? "10 Miles"} Radius",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) => ThankYoupopUp()
                          //thankYouDialog(navigationViewModel,context)
                          );
                    },
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child:
                          Image.asset(Style.getIconImage("chevron-icon@2x.png")),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 1.w,
          color: const Color(0xFF707070).withOpacity(0.1),
        ),
        SizedBox(height: 24.w),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 30.w,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 16.w : 0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (_categoryObj[index].category?.name == "All") {
                        showLoading();
                        getAds(
                            type: "map",
                            lat: currentPostion?.latitude.toString() ?? "",
                            long: currentPostion?.longitude.toString() ?? "",
                            keyword: "",
                            rentType: "",
                            category: 0,
                            distance: "10",
                            onSuccess: (list) {
                              _adsObj = list;
                              hideLoading();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            onError: (error) {
                              hideLoading();
                              toast(error);
                            });
                      } else {
                        showLoading();
                        getAds(
                            type: "map",
                            lat: currentPostion?.latitude.toString() ?? "",
                            long: currentPostion?.longitude.toString() ?? "",
                            keyword: "",
                            rentType: "",
                            category: _categoryObj[index].categoryId ?? 0,
                            distance: "10",
                            onSuccess: (list) {
                              _adsObj = list;
                              hideLoading();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            onError: (error) {
                              hideLoading();
                              toast(error);
                            });
                      }

                      if (mounted) {
                        setState(() {
                          for (var i = 0; i < listBool.length; i++) {
                            if (i == index) {
                              listBool[i] = true;
                            } else {
                              listBool[i] = false;
                            }
                          }

                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: listBool[index]
                              ? const Color(0xFF363E51)
                              : const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(20.w)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.w, vertical: 0.w),
                        child: Row(
                          children: [
                            Center(
                              child: Text(
                                _categoryObj[index].category?.name ?? "",
                                textAlign: TextAlign.center,
                                style: Style.getSemiBoldFont(14.sp,
                                    color: listBool[index]
                                        ? Colors.white
                                        : Style.textBlackColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  width: 16.w,
                );
              },
              itemCount: _categoryObj.length),
        ),
        SizedBox(height: 15.w),
        carouselWidget(context),
        SizedBox(height: 5.w),
        rentalsWidget(context),
      ]),
    );
  }

  String? returnImageValue(int i) {
    if (_adsObj[i].media?.first?.fileType == "image") {
      return _adsObj[i].media?.first?.fileUrl ?? "";
    } else {
      return _adsObj[i].media?.first?.thumbnailUrl ?? "";
    }
  }


  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
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
      height: 94.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 600,
      maxWidthDiskCache: 600,
    );
  }

  Widget rentalsWidget(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for ( int? i = 0; i! < _adsObj.length; i++)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RentalRequestDetail(
                              "Home", _adsObj[i ?? 0], requestUpdate, null, null , null)))
                  .then((value) {
                    getnotificationBadge();
                if (kDebugMode) {

                }
                if (mounted) {
                  setState(() {
                    _adsObj = [];
                    _categoryObj = [];
                    _categoryList = [];
                    load();
                    loadAds();
                    loadAllCategory();
                    loadUserCategory();

                  });
                }
              });
              },
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 6.5.w),
              child: Container(
                // width: 170.w,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                height: 250.h,
                decoration: BoxDecoration(
                  color: Style.textWhiteColor,
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset:
                          const Offset(0, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withAlpha(200)
                                ],
                              ).createShader(const Rect.fromLTRB(300, 10, 10, 350));
                            },
                            blendMode: BlendMode.srcOver,
                            child: _adsObj[i].media!.isNotEmpty  ? circularImageView(image: returnImageValue(i)  ?? ""  ,size: 200) : Image.asset("src/placeholder.png")
                          ),
                        ),
                          if(_adsObj[i].isSell == 1)
                          Align(
                            alignment: Alignment.topRight,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0)),
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h ),
                                child: Image.asset("src/topTagSale.png" , height: 35 , width: 45, fit: BoxFit.fill,)
                              ),
                            ),
                          )
                         ]
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Text(
                                _adsObj[i].name ?? "",
                                style: TextStyle(fontSize: 14.sp ,
                                    fontFamily: Const.aventaBold , fontWeight: FontWeight.w800 ),
                                overflow: TextOverflow.ellipsis,


                              ),
                            ),
                          ),

                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${_adsObj[i].rentCharges ?? ""}",
                              style: Style.getSemiBoldFont(13.sp),
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  Style.getIconImage("ic_rating@2x.png"),
                                  width: 12.w,
                                  height: 12.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  "(${_adsObj[i].rating ?? 0})",
                                  style: Style.getSemiBoldFont(12.sp,
                                      color: Style.textBlackColor
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ]

                ),
              ),
            ),
          ),

      ],
    );
  }

  Widget carouselWidget(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 170.w,
          enlargeCenterPage: true,
          viewportFraction: 1,
          onPageChanged: (position, reason) {
            if (kDebugMode) {

            }
            _current = position;
            if (mounted) {
              setState(() {});
            }
          },
          enableInfiniteScroll: false,
        ),
        items: _categoryList.map<Widget>((i) {
          return Builder(
            builder: (BuildContext context) {
              return Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width - 5,
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(80),
                            Colors.transparent
                          ],
                        ).createShader(
                            Rect.fromLTRB(0, 150, rect.width, rect.height));
                      },
                      blendMode: BlendMode.srcOver,
                      child: FadeInImage(
                          // height: 50,
                          // width: 50,
                          fadeInDuration: const Duration(milliseconds: 500),
                          fadeInCurve: Curves.easeInExpo,
                          fadeOutCurve: Curves.easeOutExpo,
                          placeholder: const AssetImage("src/placeholder.png"),
                          image: NetworkImage(i.imageUrl ?? "" , scale: 2.1),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset("src/placeholder.png",scale: 1.0,);
                          },
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Positioned(
                  top: 20.w,
                  left: 25.w,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 180.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i.title ?? "",
                          style: Style.getBoldFont(22.sp, color: Colors.white),
                        ),
                        Text(
                          i.description ?? "",
                          maxLines: 3,
                          style: Style.getSemiBoldFont(12.sp,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    ),
                  ),
                )
              ]);
            },
          );
        }).toList(),
      ),
      Positioned(
        bottom: 10.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _categoryList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller?.animateToPage(entry.key),
              child: Container(
                width: 8.0.w,
                height: 8.0.w,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ),
    ]);
  }

  Widget searchTextFieldWidget(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: TextField(
          keyboardType: TextInputType.name,
          textAlignVertical: TextAlignVertical.center,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          readOnly: true,
          onTap: () {


            Navigator.pushNamedAndRemoveUntil(context, SearchLocationWithItem.route, (route) => false).then((value) {
              getnotificationBadge();
              if (mounted) {
                setState(() {
                  _adsObj = [];
                  _categoryObj = [];
                  _categoryList = [];
                  load();
                  loadAds();
                  loadAllCategory();
                  loadUserCategory();


                });
              }
            });
          },
          style: Style.getRegularFont(12.sp, color: Style.textBlackColor),
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              hintText: "Search here...",
              hintStyle:
                  Style.getRegularFont(12.sp, color: Style.textBlackColor),
              contentPadding: const EdgeInsets.all(10),
              focusedBorder: Style.outlineInputBorder,
              enabledBorder: Style.outlineInputBorder,
              isCollapsed: true,
              // border: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(15.w),
              //   borderSide: const BorderSide(
              //     width: 0,
              //     style: BorderStyle.none,
              //   ),
              // ),
              suffixIcon: SizedBox(
                width: 24.w,
                height: 24.w,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.w),
                  child: IconButton(
                    icon: Image.asset(
                      Style.getIconImage("ic_filter@2x.png"),
                    ),
                    onPressed: () {
                      openFilterBottomSheet(context);
                    },
                  ),
                ),
              ),
              prefixIcon: SizedBox(
                width: 24.w,
                height: 24.w,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.w),
                  child: IconButton(
                    icon: Image.asset(
                      Style.getIconImage("ic_search@2x.png"),
                    ),
                    onPressed: () {},
                  ),
                ),
              ))),
    );
  }

  openFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SizedBox(
              height: 600.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Text(
                          "Filters",
                          style: Style.getSemiBoldFont(16.sp),
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: SizedBox(
                              width: 34.w,
                              height: 34.h,
                              child: Image.asset(
                                  Style.getIconImage("ic_cancel_grey@2x.png")),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: const Text(
                        "Category",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: Const.aventa,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 40.w,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(247, 247, 247, 1.0),
                      borderRadius:  BorderRadius.all( Radius.circular(14.0)),
                    ),
                    padding: EdgeInsets.only(left: 25.w, right: 35.w, top: 6.w),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      value: pCategory,
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      //elevation: 5,
                      style: const TextStyle(color: Colors.black),
                      // value: pCategory,
                      items:
                          _categoryObj.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value.category?.name ?? "",
                          child: Text(value.category?.name ?? ""),
                        );
                      }).toList(),
                      hint: Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, top: 6.w),
                        child: Text(
                          pCategory ?? "Select Category",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: Const.aventa),
                        ),
                      ),
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            pCategory = value;
                            // pcategoryId = int.parse(value ?? "");
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: const Text(
                        "Radius",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: Const.aventa,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 40.w,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(247, 247, 247, 1.0),
                      borderRadius:  BorderRadius.all(Radius.circular(14.0)),
                    ),
                    padding: EdgeInsets.only(left: 25.w, right: 35.w, top: 6.w),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      value: radius,
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      //elevation: 5,
                      style: const TextStyle(color: Colors.black),
                      // value: pCategory,
                      items:
                          _radiusMiles.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, top: 6.w),
                        child: Text(
                          radius ?? "Select Radius",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: Const.aventa),
                        ),
                      ),
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            radius = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: const Text(
                        "Rent Type",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: Const.aventa,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 40.w,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(247, 247, 247, 1.0),
                      borderRadius:  BorderRadius.all(Radius.circular(14.0)),
                    ),
                    padding: EdgeInsets.only(left: 25.w, right: 35.w, top: 6.w),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(
                        height: 0,
                        width: 0,
                      ),
                      value: rentType,
                      borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                      //elevation: 5,
                      style: const TextStyle(color: Colors.black),
                      // value: pCategory,
                      items: _rentType.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      hint: Padding(
                        padding:
                            EdgeInsets.only(left: 6.w, right: 6.w, top: 6.w),
                        child: Text(
                          rentType ?? "Select Rent Type",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: Const.aventa),
                        ),
                      ),
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            rentType = value;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomButton(
                          btnText: "RESET",
                          fontSize: 15.sp,
                          width: 160,
                          height: 60.w,
                          radius: 50,
                          color: Style.btnGreyColor,
                          onPressed: () {
                            loadAds();
                            updateView();
                            Navigator.pop(context);
                          }),
                      SizedBox(
                        width: 14.w,
                      ),
                      CustomButton(
                          btnText: "APPLY",
                          fontSize: 15.sp,
                          height: 60.w,
                          radius: 50,
                          width: 160,
                          onPressed: () {
                            if (pCategory == "All") {
                              _adsObj = [];
                              showLoading();
                              getAds(
                                  type: "map",
                                  lat: currentPostion?.latitude.toString() ??
                                      "",
                                  long: currentPostion?.longitude.toString() ??
                                      "",
                                  keyword: "",
                                  rentType: rentValueFilter(rentType ?? ""),
                                  category: 0,
                                  distance:
                                      getRadiusFromValue(radius ?? "") ?? "10",
                                  onSuccess: (list) {
                                    _adsObj = list;
                                    updateView();
                                    Navigator.pop(context);
                                    hideLoading();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  onError: (error) {
                                    hideLoading();
                                    updateView();
                                    Navigator.pop(context);
                                    toast(error);
                                  });
                            } else {
                              _adsObj = [];
                              showLoading();
                              getAds(
                                  type: "map",
                                  lat: currentPostion?.latitude.toString() ??
                                      "",
                                  long: currentPostion?.longitude.toString() ??
                                      "",
                                  keyword: "",
                                  rentType: rentValueFilter(rentType ?? ""),
                                  category:
                                      cateFilterValue(pCategory ?? "0") ?? 0,
                                  distance:
                                      getRadiusFromValue(radius ?? "") ?? "10",
                                  onSuccess: (list) {
                                    _adsObj = list;
                                    updateView();
                                    Navigator.pop(context);
                                    hideLoading();
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                  onError: (error) {
                                    hideLoading();
                                    updateView();
                                    Navigator.pop(context);
                                    toast(error);
                                  });
                            }
                          }),
                    ],
                  ),
                  SizedBox(height: 5.h),
                ],
              ),
            );
          });
        });
  }

  String rentValueFilter(String? value) {
    if (value == "Rent as Hours") {
      return "hr";
    } else {
      return "day";
    }
  }

  int? cateFilterValue(String? valuenew) {
    if (valuenew != "All") {
      for (var value in _categoryObj) {
        if (value.category?.name == valuenew) {
          return value.categoryId;
        }
      }
    } else {
      return 0;
    }
    return null;
  }

  updateView() {
    if (mounted) {
      setState(() {
        _categoryObj = [];
        loadUserCategory();
        listBool = [];
        loadBoolsCategory();
      });
    }
  }

  String? categoryValueFindOut(int index) {
    for (var catValue in _categoryObj) {
      if (index == catValue.categoryId) return catValue.category?.name;
    }
    return null;
  }

  // ignore: non_constant_identifier_names
  Widget ThankYoupopUp() {
    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: SizedBox(
          height: 270.h,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Set Radius",
                  style: Style.getBoldFont(
                    22.sp,
                  ),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Text(
                  "Ads will be shown with range of radius",
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

                SizedBox(
                  height: 80,
                  child: Slider(
                    min: 1,
                    max: 20,
                    divisions: 15,
                    label: '${_value.round()} Miles',
                    value: _value,
                    onChanged: (value) {
                      if(mounted) {
                        setState(() {
                          if (value.round() == 0) {
                            _value = value;
                            radius = "2 Miles";
                          } else {
                            _value = value;
                            radius = "${value.round()} Miles";
                          }
                        });
                      }
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomOutlineButton(
                          btnText: "Cancel",
                          radius: 25.w,
                          height: 50.w,
                          width: 150.w,
                          fontSize: 12.sp,
                          fontstyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w300,
                            fontFamily: Const.aventa,
                            fontStyle: FontStyle.normal,
                            fontSize: 18.sp,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: CustomButton(
                      btnText: "Submit",
                      radius: 25.w,
                      height: 50.w,
                      width: MediaQuery.of(context).size.width,
                      fontSize: 12.sp,
                      fontstyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontFamily: Const.aventa,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.sp,
                      ),
                      onPressed: () {
                        _adsObj = [];
                        showLoading();
                        getAds(
                            type: "map",
                            lat: currentPostion?.latitude.toString() ?? "",
                            long: currentPostion?.longitude.toString() ?? "",
                            keyword: "",
                            rentType: rentValueFilter(_value.toString()),
                            category: 0,
                            distance: getRadiusFromValue(radius ?? "") ?? "",
                            onSuccess: (list) {
                              _adsObj = list;
                              updateView();
                              Navigator.pop(context);
                              hideLoading();
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            onError: (error) {
                              hideLoading();
                              updateView();
                              Navigator.pop(context);
                              toast(error);
                            });
                      },
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }


}
