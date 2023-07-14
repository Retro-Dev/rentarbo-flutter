import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../Controllers/PostAdReview.dart';
import '../Utils/helping_methods.dart';
import '../View/views.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../Extensions/style.dart';
import '../Models/Category.dart';
import '../Utils/AddressModel.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../component/SearchLocationPage.dart';

class PostAd extends StatefulWidget {
  const PostAd({Key? key}) : super(key: key);
  static const String route = "PostAd";

  @override
  _PostAdState createState() => _PostAdState();
}

class _PostAdState extends State<PostAd> {
  bool _demoRequested = false;

  bool getDemoRequested() {
    return _demoRequested;
  }

  setDemoRequested(bool selected) {
    _demoRequested = selected;
    if(mounted){
      setState(() {});
    }

  }


  late double _distanceToField;
  late TextfieldTagsController _controller;

  bool autoValidate = false, pobscure = true, cobscure = true, agree = false , obsure = false;

  String? pTitle,pCategory, pDescription, pfacilities, pCharges, pPickUpLocation,pDropOffLocation,
      pSSNNo,pDriverLisenceNumber,pIDCardNo,rentPerHour,rentValue;
  int? pcategoryId, pRentPerHour;

  double? pPickUpLocationlat, pPickUpLocationlng,pDropOffLocationlat , pDropOffLocationlong;



  List<File?>? _imagesProduct = [];
  List<File?>? _imagesVideoProduct = [];
  late List<CategoryObj>? _categoryObj = [];
  late List<int>? durations = [0,
    1,];
  GlobalKey productUpdateKey = GlobalKey();

