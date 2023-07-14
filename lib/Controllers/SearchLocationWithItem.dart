
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
// import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
// import 'package:rentarbo/views/rental_request_detail/rental_request_content_view.dart';

import '../../utils/style.dart';
import '../Models/Ads.dart';
import '../Models/UserCategory.dart';
import '../Utils/AddressModel.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import '../Utils/helping_methods.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';

import '../component/custom_button.dart';
import 'Dashboard.dart';
import 'RentRequestDetail.dart';




class SearchLocationWithItem extends StatefulWidget {
  static const String route = "SearchLocationWithItem";
   LatLng? userLatLng;
  @override
  State<SearchLocationWithItem> createState() => _SearchLocationWithItemState();
}

class _SearchLocationWithItemState extends State<SearchLocationWithItem> with WidgetsBindingObserver  {

  FocusNode searchTextFocus = FocusNode();
  LatLng? latLng;
  List<AdsObj> _adsObj = [];
  Completer<GoogleMapController>? _controller = Completer();
  bool? serviceEnabled,
      locationDenied = false,
      serviceDenied = false;
  LocationPermission? permission;
  late TextEditingController searchEditTextController;
   Set<Marker>? markers = Set(); //markers for google map
//location to show in map
  Widget? googleMapview;
  late BuildContext contextView;
  SlidingUpPanelController? panelController = SlidingUpPanelController();
  GlobalKey? requestUpdate = GlobalKey();

  int? pcategoryId;
  String? pCategory;
  String? radius;
  String? rentType;
  String? keyword;
  List<bool> listBool = [];
  List<String> _radiusMiles = [];
  List<String> _rentType = [];
  List<UserCategoryObj> _categoryObj = [];
  String img = "ic_bottomsheet.png";
  Set<Circle>? circles;
   AddressModel? address;

  @override
  void initState() {
    // TODO: implement initState
    DefaultCacheManager manager = new DefaultCacheManager();
    manager.emptyCache();
    searchEditTextController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    _adsObj = [];
    _categoryObj = [];
    _getUserLocation();
    loadMiles();
    loadRentType();
    loadAllCategory();
    loadUserCategory();
    super.initState();
  }


