import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/Ads.dart';
import '../Utils/Ads_services.dart';
import '../Utils/BaseModel.dart';
import '../Utils/Const.dart';
import '../Utils/helping_methods.dart';
import '../View/views.dart';
import 'package:textfield_tags/textfield_tags.dart';
import '../Extensions/style.dart';
import '../Models/Category.dart';
import '../Utils/AddressModel.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../component/SearchLocationPage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../component/custom_button.dart';
import '../component/custom_outline_button.dart';

class EditPostAd extends StatefulWidget {
  // const EditPostAd({Key? key}) : super(key: key);
  static const String route = "EditPostAd";
  AdsObj? adsObjmain;

  EditPostAd(this.adsObjmain);

  @override
  _EditPostAdState createState() => _EditPostAdState();
}

class _EditPostAdState extends State<EditPostAd> {
  bool _demoRequested = false;

  bool getDemoRequested() {
    setState((){
      isEdited = true;
    });
    return _demoRequested;
  }

  setDemoRequested(bool selected) {
    _demoRequested = selected;
    demoRequested = selected;
    if (mounted) {
      setState(() {});
    }
  }

  AdsObj? adsObj;
  late double _distanceToField;
  TextfieldTagsController? _controller;

  bool autoValidate = false,
      pobscure = true,
      cobscure = true,
      agree = false,
      obsure = false;

  String? pTitle,
      pCategory,
      pDescription,
      pfacilities,
      pCharges,
      pPickUpLocation,
      pDropOffLocation,
      pSSNNo,
      pDriverLisenceNumber,
      pIDCardNo,
      rentPerHour,
      rentValue;
  int? pcategoryId, pRentPerHour;

  double? pPickUpLocationlat,
      pPickUpLocationlng,
      pDropOffLocationlat,
      pDropOffLocationlong;

  bool? demoRequested;

  List<File?>? _imagesProduct = [];
  List<File?>? _imagesVideoProduct = [];
  late List<CategoryObj>? _categoryObj = [];
  late List<int>? durations = [
    0,
    1,
  ];
  Widget? updatedCheckbox;
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
    // _controller?.dispose();
    _imagesVideoProduct = [];
    _imagesProduct = [];
    isVideoI = [];
    productTitle.dispose();
    productCategory.dispose();
    productDescription.dispose();
    productfacilities.dispose();
    productRentPerHour.dispose();
    productCharges.dispose();
    productPickUpLocation.dispose();
    productDropOffLocation.dispose();
    productSSNNo.dispose();
    productDriverLisenceNumber.dispose();
    productIDCardNo.dispose();
    widget.adsObjmain?.media?.removeAt(0);