  FocusNode productTitleFocus = FocusNode(),
      productCategoryFocus = FocusNode(),
      productDescriptionFocus = FocusNode(),
      productfacilitiesFocus = FocusNode(),
      productRentPerHourFocus = FocusNode(),
      productChargesFocus = FocusNode(),
      productPickUpLocationFocus = FocusNode(),
      productDropOffLocationFocus = FocusNode(),
      productSSNNoFocus = FocusNode(),
      productDriverLisenceNumberFocus = FocusNode(),
      productIDCardNoFocus = FocusNode();


  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: productTitleFocus),
        KeyboardActionsItem(focusNode: productDescriptionFocus),
        KeyboardActionsItem(focusNode: productChargesFocus),
        KeyboardActionsItem(focusNode: productSSNNoFocus),
        KeyboardActionsItem(focusNode: productDriverLisenceNumberFocus),
        KeyboardActionsItem(focusNode: productIDCardNoFocus),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // _controller.dispose();
    _imagesVideoProduct = [];
    _imagesProduct = [];
    isVideoI = [];
    super.dispose();
  }


  LatLng? currentPostion;
  bool? serviceEnabled;
  bool? serviceDenied;
  bool? locationDenied;
  LocationPermission? permission;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    if (mounted) {
      setState(() {
        // Your state change code goes here

        currentPostion = LatLng(position.latitude, position.longitude);

      });
    }
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
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handlePermission();
    _getUserLocation();
    _controller = TextfieldTagsController();
    _imagesProduct = [null];
    _imagesVideoProduct = [null];
    load();

  }

  load() async {
    showLoading();
    getCategory(onSuccess: ( List<CategoryObj> list) {
      hideLoading();
      _categoryObj?.addAll(list);
      if(mounted) {
        setState((){});
      }

    }, onError: (error) {
      toast(error);
      hideLoading();
    });
  }


  static const List<String> _pickLanguage = <String>[
    'Swim',
    'Life',
    'Suit',
  ];

  // locationFocus = FocusNode();

  GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: '_PostAds');


 final  productTitle = TextEditingController();
 final  productCategory = TextEditingController();
 final  productDescription  = TextEditingController();
 final  productfacilities = TextEditingController();
 final  productRentPerHour = TextEditingController();
 final  productCharges = TextEditingController();
 final  productPickUpLocation = TextEditingController();
 final  productDropOffLocation = TextEditingController();
 final  productSSNNo = TextEditingController();
 final  productDriverLisenceNumber = TextEditingController();
 final  productIDCardNo = TextEditingController();
 File? img;
 List<bool> isVideoI = [false];
  String? chosenValue,durationValue;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 16,
          title: Text(
            "Post an Ad",
            textAlign: TextAlign.start,
            style: Style.getBoldFont(18, color: Style.textBlackColor),
          ),
          actions: [
            SizedBox(
              width: 84,
              height: 32,
              child: IconButton(
                icon: Container(
                  width: 64,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Style.redColor,
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  child: Center(
                      child: Text(
                    "Post",
                    style: Style.getSemiBoldFont(14, color: Colors.white),
                  )),
                ),
                onPressed: () {
                  List<String>? tags = _controller.getTags;
                           if (pTitle == null) {
                             toast("Product title is required.");
                           }else if (pCategory == null) {
                             toast("Product category is required.");
                           }else if (pDescription == null) {
                             toast("Product description is required.");
                           }else if (_controller.getTags == null || _controller.getTags?.length  == 0  || _controller.getTags!.isEmpty) {
                             toast("Product facilites required.");
                           }else if (pCharges == null) {
                             toast("Product charges are required.");
                           }else if (pPickUpLocation == null) {
                             toast("Product Pickup location is required.");
                           }else if (pDropOffLocation == null) {
                             toast("Product drop-off location is required.");
                           }else if (pSSNNo == null) {
                             toast("Product SSN Number is required.");
                           }else if (pDriverLisenceNumber == null) {
                             toast("Diver License Number is required.");
                           }else if (pIDCardNo == null) {
                             toast("ID card number is required.");
                           }else if (pcategoryId == null) {
                             toast("Product category is required.");
                           }else if (rentPerHour == null) {
                             toast("Product duration is required.");
                           }else if (pPickUpLocationlat == null) {
                             toast("Product pick up latitude required.");
                           }else if (pPickUpLocationlng == null) {
                             toast("Product pick up longtitude required.");
                           }else if (pDropOffLocationlat == null) {
                             toast("Product drop off latitude required.");
                           }else if (pDropOffLocationlong == null) {
                             toast("Product drop off longtitude required.");
                           }else if (_imagesProduct!.length == 1) {
                             toast('Product Images required.');
                           }else if (_controller.getTags!.length > 11) {
                                toast('tags must be less then 10.') ;
                  } else {

                             _imagesProduct!.removeAt(0);
                             _imagesVideoProduct!.removeAt(0);
                             isVideoI.removeAt(0);
                             List<File?> files;
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(
                                     builder: (context) => PostAdReview(pTitle: this.pTitle,pCategory: this.pCategory,pCharges: this.pCharges,pDescription: this.pDescription ,pPickUpLocation: this.pPickUpLocation ,
                                       pDropOffLocation: this.pDropOffLocation ,pPickUpLocationlat: this.pPickUpLocationlat , pPickUpLocationlng: this.pPickUpLocationlng,pDropOffLocationlat: this.pDropOffLocationlat ,pDropOffLocationlong: this.pDropOffLocationlong,
                                       tags: tags!, pDriverLisenceNumber: pDriverLisenceNumber , pIDCardNo: pIDCardNo , pSSNNo: pSSNNo , pRentPerHour: rentPerHour,images: this._imagesProduct!,pcategoryId: this.pcategoryId,demoRequested: _demoRequested,productUpdate: productUpdateKey,isVideoI: isVideoI,videosImage: _imagesVideoProduct!, )
                                 )
                             ).then((value) {
                               _imagesProduct = [];
                               _imagesVideoProduct = [];
                               isVideoI = [];
                               Map<String , dynamic> imagesVideos = value as Map<String , dynamic>;
                               _imagesProduct = imagesVideos["images"];
                               _imagesVideoProduct = imagesVideos["videos"];
                               isVideoI = imagesVideos["isVideo"];
                               _imagesProduct!.insert(0, null);
                               _imagesVideoProduct!.insert(0, null);
                               isVideoI.insert(0, false);
                               setState((){});
                             });
                           }
                },
              ),
            ),
          ]),
      body: _AddBodyView(this.chosenValue,this.durationValue),
    );
  }

  Widget _AddBodyView(String? _chosenValue , String? _durationValue) {
    return SafeArea(
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
        child: KeyboardActions(
          config: _buildConfig(context),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 36.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Product Title",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.name,
                  hintText: "Product Title",
                  controller: productTitle,
                  validator: validateField,
                  currentFocus: productTitleFocus ,
                  onSaved: (text) {
                    pTitle = text;
                  },
                  onChange: (text) {
                    pTitle = text;
                  },
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Product Category",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                    Container(
                      height: 60.w,
                      width: MediaQuery.of(context).size.width - 10,
                      decoration: new BoxDecoration(
                          color: Color.fromRGBO(247, 247, 247, 1.0),
                          borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                      ),
                      padding: EdgeInsets.only(left: 20.w , right: 20.w , top: 6.w),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(height: 0,width: 0,) ,
                        value: chosenValue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: _categoryObj?.map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Text(value.name ?? ""),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: EdgeInsets.only(left: 6.w , right: 6.w , top: 6.w),
                          child: Text(
                            "${this.categoryValueFindOut(pcategoryId ?? 0) ?? "Select Category"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Aventa"),
                          ),
                        ),
                        onChanged: (String? value) {
                          if(mounted){
                            setState((){
                              pCategory = this.categoryValueFindOut( int.parse(value ?? "") ?? 0);
                              pcategoryId = int.parse(value ?? "");
                            });
                          }

                        },
                      ),
                    ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Product Description",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.newline,
                  textInputType: TextInputType.name,
                  hintText: "Product Description",
                  maxLines: 4,
                  controller: productDescription,
                  validator: validateField,
                  currentFocus: productDescriptionFocus,
                  nextFocus: productChargesFocus,
                  onSaved: (text) {
                    pDescription = text;
                  },
                  onChange: (text) {
                    pDescription = text;
                  },
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Facilities",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                    Autocomplete<String>(
                      optionsViewBuilder: (context, onSelected, options) {
                        return Container(
                          decoration: new BoxDecoration(
                            color: Color.fromRGBO(247, 247, 247, 1.0),
                            borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final dynamic option = options.elementAt(index);
                                return TextButton(
                                  onPressed: () {
                                    onSelected(option);
                                    if(mounted) {
                                      setState((){});
                                    }

                                  },
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Text(
                                        '#$option',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          color: Color.fromARGB(255, 74, 137, 92),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<String>.empty();
                        }
                        return _pickLanguage.where((String option) {
                          return option.contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selectedTag) {
                        _controller.addTag = selectedTag;
                        if(mounted){
                          setState((){});
                        }

                      },
                      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                        return TextFieldTags(
                          textEditingController: ttec,
                          focusNode: tfn,
                          textfieldTagsController: _controller,
                          initialTags: const [

                          ],
                          textSeparators: const [' ', ','],
                          letterCase: LetterCase.normal,
                          validator: (String tag) {
                            if (tag == '') {
                              return 'Required facilities';
                            } else if (_controller.getTags?.contains(tag) ?? false ) {
                              return 'you already entered that';
                            } else if ((_controller.getTags?.length ?? 0) > 11 ) {
                              return 'tags must be less then 10.';
                            } else if (tag.length > 16) {
                              return 'tags charactor must be less then 15';
                            }
                            return null;
                          },
                          inputfieldBuilder:
                              (context, tec, fn, error, onChanged, onSubmitted) {
                            return ((context, sc, tags, onTagDelete) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                  controller: tec,
                                  focusNode: fn,
                                  decoration: InputDecoration(
                                    helperText: 'Add facilities...',
                                    helperStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    hintText: _controller.hasTags ? '' : "Facilities",
                                    errorText: error,
                                    prefixIconConstraints: BoxConstraints(
                                        maxWidth: _distanceToField * 0.57),
                                    prefixIcon: tags.isNotEmpty
                                        ? SingleChildScrollView(
                                      controller: sc,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: tags.map((String tag) {
                                            return Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0),
                                                ),
                                                color:
                                                const Color(0xFF363E51),
                                              ),
                                              margin:
                                              const EdgeInsets.only(right: 10.0),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 10.0, vertical: 4.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      '#$tag',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                    },
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  InkWell(
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      size: 14.0,
                                                      color: Color.fromARGB(
                                                          255, 233, 233, 233),
                                                    ),
                                                    onTap: () {
                                                      onTagDelete(tag);
                                                    },
                                                  )
                                                ],
                                              ),
                                            );
                                          }).toList()),
                                    )
                                        : null,
                                  ),
                                  onChanged: onChanged,
                                  onSubmitted: onSubmitted,
                                ),
                              );
                            });
                          },
                        );
                      },
                    ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Duration",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                    Container(
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(247, 247, 247, 1.0),
                        borderRadius: new BorderRadius.all(Radius.circular(14.0)),
                      ),
                     width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 20.w , right: 20.w , top: 6.w),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(height: 0,width: 0,),
                        value: _durationValue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: durations?.map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value:productTypeValue(value ?? 0),
                            child: Text("${productTypeValue(value ?? 0)}"),
                          );
                        }).toList(),
                        hint: Padding(
                          padding:EdgeInsets.only(left: 6.w , right: 6.w),
                          child: Text(
                            "${productType(rentValue ?? "") ?? "Select Rent type"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Aventa"),
                          ),
                        ),
                        onChanged: (String? value) {
                          if(mounted){
                            setState((){
                              rentPerHour = productType(value);
                              rentValue = value;
                            });
                          }

                        },
                      ),
                    ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Charges",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.number,
                  hintText: "Charges",
                  controller: productCharges,
                  validator:validateField,
                  currentFocus: productChargesFocus,
                  // nextFocus: productSSNNoFocus,
                    prefixiconData: Icons.attach_money,
                  onSaved: (text) {
                    pCharges = text;

                  },
                  onChange: (text) {
                    pCharges = text;
                  },
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Pick-up Location",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SearchLocationPage.route , arguments: {"userLatLng" : currentPostion}).then((value){
                      if(value!=null){
                        AddressModel address = value as AddressModel;
                        pPickUpLocation = address.fullAddress;
                        pPickUpLocationlat = address.latLng?.latitude;
                        pPickUpLocationlng = address.latLng?.longitude;
                        productPickUpLocation.text = address.fullAddress ?? "";
                        if(mounted){
                          setState((){});
                        }

                      }
                    });
                  },
                  child: EditText(
                    context: context,
                    setEnable: false,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                    hintText: "Pick-up Location",
                    controller: productPickUpLocation,
                    validator: validateField,
                    currentFocus: productPickUpLocationFocus,
                    nextFocus: productDropOffLocationFocus,
                    onSaved: (text) {
                     pPickUpLocation = text;
                    },
                    onChange: (text) {
                     pPickUpLocation = text;
                    },
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Drop-off Location",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, SearchLocationPage.route , arguments: {"userLatLng" : currentPostion}).then((value){
                      if(value!=null){
                        AddressModel address = value as AddressModel;
                        pDropOffLocation = address.fullAddress;
                        pDropOffLocationlat = address.latLng?.latitude;
                        pDropOffLocationlong = address.latLng?.longitude;
                        productDropOffLocation.text = address.fullAddress ?? "";
                        if(mounted){
                          setState((){});
                        }

                      }
                    });
                  },
                  child: EditText(
                    setEnable: false,
                    context: context,
                    textInputAction: TextInputAction.next,
                    textInputType: TextInputType.name,
                    hintText: "Drop-off Location",
                    controller: productDropOffLocation,
                    validator: validateField,
                    currentFocus: productDropOffLocationFocus,
                    nextFocus: productSSNNoFocus,
                    onSaved: (text) {
                      pDropOffLocation = text;
                    },
                    onChange: (text) {
                      pDropOffLocation = text;
                    },

                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "SSN No",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  hintText: "SSN No",
                  controller: productSSNNo,
                  validator: validateField,
                  currentFocus: productSSNNoFocus,
                  nextFocus: productDriverLisenceNumberFocus,
                  onSaved: (text) {
                    pSSNNo = text;
                  },
                  onChange: (text) {
                    pSSNNo = text;
                  },
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Driver License Number",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  hintText: "Driver License Number",
                  controller: productDriverLisenceNumber,
                  validator: validateField,
                  currentFocus: productDriverLisenceNumberFocus,
                  nextFocus: productIDCardNoFocus,
                  onSaved: (text) {
                    pDriverLisenceNumber = text;
                  },
                  onChange: (text) {
                    pDriverLisenceNumber = text;
                  },

                ),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "ID Card No",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                EditText(
                  context: context,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  hintText: "ID Card No",
                  controller: productIDCardNo,
                  validator: validateField,
                  currentFocus: productIDCardNoFocus,
                  // nextFocus: productTitleFocus,
                  onSaved: (text) {
                    pIDCardNo = text;
                  },
                  onChange: (text) {
                    pIDCardNo = text;
                  },

                ),
                // TextFormField(
                // keyboardType: TextInputType.name,
                // textInputAction: TextInputAction.next,
                // autocorrect: false,
                // style: Style.getRegularFont(14.sp, color: Style.textBlackColor),
                // decoration: InputDecoration(
                // filled: true,
                // fillColor: const Color(0xFFF7F7F7),
                // hintText: "ID Card No",
                // contentPadding: const EdgeInsets.all(10),
                // //   focusedBorder: InputBorder.none,
                // //  enabledBorder: InputBorder.none,
                // border: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(15.w),
                // borderSide: const BorderSide(
                // width: 0,
                // style: BorderStyle.none,
                // ),
                // ),
                // )),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "Upload Media",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6.w),
                    child: Text(
                      "You can upload picture and video of product",
                      textAlign: TextAlign.start,
                      style: Style.getSemiBoldFont(12.sp,
                          color: Style.textBlackColorOpacity80),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                    Container(
                      height: 70.h,
                      width: MediaQuery.of(context).size.width,
                      child:ListView.separated(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: _imagesProduct?.length ?? 0,
                          itemBuilder: (context, index) =>

                          showImages(index),

                        separatorBuilder: (context, index) => SizedBox(
                          width: 8.w,
                      ),
            ),
          ),

                SizedBox(height: 24.h),
                Row(children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setDemoRequested(!getDemoRequested());
                    },
                    child: SizedBox(
                        width: 23.w,
                        height: 23.w,
                        child: Image.asset(Style.getIconImage(getDemoRequested()
                            ? "checkbox_checked_icon@2x.png"
                            : "checkbox_unchecked_icon@2x.png"))),
                  ),
                  SizedBox(width: 8.w),
                  Text("Hosting & Demonstration Required",
                      style: Style.getSemiBoldFont(14.sp,
                          color: Style.textBlackColor)),
                ]),
                SizedBox(
                  height: 24.h,
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }




  Widget showImages(int index) {
     img = null;
    if (index == 0) {
      return  Container(
        child: GestureDetector(
          onTap: () {
            showImageSelectOption(context,true, (image , isVideo , imagethump) async {
                if (isVideo) {
                  isVideoI.add(isVideo ?? false);
                  _imagesVideoProduct?.add(image);
                  _imagesProduct?.add(imagethump);

                } else {
                  _imagesProduct?.add(image);
                  _imagesVideoProduct?.add(image);
                  isVideoI.add(isVideo ?? false);
                }

                if (mounted) {
                  setState(() {

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
                  offset: Offset(0,10),
                  blurRadius: 10
                )
              ]
            ),

            height: 68.h,
            width: 82.w,
            child:  Image.asset("src/icPhotoCamera24Px@3x.png" , scale: 2,),
          ),
        ),

      );
    }else {
      return  Container(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [

            ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
          child:   Image.file(
            _imagesProduct?[index] ?? File(""),
            fit: BoxFit.cover,
            height: 68.h,
            width: 82.w,
          )
        ),
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
                        _imagesProduct?.removeAt(index);
                        isVideoI.removeAt(index);
                        _imagesVideoProduct?.removeAt(index);
                      });
                    }
                  },
                  child: Image.asset("src/closebtn@3x.png"),
                ),
              ),
            ),
            if(isVideoI[index])
            Positioned(
              right: 16.25.w,
              top: 16.h,
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: GestureDetector(
                  onTap: () async {

                  },
                  child: Image.asset("src/playicon.png" , color: Colors.white,),
                ),
              ),
            ),

    ],
    ),
      );

    }
  }


  String? categoryValueFindOut(int index) {
    for (var catValue in  _categoryObj ?? [] ) {
      if (index == catValue.id)
        return catValue.name;

    }
  }

  String? productTypeValue(int index) {
      if (index == 0)
        return "Rent as Hours";
      else if(index == 1)
        return "Rent as Days";
      
  }



  String? productType(String? value) {
    if (value == "Rent as Days" ){
      return "Rent as Days";
    }else {
      return "Rent as Hour";
    }
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
    if(mounted) {
      setState(() {
        autoValidate = true;
      });
    }


      return false;
    }
  }
}
