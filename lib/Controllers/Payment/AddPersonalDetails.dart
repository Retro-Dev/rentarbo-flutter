// import 'dart:ffi';
// import 'dart:html';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentarbo_flutter/component/custom_button.dart';
import '../../Models/BankInfo.dart';
import '../../Models/PayoutPersonalInfoModel.dart';
import '../../Models/User.dart';
import '../../Utils/AddressModel.dart';
import '../../Utils/BankAndCardServices.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/helping_methods.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../component/SearchLocationPage.dart';
import '../../component/Spinner.dart';


class AddPersonalDetails extends StatefulWidget {
  // const AddPersonalDetails({Key? key}) : super(key: key);
  static const route = 'AddPersonalDetails';

  CheckAccountStatusModel? accountData;

  AddPersonalDetails({this.accountData});

  @override
  State<AddPersonalDetails> createState() => _AddPersonalDetailsState();
}

class _AddPersonalDetailsState extends State<AddPersonalDetails> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>(debugLabel: '_Login');


  User? userSavedData;
  bool? locationIssue = true;
  bool? firstNameIssue = true;
  bool? lastNameIssue = true;
  bool? ssnIssue = true;
  bool? dobIssue = true;
  bool? frontimageIssue = true;
  bool? backimageIssue = true;

  FocusNode firstNameFocus = FocusNode(),
      lastNameFocus = FocusNode(),
      INFocus = FocusNode(),
      SSNFocus = FocusNode(),
      DOBFocus = FocusNode();

  TextEditingController firstNameController = TextEditingController(),
      lastNameController = TextEditingController(),
      ssnController = TextEditingController(),
      locationController = TextEditingController(),
      dobController = TextEditingController();

  bool isButtonEnable = true;

  String? firstName, lastName, SSN,DOB,city,state,street,phone,postalCode,country,location,lat,long;
  double height = 0.15, sizeWitdh = 2.5;

  File? frontimage;
  File? backimage;

  bool autoValidate = false,
      firstNamePobsure = true,
      InsuranceNumberPobsure = true,
      lastNamePobsure = true,
      SSNPobsure = true,
      DOBPobsure = true;

  var selectedDate;

  var finalDate;

  //var locationController = TextEditingController();

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



  load() async {

    Prefs.getUser((User? user){
      setState(() {
        this.userSavedData = user;
        this.phone = userSavedData?.mobileNo;

        // this.phone = phone?.substring(1);

      });
    });
  }

  void checkAccountInfo()
  {
    if (widget.accountData != null)
    {

      if (widget.accountData?.fieldsDue?.isEmpty == false)
      {
        locationIssue =  widget.accountData?.fieldsDue?.contains("individual.address.line1");


        firstNameIssue =  widget.accountData?.fieldsDue?.contains("individual.first_name");
        lastNameIssue =  widget.accountData?.fieldsDue?.contains("individual.last_name");
        ssnIssue =  widget.accountData?.fieldsDue?.contains("individual.ssn_last_4");
        dobIssue =  widget.accountData?.fieldsDue?.contains("individual.dob.year");



      }

      if (widget.accountData?.errors?.isEmpty == false)
      {
        showToast("${widget.accountData?.errors?[0].reason}");
      }

      if (widget.accountData?.personalInfo != null) {
        this.firstNameController.text =
            widget.accountData?.personalInfo?.firstName ?? '';
        this.lastNameController.text =
            widget.accountData?.personalInfo?.lastName ?? '';
        this.ssnController.text = widget.accountData?.personalInfo?.ssn ?? '';
        this.locationController.text =
        "${widget.accountData?.personalInfo?.street ?? ''},${widget.accountData?.personalInfo?.city ?? ''},${widget.accountData?.personalInfo?.state ?? ''},${widget.accountData?.personalInfo?.postalCode ?? ''}";
        this.dobController.text =
            widget.accountData?.personalInfo?.dateOfBirth ?? '';
        frontimageIssue = false;
        backimageIssue = false;
      }
      if (widget.accountData?.personalInfo?.status == "verified")
      {

        isButtonEnable = false;
        locationIssue =  false;
        firstNameIssue =  false;
        lastNameIssue =  false;
        ssnIssue =  false;
        dobIssue =  false;
      }
    }
  }

  void existAccountUpdate()
  {
    Map<String,dynamic> params = {"":""};
    if (ssnIssue == true)
    {
      if(SSN == null)
      {
        showToast("Add Valid SSN ",position:ToastPosition.bottom);
        return;
      }
      else
      {
        params = {"ssn":SSN};

        // params["ssn"] = SSN;
      }

    }

    if (dobIssue == true)
    {
      if (selectedDate == null)
      {
        showToast("Add Valid DOB",position:ToastPosition.bottom);
        return;
      }
      else
      {
        params = {"dob":finalDate};
        // params?["dob"] = finalDate;
      }

    }

    if (firstNameIssue == true)
    {
      if (firstName == null)
      {
        showToast("Add First Name",position:ToastPosition.bottom);
        return;
      }
      else
      {
        params = {"first_name":firstName};
        //params?["first_name"] = firstName;
      }

    }


    if (lastNameIssue == true)
    {
      if (lastName == null)
      {
        showToast("Add Last Name",position:ToastPosition.bottom);
        return;
      }
      else
      {
        params = {"last_name":lastName};
        // params?["last_name"] = lastName;
      }

    }

    if (locationIssue == true)
    {
      if (state == null)
      {
        showToast("Select Valid Address",position:ToastPosition.bottom);
        return;
      }
      else
      {
        params = {"state":state,"city":city,"street":street,"postal_code":postalCode};

      }

    }

    showLoading();
    BankAndCardServices.AddPersonalInfowithOutImage(url: Const.Bank_payout_persoal_info, params: params, onSuccess: (personalInfo){
      hideLoading();
      Navigator.pop(context);
    }, onError: (error)
    {
      print(error);
     toast(error);
    });
  }

  void newUserAccount()
  {
    if (_validateInputs())
    {
      if (selectedDate == null)
      {
        showToast("DOB is required",position:ToastPosition.bottom);
        return;
      }

      if (locationController.text == "")
      {
        showToast("Location Address is required",position:ToastPosition.bottom);
        return;
      }

      if (frontimage == null)
      {
        showToast("Add Front Photo of your ID card",position:ToastPosition.bottom);
        return;
      }

      if (backimage == null)
      {
        showToast("Add Back Photo of your ID card",position:ToastPosition.bottom);
        return;
      }

      addPersonalInfoApi();

    }

  }

  void addPersonalInfoApi()
  {
    var params = {"first_name":firstName,"last_name":lastName,"dob":finalDate,"ssn":SSN,
      "city":city,"state":state,"street":street,"postal_code":postalCode,"phone":phone
    };
    List<Map<String,dynamic>>? imageFiles = [];
    if (this.frontimage != null)
    {

      imageFiles.add({"name":"id_front","path":this.frontimage!.path});

    }
    if (this.backimage != null)
    {
      imageFiles.add({"name":"id_back","path":this.backimage!.path});

    }

    print("imageFiles ${imageFiles}");
    showLoading();
    BankAndCardServices.AddPersonalInfo(url: Const.Bank_payout_persoal_info, params: params, files: imageFiles,  onSuccess:
        (PayoutPersonalInfoModel personalInfo) {
      hideLoading();
      Navigator.pop(context);

    },
        onError: (String error) {
          hideLoading();
          print(error);
          toast(error);
        });
  }

  @override void initState() {
    // TODO: implement initState
    super.initState();
    print("All Home objects");
    handlePermission();
    _getUserLocation();
    checkAccountInfo();
    load();
    print("-----------------INfo Bank---------------");
   print("${widget.accountData?.personalInfo?.id}");

    print("${widget.accountData?.personalInfo?.id}");
    print("-----------------INfo Bank---------------");
  }

  void selectLocation()
  {

    Navigator.pushNamed(context, SearchLocationPage.route , arguments: {"userLatLng" : currentPostion} ).then((value){
      if(value!=null){
        AddressModel address = value as AddressModel;
        //locationForTexfield.text = address.fullAddress!;
        //location = address.fullAddress;
        lat = address.latLng?.latitude.toString();
        long = address.latLng?.longitude.toString();
        locationController.text = address.fullAddress!;
        print("address.list ${address.address}");

        city =  "${address.address![0].locality}";
        state =  "${address.address![0].administrativeArea}";
        street = "${address.address![0].street}";
        postalCode = "${address.address![0].postalCode}";
        country = "${address.address![0].country}";

        location  = address.fullAddress!;
        // this.userSavedData?.address = address.fullAddress;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        //"${widget.choreData == null ? 'Post' : 'Edit'} Chore",
        title: Text('${widget.accountData?.personalInfo == null ? 'Add':'View'} Personal Details' , style: TextStyle(color: Colors.black , fontFamily: Const.aventaBold),),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: Colors.black),

        leading: IconButton(
          icon: SizedBox(
              width: 30.w,
              height: 30.w,
              child: Image.asset(
                "src/backimg@3x.png",
                fit: BoxFit.cover,
              )),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: (_) {
            // print("hide keyboard ${_.localPosition}");
            FocusManager.instance.primaryFocus?.unfocus();

          },
          child: SingleChildScrollView(child: body(),)),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 30, bottom: 25),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditText(
                    context: context,
                    hintText: 'First Name',
                    setEnable: firstNameIssue!,
                    validator: validateFirstName,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    controller: firstNameController,


                    currentFocus: firstNameFocus,
                    nextFocus: lastNameFocus,
                    onChange: (text) {
                      firstName = text;
                    },
                    onSaved: (val) {
                      firstName = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  EditText(
                    context: context,
                    hintText: 'Last Name',
                    setEnable: lastNameIssue!,
                    validator: validateLastName,

                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    currentFocus: lastNameFocus,
                    nextFocus: SSNFocus,
                    controller: lastNameController,

                    onChange: (text) {
                      lastName = text;
                    },
                    onSaved: (val) {
                      lastName = val;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  EditText(
                    context: context,
                    hintText: "Social Security Number",
                    setEnable: ssnIssue!,
                    validator: validateSSN,
                    textInputType: TextInputType.numberWithOptions(signed: true, decimal: true),
                    textInputAction: TextInputAction.done,

                    currentFocus: SSNFocus,
                    nextFocus:DOBFocus ,
                    controller: ssnController,

                    onChange: (text) {
                      SSN = text;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ID Card',
                    style: TextStyle(
                      color: Color(0xff454f63),
                      fontFamily: Const.aventaBold,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Attach your ID card image (Front - Back)',
                    style: TextStyle(
                      color: Color(0xff454f63),
                      fontSize: 12,
                      fontFamily: Const.aventaBold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // crossAxisAlignment: CrossAxisAlignment.end,

                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            if(frontimageIssue == true)
                            {
                              showImageSelectOption(context, false ,(image,isVideo ,imageThump) async{

                                if (image != null)
                                  setState(() {
                                    this.frontimage = image;
                                  });
                              });
                              print('add photo');
                            }


                            // setState(() {
                            //   frontImage = true;
                            // });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * height,
                            //width: MediaQuery.of(context).size.width / sizeWitdh,
                            decoration: BoxDecoration(
                              color: ColorsConstant.spruce6,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('src/addPhotoIcon.png',
                                          // width: 38.0,
                                          // height: 38.0,
                                          scale: 4.5,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Add Front Photo',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: Const.aventaBold,
                                            color: ColorsConstant.slate),
                                      ),
                                    ],
                                  ),
                                ),
                                if (this.frontimage == null && widget.accountData?.personalInfo != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    child: Image.network('${widget.accountData?.personalInfo?.idFront}',
                                      width: MediaQuery.of(context).size.width,
                                      height:MediaQuery.of(context).size.height *
                                          height ,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (this.frontimage != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    child: Image.file(
                                      this.frontimage!,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          height,
                                      fit: BoxFit.cover,
                                    ),
                                    // child: Image.network('${widget.choreData?.imageUrl}'),
                                  ),
                                if (this.frontimage != null)
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: IconButton(
                                      icon: Image.asset('src/closebtn@3x.png',
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      onPressed: () {
                                        // remove image
                                        setState(() {
                                          this.frontimage = null;
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            if(backimageIssue == true) {
                              showImageSelectOption(context, false,(image,bool,filevalue) async  {
                                if (image != null)
                                  setState(() {
                                    this.backimage = image;
                                  });
                              });
                            }

                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * height,
                            //width: MediaQuery.of(context).size.width / sizeWitdh,
                            decoration: BoxDecoration(
                              color: ColorsConstant.spruce6,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset('src/addPhotoIcon.png',
                                          scale: 4.5,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Add Back Photo',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: Const.aventaBold,
                                            color: ColorsConstant.slate),
                                      ),
                                    ],
                                  ),
                                ),
                                if (this.backimage == null && widget.accountData?.personalInfo != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                    child: Image.network('${widget.accountData?.personalInfo?.idBack}',
                                      width: MediaQuery.of(context).size.width,
                                      height:MediaQuery.of(context).size.height *
                                          height ,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                if (this.backimage != null)
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                    child: Image.file(
                                      this.backimage!,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          height,
                                      fit: BoxFit.cover,
                                    ),


                                  ),
                                if (this.backimage != null)
                                  Positioned(
                                    right: 5,
                                    top: 5,
                                    child: IconButton(
                                      icon: Image.asset('src/closebtn@3x.png',
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center),
                                      onPressed: () {
                                        // remove image
                                        setState(() {
                                          this.backimage = null;
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // EditText(
                  //   context: context,
                  //   hintText: "Insurance Number",
                  //   obscure: InsuranceNumberPobsure,
                  //   validator: validateField,
                  //   textInputType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  //   textInputAction: TextInputAction.next,
                  //   isPassword: false,
                  //   currentFocus: INFocus,
                  //   // prefixIcon:'src/login_password.png',
                  //   // icon: CPobsure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  //   // suffixClick: (){
                  //   //   setState((){
                  //   //     CPobsure = !CPobsure;
                  //   //   });
                  //   // },
                  //   onChange: (text) {
                  //     InsuranceNumber = text;
                  //   },
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),

                  InkWell(
                    onTap: () async {

                      if (dobIssue == true) {
                        selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2030),
                        );
                        // print("selectedDate:"+selectedDate);

                        finalDate =
                            DateFormat("yyyy-MM-dd").format(selectedDate);
                        // print(DateFormat("yyyy-MM-dd").format(selectedDate));
                        print(finalDate);
                        setState(() {});
                      }
                    },
                    child: Spinner(
                      //  dropdownValue: widget.choreData?.jobDate.toString(),
                      hint: finalDate == null
                          ? (widget.accountData?.personalInfo?.dateOfBirth ?? 'DOB')
                          : finalDate,
                      value: finalDate,
                      array: const <String>[],
                      filledColor: ColorsConstant.spruce6,
                      placeholderTextColor: (finalDate == null ||
                          selectedDate == null)
                          ? Color.fromARGB(255, 69, 79, 99)
                          : Colors.black,
                      arrowIcon: Icons.calendar_month,
                      onChange: (newValue) {
                        // gender = newValue;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: ()
                    {
                      if(locationIssue == true)
                        selectLocation();
                    },
                    child: EditText(
                      context: context,
                      setEnable: false,
                      hintText: 'Location',
                      // validator: validateName,
                      textInputAction: TextInputAction.next,
                      //currentFocus: locationFocus,
                      //nextFocus: priceFocus,
                      isFilled: true,
                      isLabelHidden: true,
                      filledColor: ColorsConstant.spruce6,
                      controller: locationController,
                      onChange: (text) {
                        location = text;
                      },
                      onSaved: (val) {
                        location = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            SizedBox(height:50,),
            if(isButtonEnable == true)
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: CustomButton(
                    btnText: 'SAVE',

                    width: 180,
                    onPressed: () {
                      //Navigator.pop(context);
                      if(widget.accountData?.personalInfo != null)
                      {
                        existAccountUpdate();
                      }
                      else
                      {
                        newUserAccount();
                      }
                    },
                  ),
                ),
              ),
          ],
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
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }
}