  @override
  void dispose() {
    _adsObj = [];
    _controller = null;
    googleMapview = null;
    pcategoryId = null;
    pCategory = null;
    radius = null;
    keyword = null;
    rentType = null;
    listBool = [];
    _radiusMiles = [];
    _rentType = [];
    _categoryObj = [];
    markers = null;
    circles = null;
    super.dispose();
  }

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition();
    if (this.mounted) {
      setState(() {
        // Your state change code goes here
        latLng = widget.userLatLng;
        widget.userLatLng = LatLng(position.latitude, position.longitude);
        loadAds();
        if (widget.userLatLng != null) {
          handlePermission();
          animateCamera(widget.userLatLng ?? LatLng(position.latitude, position.longitude));
        } else {
          widget.userLatLng = LatLng(40.7128, 74.0060);

        }

        HelpingMethods().getAddress(position.latitude,
            position.longitude).then((value) {
          var newvalue = value as AddressModel;
          setState((){
            address = newvalue;
            searchEditTextController.text = value.fullAddress!;
          });

        });

        circles = Set.from([Circle(
          circleId: CircleId("0"),
          center: LatLng(position.latitude, position.longitude),
          radius: double.parse("200"),
          strokeColor: Colors.blue.withOpacity(0.5),
        fillColor: Colors.blue.withOpacity(0.5)
        )]);

        addGoogleMap(contextView, getmarkers(), circles!);

      });
    }


  }

  loadUserCategory() async {
    showLoading();
    _categoryObj = [];
    getUserCategories(onSuccess: (list) {
      _categoryObj = list;
      loadAllCategory();
      loadBoolsCategory();
      hideLoading();
      if (this.mounted) {
        setState(() {});
      }
    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }

  loadAllCategory() async {
  }

  int? cateFilterValue(String? valuenew) {

    if (valuenew != "All") {
      for(var value in _categoryObj) {
        if ( value.category!.name! == valuenew!) {
          return value.categoryId!;
        }
      }
    }else {
      return 0;
    }

  }

  loadBoolsCategory() async {
    for (var value in _categoryObj) {
      listBool.add(false);
    }
  }

  loadMiles() {
    _radiusMiles = ["5 Miles" , "10 Miles","20 Miles","30 Miles" ];
  }


  loadRentType() {
    _rentType = ["Rent as Hours" ,"Rent as Days" ];
  }

  updateView() {
    if (this.mounted) {
      setState(() {
        _categoryObj = [];
        loadUserCategory();
        listBool = [];
        loadBoolsCategory();
      });
    }
  }

  String rentValueFilter(String? value) {
    if (value == "Rent as Hours") {
      return "hr";
    }else if (value == "Rent as Days") {
      return "day";
    }else {
      return "";
    }
  }

  String? getRadiusFromValue(String? value){
    if (value == "5 Miles"){
      return "5";
    }else if (value == "10 Miles") {
      return "10";
    }else if (value == "20 Miles") {
      return "20";
    }else if (value == "30 Miles") {
      return "30";
    }else {
      return "";
    }
  }

  openFilterBottomSheet(BuildContext context) {
    final categoryTextEditing = TextEditingController();
    final radiusTextEditing = TextEditingController();
    final rentTypeTextEditing = TextEditingController();
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                return  SizedBox(
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
                          child: Text(
                            "Category",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: Const.aventa,
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 40.w,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 1.0),
                          borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                        ),
                        padding: EdgeInsets.only(left: 25.w , right: 35.w , top: 6.w),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(height: 0,width: 0,) ,
                          value: pCategory,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          // value: pCategory,
                          items: _categoryObj!.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: "${value.category?.name ?? ""}",
                              child: Text("${value.category?.name ?? ""}"),
                            );
                          }).toList(),
                          hint: Padding(
                            padding: EdgeInsets.only(left: 6.w , right: 6.w , top: 6.w),
                            child: Text(
                              "${pCategory ?? "Select Category"}",
                              style:  TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: Const.aventa),
                            ),
                          ),
                          onChanged: (String? value) {
                            if (this.mounted) {
                              setState(() {
                                pCategory = value!;
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
                          child: Text(
                            "Radius",
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: Const.aventa,
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 40.w,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 1.0),
                          borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                        ),
                        padding: EdgeInsets.only(left: 25.w , right: 35.w , top: 6.w),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(height: 0,width: 0,) ,
                          value: radius,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          // value: pCategory,
                          items: _radiusMiles!.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: "${value ?? ""}",
                              child: Text("${value ??  ""}"),
                            );
                          }).toList(),
                          hint: Padding(
                            padding: EdgeInsets.only(left: 6.w , right: 6.w , top: 6.w),
                            child: Text(
                              "${radius ?? "Select Radius"}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: Const.aventa),
                            ),
                          ),
                          onChanged: (String? value) {
                            if (this.mounted) {
                              setState(() {
                                radius = value!;
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
                          child: Text(
                            "Rent Type",
                            textAlign: TextAlign.start,
                            style:  const TextStyle(
                                color:  Colors.black,
                                fontWeight: FontWeight.w600,
                                fontFamily: Const.aventa,
                                fontStyle:  FontStyle.normal,
                                fontSize: 14.0
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        height: 40.w,
                        width: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 1.0),
                          borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                        ),
                        padding: EdgeInsets.only(left: 25.w , right: 35.w , top: 6.w),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: SizedBox(height: 0,width: 0,) ,
                          value: rentType,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          style: TextStyle(color: Colors.black),
                          items: _rentType!.map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: "${value ?? ""}",
                              child: Text("${value ??  ""}"),
                            );
                          }).toList(),
                          hint: Padding(
                            padding: EdgeInsets.only(left: 6.w , right: 6.w , top: 6.w),
                            child: Text(
                              "${rentType ?? "Select Rent Type"}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.sp,
                                  fontFamily: Const.aventa),
                            ),
                          ),
                          onChanged: (String? value) {
                            if (this.mounted) {
                              setState(() {
                                rentType = value!;
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
                                // loadAds();
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
                                  googleMapview = null;
                                  showLoading();
                                  getAds(type: "map", lat: widget.userLatLng!.latitude.toString(), long: widget.userLatLng!.longitude.toString(), keyword: "", rentType: rentValueFilter(rentType ?? ""), category: 0 , distance: getRadiusFromValue(radius ?? "") ?? "", onSuccess: (list) {
                                    _adsObj = list;
                                    if (list.isNotEmpty) {
                                      setState((){
                                        circles = Set.from([Circle(
                                            circleId: CircleId("0"),
                                            center: LatLng(double.parse(_adsObj.first.pickupLat ?? "0.0"), double.parse(_adsObj.first.pickupLng ?? "0.0") ),
                                            radius: double.parse("100" ?? "0"),
                                            strokeColor: Colors.blue.withOpacity(0.5),
                                            fillColor: Colors.blue.withOpacity(0.5)
                                        )]);
                                        googleMapview = addGoogleMap(contextView, getmarkers() , circles!);

                                      for (var value in _adsObj) {
                                        animateCamera(LatLng(double.parse(value.pickupLat!), double.parse(value.pickupLng!)));
                                      }

                                      });

                                      updateView();
                                      Navigator.pop(context);
                                    }else {
                                      toast("Record Not Found");
                                    }

                                    hideLoading();
                                    if (this.mounted) {
                                      setState(() {});
                                    }
                                  }, onError: (error) {
                                    hideLoading();
                                    updateView();
                                    Navigator.pop(context);
                                    toast(error);
                                  });

                                }else {


                                  _adsObj = [];
                                  googleMapview = null;
                                  showLoading();
                                  getAds(type: "map", lat: widget.userLatLng!.latitude.toString(), long: widget.userLatLng!.longitude.toString(), keyword: keyword ?? "", rentType: rentValueFilter(rentType ?? ""), category: cateFilterValue(pCategory ?? "0") ?? 0 , distance: getRadiusFromValue(radius ?? "") ?? "", onSuccess: (list) {
                                    _adsObj = list;
                                    if (list.isNotEmpty) {
                                      setState((){
                                        circles = Set.from([Circle(
                                            circleId: CircleId("0"),
                                            center: LatLng(double.parse(_adsObj.first.pickupLat ?? "0.0"), double.parse(_adsObj.first.pickupLng ?? "0.0") ),
                                            radius: double.parse("100" ?? "0"),
                                            strokeColor: Colors.blue.withOpacity(0.5),
                                          fillColor: Colors.blue.withOpacity(0.5)
                                        )]);

                                        googleMapview = addGoogleMap(contextView, getmarkers() , circles!);

                                      for (var value in _adsObj) {
                                        animateCamera(LatLng(double.parse(value.pickupLat!), double.parse(value.pickupLng!)));
                                      }
                                      });

                                      updateView();
                                      Navigator.pop(context);
                                    }else {
                                      toast("Record not Found");
                                    }

                                    hideLoading();
                                    if (this.mounted) {
                                      setState(() {});
                                    }
                                  }, onError: (error) {
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
              }

          );
        });
  }


  Widget searchTextFieldWidget(BuildContext context) {
    return SizedBox(
      height: 45.h,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w , right: 16.w , top: 8.h),
        child: TextField(
            keyboardType: TextInputType.name,
            textAlignVertical: TextAlignVertical.center,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            readOnly: false,
            focusNode: searchTextFocus,
            onChanged: (value) {
              keyword = value;
              if (keyword!.length! >= 3) {
                loadAds();
              }

            },
            onSubmitted: (value) {
              keyword = value;
              if (value.length >= 3) {
                loadAds();
              }else if (value.length < 3) {
                toast("search charactor must be greater then 3.");
              }

            },
            onTap: () {

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
      ),
    );
  }



  Set<Marker> getmarkers()  { //markers to place on map
      if (mounted) {
        setState(() {
          for (var value in _adsObj) {
            LatLng showLocation = LatLng(
                double.parse(value.pickupLat!), double.parse(value.pickupLng!));
            markers?.add(Marker( //add first marker
              markerId: MarkerId(showLocation.toString()),
              position: showLocation, //position of marker
              infoWindow: InfoWindow( //popup info
                title: value.name,
                snippet: value.description,
              ),
              icon: BitmapDescriptor.defaultMarker, //Icon for Marker
            ));
          }
        });
      }
      //add more markers here
  return markers ?? Set();
}

  loadAds() async {
    _adsObj = [];
    showLoading();
    getAds(type: "map", lat: "${widget.userLatLng!.latitude}", long:"${widget.userLatLng!.longitude}", keyword: keyword ?? "", rentType:  rentValueFilter(rentType ?? "") , category: cateFilterValue(pCategory ?? "0") ?? 0 , distance: getRadiusFromValue(radius ?? "") ?? "", onSuccess: (list) {
      _adsObj = list;
      hideLoading();
      if (list.isNotEmpty) {
        if (this.mounted) {
          setState(() {
            for (var value in _adsObj)
              animateCamera(LatLng(double.parse(value.pickupLat!),
                  double.parse(value.pickupLng!)));

            HelpingMethods().getAddress(double.parse(_adsObj.first.pickupLat!),
                double.parse(_adsObj.first.pickupLng!)).then((value) {
              var newvalue = value as AddressModel;
              address = newvalue;
              searchEditTextController.text = value.fullAddress!;
            });
            searchTextFocus.unfocus();
            googleMapview = addGoogleMap(contextView, getmarkers() , circles!);
          });


        }
      }else {
        toast("Record Not Found");

        HelpingMethods().getAddress(widget.userLatLng!.latitude,
            widget.userLatLng!.longitude!).then((value) {
          var newvalue = value as AddressModel;
          address = newvalue;
          searchEditTextController.text = value.fullAddress!;
        });
        googleMapview = addGoogleMap(contextView, getmarkers() , circles!);
      }
    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    contextView = context;
    return searchLocation(context);
  }

  animateCamera(LatLng latlng) {
    widget.userLatLng = latlng;
    _controller?.future.then((value) {
      value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(latlng.latitude, latlng.longitude),
        zoom: 15,
      )));
    });
  }

  handlePermission() {

    HelpingMethods()
        .getCurrentLocation(
      buildContext: context,
      permission: permission ?? LocationPermission.denied,
      serviceEnabled: serviceEnabled ?? false,
    )
        .then((position) {
      if (position != null) {
        if (widget.userLatLng == null) {
          latLng = LatLng(position.latitude, position.longitude);
        }
        animateCamera(LatLng(position.latitude, position.longitude));
      }
    }).catchError((error) {
      if (error == 'services disabled') {
        serviceDenied = true;
        return;
      }
      if (error == 'permanently denied') locationDenied = true;
    });
  }

  Future<bool> _onWillPop() async {
    if (latLng != null)
      Navigator.pop(context,
          HelpingMethods().getAddress(latLng!.latitude, latLng!.longitude));
    return Future<bool>.value(true);
  }

  Widget searchLocation(BuildContext context) {



    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              _controller = null;
              _adsObj = [];
              googleMapview = null;
              pcategoryId = null;
              pCategory = null;
              radius = null;
              keyword = null;
              rentType = null;
              listBool = [];
              _radiusMiles = [];
              _rentType = [];
              _categoryObj = [];
              markers = null;
              circles = null;
              Navigator.pushNamedAndRemoveUntil(context, Dashboard.route, (route) => false).then((value) {

              });
            },
            child: SizedBox(
              child: Image.asset("src/backimg@3x.png" ,scale: 2,),
            ),
          ),
          title: Text("Map Search" , style: TextStyle(fontFamily:  Const.aventa ,fontSize: 22.sp, color: Colors.black , fontWeight: FontWeight.w500),),
          elevation: 0,

        ),
        body:googleMapview,
      ),
    );
  }

  Widget addGoogleMap(BuildContext context ,Set<Marker> markers , Set<Circle> radiuscircles ){


    double screeSize = MediaQuery
        .of(context)
        .size
        .width;
    return  Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: widget.userLatLng!,
            zoom: 15,
          ),
          markers: markers,
          myLocationButtonEnabled: false,
          myLocationEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller?.complete(controller);
          },
          onCameraMove: (position) {
            widget.userLatLng =
                LatLng(position.target.latitude, position.target.longitude);

          },onCameraIdle: (){
        },
        ),
        Container(
          width: screeSize,
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.0)],
              stops: [0.5, 1],
              end: Alignment.bottomCenter,
              begin: Alignment.topCenter,
            ),
          ),
        ),
        searchTextFieldWidget(context),
        openRentalCategory(context),
      ],
    );
  }


  openRentalCategory(BuildContext context) {
    double height = 600.0;




    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SlidingUpPanelWidget(
        controlHeight: 110.0,
        anchor: 0.4,
        panelController: panelController!,
        elevation: 0.0,
        onTap: () {
          if(mounted) {
            setState(() {
              if (SlidingUpPanelStatus.expanded == panelController?.status) {
                panelController?.collapse();
                img = "ic_bottomsheet@2x.png";
              } else if (SlidingUpPanelStatus.collapsed ==
                  panelController?.status) {
                panelController?.anchor();
                img = "ic_bottomsheet@2x.png";
              } else {
                img = "ic_down_arrow@2x.png";
                panelController?.expand();
              }
            });
          }
          ///Customize the processing logic
          ///
        },
        enableOnTap: true, //Enable the onTap callback for control bar.
        dragDown: (details) {
        },
        dragStart: (details) {
        },
        dragCancel: () {
        },
        dragUpdate: (details) {

        },
        dragEnd: (details) {
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                  onTap: () => setState(() {
                    if (SlidingUpPanelStatus.expanded ==
                        panelController?.status) {
                      panelController?.collapse();
                      img = "ic_bottomsheet.png";
                    } else if (SlidingUpPanelStatus.collapsed ==
                        panelController?.status) {
                      panelController?.anchor();
                      img = "ic_bottomsheet@2x.png";
                    } else {
                      img = "ic_down_arrow@2x.png";
                      panelController?.expand();
                    }
                  }),
                  child: SizedBox(
                      height: 30.h,
                      width: 30.w,
                      child: Image.asset(Style.getIconImage(img)))),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${address?.address!.first!.country}",
                          style: Style.getBoldFont(20.sp),
                        ),
                        Text(
                          "${address?.address!.first!.administrativeArea}",
                          style: Style.getSemiBoldFont(12.sp,
                              color: Style.textBlackColor.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child:  rentalsWidget(context)),
            ],
          ),
        ),
      ),
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
      height: 94.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 600,
      maxWidthDiskCache: 600,
    );
  }

  Widget rentalsWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 7.5.w, right: 7.5.w, top: 7.5.w),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          for ( int? i = 0; i! < _adsObj.length; i++)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RentalRequestDetail(
                            "Home", _adsObj[i ?? 0], requestUpdate, null, null, null)))
                    .then((value) {
                  if (mounted) {
                    setState(() {
                      _adsObj = [];
                      _categoryObj = [];
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
                  width: 170.w,
                  height: 200.w,
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
                                    Colors.black.withAlpha(220)
                                  ],
                                ).createShader(const Rect.fromLTRB(250, 10, 10, 250));
                              },
                              blendMode: BlendMode.srcOver,
                              child: _adsObj[i].media!.isNotEmpty  ? circularImageView(image: returnImageValue(i)  ?? ""  ,size: 200.w) : Image.asset("src/placeholder.png")
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            _adsObj[i].name ?? "",
                            style: Style.getSemiBoldFont(14.sp),
                            maxLines: 1,
                          ),
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
                                    "${_adsObj[i].rating ?? 0}",
                                    style: Style.getSemiBoldFont(12.sp,
                                        color: Style.textBlackColor
                                            .withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
            )
        ],
      ),
    );
  }


}