    super.dispose();
  }

  bool? isImagesCompleted;



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

    adsObj = widget.adsObjmain;

    _imagesProduct = [null];
    _imagesVideoProduct = [null];
    load();
    loadAdjs();

    // loadDownloadedImages();
  }

  load() async {
    showLoading();
    getCategory(onSuccess: (List<CategoryObj> list) {
      hideLoading();
      _categoryObj?.addAll(list);
      if (mounted) {
        setState(() {});
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

  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_PostAds');

  final productTitle = TextEditingController();
  final productCategory = TextEditingController();
  final productDescription = TextEditingController();
  final productfacilities = TextEditingController();
  final productRentPerHour = TextEditingController();
  final productCharges = TextEditingController();
  final productPickUpLocation = TextEditingController();
  final productDropOffLocation = TextEditingController();
  final productSSNNo = TextEditingController();
  final productDriverLisenceNumber = TextEditingController();
  final productIDCardNo = TextEditingController();
  File? img;
  List<bool> isVideoI = [false];
  String? chosenValue, durationValue;
  bool isEdited = false;

  loadAdjs() {
    productTitle.text = adsObj?.name ?? "";
    productCategory.text = adsObj?.category?.name ?? "";
    productDescription.text = adsObj?.description ?? "";
    pCategory = adsObj?.category?.name ?? "";
    pcategoryId = adsObj?.categoryId ?? 0;
    productRentPerHour.text = adsObj?.rentType ?? "";
    productCharges.text = adsObj?.rentCharges ?? "";
    productPickUpLocation.text = adsObj?.pickUpLocationAddress ?? "";
    productDropOffLocation.text = adsObj?.dropLocationAddress ?? "";
    productSSNNo.text = adsObj?.ssn ?? "";
    productDriverLisenceNumber.text = adsObj?.drivingLicense ?? "";
    productIDCardNo.text = adsObj?.idCard ?? "";
    pTitle = adsObj?.name;
    pCategory = adsObj?.category?.name;
    pDescription = adsObj?.description;
    pCharges = adsObj?.rentCharges;
    pPickUpLocation = adsObj?.pickUpLocationAddress;
    pDropOffLocation = adsObj?.dropLocationAddress;
    pSSNNo = adsObj?.ssn;
    pDriverLisenceNumber = adsObj?.drivingLicense;
    pIDCardNo = adsObj?.idCard;
    pcategoryId = adsObj?.categoryId;
    rentPerHour = adsObj?.rentType;
    pPickUpLocationlat = double.parse(adsObj!.pickupLat!);
    pPickUpLocationlng = double.parse(adsObj!.pickupLng!);
    pDropOffLocationlat = double.parse(adsObj!.dropLat!);
    pDropOffLocationlong = double.parse(adsObj!.dropLng!);
    if (adsObj!.hostingDemos == "1") {
      demoRequested = true;
    } else {
      demoRequested = false;
    }

    _demoRequested = demoRequested!;

    setState(() {
      updatedCheckbox = updateCheckBox();
      isEdited = false;
    });

    adsObj!.media!.insert(
        0,
        Media(
            id: 0,
            thumbnailUrl: "",
            module: "",
            moduleId: 0,
            filename: "",
            originalName: "",
            mimeType: ""));


  }

  loadDownloadedImages() {
    _imagesProduct = [null];
    _imagesVideoProduct = [null];

    int sizeofArr = int.parse(adsObj!.media!.length!.toString());

    adsObj!.media!.forEach((element) {
      if (element?.fileType == "video") {
        isImagesCompleted = true;
      }
    });

    for (var urlstrings in adsObj!.media!) {
      Future<File> imgthump =
          urlToFile(urlstrings?.fileUrl, urlstrings?.fileType == "video")
              as Future<File>;
      imgthump.then((value) {
        if (urlstrings?.fileType == "video") {

          setState(() {
            var imgthumpVideo = urlstrings?.fileType == "video"
                ? videoToFile(value!)
                : value! as Future<File>;
            _imagesVideoProduct!.add(value);
            imgthumpVideo.then((videovalue) {
              String? fileVideo;
              File? fileImage;

              urlstrings?.fileType == "video"
                  ? fileVideo = videovalue as String
                  : fileImage = videovalue as File;

              File imagefile = urlstrings?.fileType == "video"
                  ? File(fileVideo!)
                  : fileImage!;
              _imagesProduct!.add(imagefile);
              _imagesVideoProduct!.add(imagefile);
              isVideoI.add(urlstrings?.fileType == "video");
              double timerDownload = double.parse(value.size.toString());

              Future.delayed(Duration(seconds: timerDownload.round()), () {
                // 5s over, navigate to a new page
                hideLoading();
                setState(() {
                  isImagesCompleted = false;
                });
              });

              if (mounted) {
                setState(() {});
              }
            });

          });
        } else {
          setState(() {
            _imagesProduct!.add(value);
            _imagesVideoProduct!.add(value);
            isVideoI.add(false);
            double timerDownload = double.parse(value.size.toString());
            Future.delayed(Duration(seconds: timerDownload.round()), () {
              // 5s over, navigate to a new page
              hideLoading();
              setState(() {
                isImagesCompleted = false;
              });
            });
          });
        }
      });
    }
  }

  Future<String> videoToFile(File filePath) async {
    String? imgthumpVideo = await VideoThumbnail.thumbnailFile(
        video: filePath.path,
        imageFormat: ImageFormat.JPEG,
        timeMs: 1,
        quality: 50);

    return imgthumpVideo!;
  }

  Future<File> urlToFile(dynamic imageUrl, bool isVideo) async {
// generate random number.

    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File? file;
    if (isVideo) {
      file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.mp4');
    } else {
      file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    }

// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 16,
          leading: IconButton(
            icon: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset(
                  "src/backimg@3x.png",
                  fit: BoxFit.cover,
                )),
            onPressed: () {
              Navigator.pop(context, "back");
            },
          ),
          title: Text(
            "Edit an Ad",
            textAlign: TextAlign.start,
            style: Style.getBoldFont(18, color: Style.textBlackColor),
          ),
          actions: [
            if (isEdited == true)
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
                      "Save",
                      style: Style.getSemiBoldFont(14, color: Colors.white),
                    )),
                  ),
                  onPressed: () {
                    List<String>? tags = _controller?.getTags;
                    // if (_validateInputs()) {
                    if (pTitle == null) {
                      toast("Product title is required.");
                    } else if (pCategory == null) {
                      toast("Product category is required.");
                    } else if (pDescription == null) {
                      toast("Product description is required.");
                    } else if (_controller?.getTags == null ||
                        _controller?.getTags?.length == 0 ||
                        _controller!.getTags!.isEmpty) {
                      toast("Product facilites required.");
                    } else if (pCharges == null) {
                      toast("Product charges are required.");
                    } else if (pPickUpLocation == null) {
                      toast("Product Pickup location is required.");
                    } else if (pDropOffLocation == null) {
                      toast("Product drop-off location is required.");
                    } else if (pSSNNo == null) {
                      toast("Product SSN Number is required.");
                    } else if (pDriverLisenceNumber == null) {
                      toast("Diver License Number is required.");
                    } else if (pIDCardNo == null) {
                      toast("ID card number is required.");
                    } else if (pcategoryId == null) {
                      toast("Product category is required.");
                    } else if (rentPerHour == null) {
                      toast("Product duration is required.");
                    } else if (pPickUpLocationlat == null) {
                      toast("Product pick up latitude required.");
                    } else if (pPickUpLocationlng == null) {
                      toast("Product pick up longtitude required.");
                    } else if (pDropOffLocationlat == null) {
                      toast("Product drop off latitude required.");
                    } else if (pDropOffLocationlong == null) {
                      toast("Product drop off longtitude required.");
                    }  else {
                      _imagesProduct!.removeAt(0);
                      _imagesVideoProduct!.removeAt(0);
                      isVideoI.removeAt(0);
                      List<File?> files;

                      Map<String, String>? jsonnew = {"": ""};
                      var count = 0;
                      jsonnew.remove("");
                      for (var values in tags!) {
                        jsonnew!["tags[$count]"] = tags![count];
                        count = count + 1;
                      }

                      List<Map<String, dynamic>>? imageFiles = [];
                      var jsonParam = {
                        "category_id": "${pcategoryId}",
                        "name": "${pTitle}",
                        "description": "${pDescription}",
                        "rent_type": "${rentPerHour}",
                        "rent_charges": "${pCharges}",
                        "pick_up_location_address": "${pPickUpLocation}",
                        "pickup_lat": "${pPickUpLocationlat}",
                        "pickup_lng": "${pPickUpLocationlng}",
                        "drop_location_address": "${pDropOffLocation}",
                        "drop_lat": "${pDropOffLocationlat}",
                        "drop_lng": "${pDropOffLocationlong}",
                        "ssn": "${pSSNNo}",
                        "id_card": "${pIDCardNo}",
                        "driving_license": "${pDriverLisenceNumber}",
                        "_method": "PUT",
                        "hosting_demos": "${booltoIntHome(demoRequested)}"
                      };

                      jsonParam.addEntries(jsonnew!.entries);

                      showLoading();
                      editAds(
                          jsonData: jsonParam,
                          slug: adsObj!.slug!,
                          files: imageFiles!,
                          onSuccess: (data) {
                            hideLoading();
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    ThankYoupopUp(data)
                                //thankYouDialog(navigationViewModel,context)
                                );
                          },
                          onError: (error) {
                            toast(error);
                            imageFiles = [];
                            hideLoading();
                          });
                    }

                    // }
                  },
                ),
              ),
            if (isEdited == false)
              SizedBox(
                width: 84,
                height: 32,
                child: IconButton(
                    icon: Container(
                      width: 64,
                      height: 32,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Center(
                          child: Text(
                        "Save",
                        style: Style.getSemiBoldFont(14, color: Colors.white),
                      )),
                    ),
                    onPressed: () {}),
              ),
          ]),
      body: _AddBodyView(this.chosenValue, this.durationValue),
    );
  }

  String? productType(String? value) {
    if (value == "Rent as Days") {
      return "day";
    } else {
      return "hr";
    }
  }

  String? productTypeM(String? value) {
    if (value == "hr") {
      return "Rent as Hours";
    } else {
      return "Rent as Days";
    }
  }

  int? booltoIntHome(bool? value) {
    if (value == true) {
      return 1;
    } else {
      return 0;
    }
  }

  Widget removeImage(int index) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Media Upload",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Are you sure to remove media on this post?",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),

              Row(
                children: [

                  Expanded(
                    child: CustomButton(
                      btnText: "Yes",
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
                        showLoading();

                        var jsonParam = {
                          "media_id": "${adsObj!.media![index]?.id}",
                          "module": "${adsObj!.media![index]?.module}",
                          "module_id": "${adsObj!.media![index]?.moduleId}"
                        };

                        removeMedia(
                            jsonData: jsonParam,
                            onSuccess: (data) {
                              hideLoading();

                              if (data.data.toString() == "[]") {
                                setState(() {
                                  adsObj?.media = [];
                                  adsObj!.media!.insert(
                                      0,
                                      Media(
                                          id: 0,
                                          thumbnailUrl: "",
                                          module: "",
                                          moduleId: 0,
                                          filename: "",
                                          originalName: "",
                                          mimeType: ""));
                                });
                              } else {
                                BaseModel datamain = data;
                                List<Media> media = [];
                                List<dynamic>? response = datamain.data;
                                for (Map<String, dynamic> values in response!) {
                                  media.add(Media.fromJson(values));
                                }

                                setState(() {
                                  adsObj?.media = media;
                                  adsObj?.media?.insert(
                                      0,
                                      Media(
                                          id: 0,
                                          thumbnailUrl: "",
                                          module: "",
                                          moduleId: 0,
                                          filename: "",
                                          originalName: "",
                                          mimeType: ""));
                                });
                              }
                              Navigator.of(context).pop();
                            },
                            onError: (error) {
                              toast(error);
                              hideLoading();
                            });
                      },
                    ),
                  ),
                  SizedBox(width: 15.w,),
                  Expanded(
                    child: CustomOutlineButton(
                      btnText: "No",
                      radius: 25.w,
                      height: 50.w,
                      width: MediaQuery.of(context).size.width,
                      fontSize: 12.sp,
                      fontstyle: TextStyle(
                        color: Style.redColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: Const.aventa,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.sp,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget AddImage(File image) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Media Upload",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "Are you sure to upload media on this post?",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Row(
                children: [
                  
                  Expanded(
                    child: CustomButton(
                      btnText: "Yes",
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
                        List<File?>? videosImage = [];
                        videosImage.add(image);
                        List<Map<String, dynamic>>? imageFiles = [];
                        var jsonParam = {
                          "module": "products",
                          "module_id": "${adsObj!.id}"
                        };
                        var icount = 0;
                        for (var values in videosImage!) {
                          imageFiles!
                              .add({"name": "image_url[$icount]", "path": values!.path});
                          icount = icount + 1;
                        }

                        showLoading();
                        uploadMedia(
                            jsonData: jsonParam,
                            files: imageFiles,
                            onSuccess: (data) {
                              hideLoading();
                              if (data.data.toString() == "[]") {
                                setState(() {
                                  adsObj?.media = [];
                                  adsObj!.media!.insert(
                                      0,
                                      Media(
                                          id: 0,
                                          thumbnailUrl: "",
                                          module: "",
                                          moduleId: 0,
                                          filename: "",
                                          originalName: "",
                                          mimeType: ""));
                                });
                              } else {
                                BaseModel datamain = data;
                                List<Media> media = [];
                                List<dynamic>? response = datamain.data;

                                for (Map<String, dynamic> values in response!) {
                                  media.add(Media.fromJson(values));
                                }
                                setState(() {
                                  adsObj?.media = media;
                                  adsObj?.media?.insert(
                                      0,
                                      Media(
                                          id: 0,
                                          thumbnailUrl: "",
                                          module: "",
                                          moduleId: 0,
                                          filename: "",
                                          originalName: "",
                                          mimeType: ""));
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            onError: (error) {
                              toast(error);
                              hideLoading();
                            });
                      },
                    ),
                  ),
                  SizedBox(width: 15.w,),
                  Expanded(
                    child: CustomOutlineButton(
                      btnText: "No",
                      radius: 25.w,
                      height: 50.w,
                      width: MediaQuery.of(context).size.width,
                      fontSize: 12.sp,
                      fontstyle: TextStyle(
                        color: Style.redColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: Const.aventa,
                        fontStyle: FontStyle.normal,
                        fontSize: 18.sp,
                      ),
                      onPressed: () {
                         Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget ThankYoupopUp(BaseModel data) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 230,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Thank You!",
                style: Style.getBoldFont(
                  22.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              Text(
                "For Editing the Ad. Once approved from Admin you will be notified",
                textAlign: TextAlign.center,
                style: Style.getMediumFont(
                  12.sp,
                ),
              ),
              SizedBox(
                height: 22.h,
              ),
              CustomButton(
                btnText: "Goto Ads",
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
                  showLoading();
                  Future.delayed(Duration(seconds: 1), () {
                    // 5s over, navigate to a new page
                    updateAds(data);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  updateAds(BaseModel data) {
    hideLoading();
    Navigator.pop(context, data);
  }

  Widget _AddBodyView(String? _chosenValue, String? _durationValue) {
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      currentFocus: productTitleFocus,
                      // nextFocus: productDescriptionFocus,
                      onSaved: (text) {
                        pTitle = text;
                      },
                      onChange: (text) {
                        pTitle = text;
                        setState((){
                          isEdited = true;
                        });

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
                        borderRadius:
                            new BorderRadius.all(Radius.circular(14.0)),
                      ),
                      padding:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 6.w),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(
                          height: 0,
                          width: 0,
                        ),
                        value: chosenValue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: _categoryObj!
                            .map<DropdownMenuItem<String>>((value) {
                          return DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Text(value.name ?? ""),
                          );
                        }).toList(),
                        hint: Padding(
                          padding:
                              EdgeInsets.only(left: 6.w, right: 6.w, top: 6.w),
                          child: Text(
                            "${this.categoryValueFindOut(pcategoryId ?? 0) ?? "Select Category"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Aventa"),
                          ),
                        ),
                        onChanged: (String? value) {
                          if (mounted) {
                            setState(() {
                              pCategory = this.categoryValueFindOut(
                                  int.parse(value ?? "") ?? 0);
                              pcategoryId = int.parse(value ?? "");
                            });

                            setState((){
                              isEdited = true;
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
                        setState((){
                          isEdited = true;
                        });
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
                            borderRadius:
                                new BorderRadius.all(Radius.circular(14.0)),
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
                                    if (mounted) {
                                      setState(() {});
                                      setState((){
                                        isEdited = true;
                                      });
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
                                          color:
                                              Color.fromARGB(255, 74, 137, 92),
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
                          return option
                              .contains(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (String selectedTag) {
                        _controller?.addTag = selectedTag;
                        if (mounted) {
                          setState(() {});
                          setState((){
                            isEdited = true;
                          });
                        }
                      },
                      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                        return TextFieldTags(
                          textEditingController: ttec,
                          focusNode: tfn,
                          textfieldTagsController: _controller,
                          initialTags: widget.adsObjmain!.tags!,
                          textSeparators: const [' ', ','],
                          letterCase: LetterCase.normal,
                          validator: (String tag) {
                            if (tag == '') {
                              return 'Required facilities';
                            } else if (_controller!.getTags!.contains(tag)) {
                              return 'you already entered that';
                            }
                            return null;
                          },
                          inputfieldBuilder: (context, tec, fn, error,
                              onChanged, onSubmitted) {
                            return ((context, sc, tags, onTagDelete) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextField(
                                  controller: tec,
                                  focusNode: fn,
                                  decoration: InputDecoration(
                                    helperText: 'Add facilities...',
                                    helperStyle: const TextStyle(
                                      color: Colors.black,
                                    ),
                                    hintText: _controller!.hasTags
                                        ? ''
                                        : "Facilities",
                                    errorText: error,
                                    prefixIconConstraints: BoxConstraints(
                                        maxWidth: _distanceToField * 0.57),
                                    prefixIcon: tags.isNotEmpty
                                        ? SingleChildScrollView(
                                            controller: sc,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children:
                                                    tags.map((String tag) {
                                                  return Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20.0),
                                                      ),
                                                      color: const Color(
                                                          0xFF363E51),
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          child: Text(
                                                            '#$tag',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          onTap: () {

                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        InkWell(
                                                          child: const Icon(
                                                            Icons.cancel,
                                                            size: 14.0,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    233,
                                                                    233,
                                                                    233),
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
                        borderRadius:
                            new BorderRadius.all(Radius.circular(14.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 6.w),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: SizedBox(
                          height: 0,
                          width: 0,
                        ),
                        value: _durationValue,
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        //elevation: 5,
                        style: TextStyle(color: Colors.black),

                        items: durations!
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: productTypeValue(value ?? 0),
                            child: Text("${productTypeValue(value ?? 0)}"),
                          );
                        }).toList(),
                        hint: Padding(
                          padding: EdgeInsets.only(left: 6.w, right: 6.w),
                          child: Text(
                            "${productTypeM(rentPerHour) ?? "Select Rent type"}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: "Aventa"),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState((){
                            isEdited = true;
                          });
                          if (mounted) {
                            setState(() {
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
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.number,
                      hintText: "Charges",
                      controller: productCharges,
                      validator: validateField,
                      currentFocus: productChargesFocus,
                      prefixiconData: Icons.attach_money,
                      onSaved: (text) {
                        pCharges = text;
                      },
                      onChange: (text) {
                        pCharges = text;
                        setState((){
                          isEdited = true;
                        });
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
                        Navigator.pushNamed(context, SearchLocationPage.route , arguments: {"userLatLng" : currentPostion} )
                            .then((value) {
                          if (value != null) {
                            AddressModel address = value as AddressModel;
                            pPickUpLocation = address.fullAddress;
                            pPickUpLocationlat = address.latLng?.latitude;
                            pPickUpLocationlng = address.latLng?.longitude;
                            productPickUpLocation.text =
                                address.fullAddress ?? "";
                            if (mounted) {
                              setState(() {});
                              setState((){
                                isEdited = true;
                              });
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
                          setState((){
                            isEdited = true;
                          });
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
                        Navigator.pushNamed(context, SearchLocationPage.route , arguments:  {"userLatLng" : currentPostion})
                            .then((value) {
                          if (value != null) {
                            AddressModel address = value as AddressModel;
                            pDropOffLocation = address.fullAddress;
                            pDropOffLocationlat = address.latLng?.latitude;
                            pDropOffLocationlong = address.latLng?.longitude;
                            productDropOffLocation.text =
                                address.fullAddress ?? "";
                            if (mounted) {
                              setState(() {});
                              setState((){
                                isEdited = true;
                              });
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
                          setState((){
                            isEdited = true;
                          });
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
                        setState((){
                          isEdited = true;
                        });
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
                        setState((){
                          isEdited = true;
                        });
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
                      textInputAction: TextInputAction.done,
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
                        setState((){
                          isEdited = true;
                        });
                      },
                    ),
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
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: adsObj?.media?.length ?? 0,
                        itemBuilder: (context, index) => showImages(index),
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
                          setState(() {
                            updatedCheckbox = updateCheckBox();
                          });
                        },
                        child: updatedCheckbox!,
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

  Widget updateCheckBox() {
    return SizedBox(
        width: 23.w,
        height: 23.w,
        child: Image.asset(Style.getIconImage(getDemoRequested()
            ? "checkbox_checked_icon@2x.png"
            : "checkbox_unchecked_icon@2x.png")));
  }

  Widget showImages(int index) {
    if (index == 0) {
      return Container(
        child: GestureDetector(
          onTap: () {
            showImageSelectOption(context, true,
                (image, isVideo, imagethump) async {

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          AddImage(image)
                  );
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
                      offset: Offset(0, 10),
                      blurRadius: 10)
                ]),
            height: 68.h,
            width: 82.w,
            child: Image.asset(
              "src/icPhotoCamera24Px@3x.png",
              scale: 2,
            ),
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      offset: Offset(0, 10),
                      blurRadius: 10)
                ]),
            height: 68.h,
            width: 82.w,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(4.0)),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withAlpha(200)],
                  ).createShader(Rect.fromLTRB(300, 10, 10, 350));
                },
                blendMode: BlendMode.srcOver,
                child: FadeInImage(
                    width: 200.w,
                    height: 94.w,
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeInExpo,
                    fadeOutCurve: Curves.easeOutExpo,
                    placeholder: AssetImage("src/placeholder.png"),
                    image: adsObj!.media!.isNotEmpty!
                        ? this.returnImageValue(index)
                        : Image.asset("src/placeholder.png").image,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                          child: Image.asset("src/placeholder.png"));
                    },
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            right: 4.25.w,
            top: 8.h,
            child: SizedBox(
              width: 16.w,
              height: 16.w,
              child: GestureDetector(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          removeImage(index)
                  );
                },
                child: Image.asset("src/closebtn@3x.png"),
              ),
            ),
          ),
          if (adsObj!.media![index]!.fileType == "video")
            Positioned(
              right: 16.25.w,
              top: 16.h,
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: GestureDetector(
                  onTap: () async {},
                  child: Image.asset(
                    "src/playicon.png",
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    }
  }

  NetworkImage returnImageValue(int i) {
    if (adsObj!.media![i]!.fileType == "image") {
      return NetworkImage(adsObj!.media![i]!.fileUrl!);
    } else {
      return NetworkImage(adsObj!.media![i]!.thumbnailUrl!);
    }
  }


  String? categoryValueFindOut(int index) {
    for (var catValue in _categoryObj!) {
      if (index == catValue.id) return catValue.name;
    }
  }


  String? productTypeValue(int index) {
    if (index == 0)
      return "Rent as Hours";
    else if (index == 1) return "Rent as Days";
  }

  bool _validateInputs() {
    FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      if (mounted) {
        setState(() {
          autoValidate = true;
        });
      }

      return false;
    }
  }
}
