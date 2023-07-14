import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import '../Models/Ads.dart';
import '../Models/RentalItemModel.dart';
import '../Utils/Ads_services.dart';
import '../Utils/Const.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import 'RentRequestDetail.dart';


class MyAds extends StatefulWidget {

  static const String route = "MyAds";

  const MyAds({Key? key}) : super(key: key);

  @override
  State<MyAds> createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {

  List<AdsObj> _adsObj = [];
  bool? _isRequest = true;
  GlobalKey requestsUpdated = GlobalKey();

  final List<RentalItemModel> _rentalItemModels = [
    RentalItemModel(
        title: "Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$120/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.requests),
    RentalItemModel(
        title: "2019 Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$110/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.details),
  ];


  String getTitleFor(int index) {
    return _adsObj[index].name ?? "";
  }

  String getSubtitleFor(int index) {
    return _adsObj[index].description ?? "";
  }


  String getProductStatus(int index) {
    return _adsObj[index].is_approved == 0 ?  "pending" : "approved";
  }

  String getDisplayPriceFor(int index) {
    return "\$${_adsObj[index].rentCharges ?? " "}\/${_adsObj[index].rentType ?? ""}";
  }

  String getRentype(int index){
    return returnRentType("${_adsObj[index].rentType ?? ""}") ?? "";
  }

  String? returnRentType(String? value) {
    if (value == "day"){
      return "Rent as per Day";
    }else {
      return "Rent as per Hour";
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadAds();

  }


  loadAds() async {
    showLoading();
    getAds(type: "owner", lat: "", long: "", keyword: "", rentType: "", category: 0,distance: "10", onSuccess: (list) {
      _adsObj = list;
      if (list.isEmpty){
        toast("Record not found.");
      }
      hideLoading();
      if(mounted){
        setState((){});
      }

    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            "My Ads",
            textAlign: TextAlign.start,
            style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
          ),
          leading: IconButton(
            icon: SizedBox(
                width: 24.w,
                height: 24.w,
                child: Image.asset(
                  "src/backimg@3x.png",
                  fit: BoxFit.cover,
                )),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _RentalPostedBodyView());
  }

  String? returnImageValue(int i) {
    if (_adsObj[i].media?.first?.fileType == "image") {
      return _adsObj[i].media?.first?.fileUrl ?? "";
    } else {
      return _adsObj[i].media?.first?.thumbnailUrl ?? "";
    }
  }

  Widget circularImageView(
      {required String image, double size = 60, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , height: 60.h , width: 60.w , fit: BoxFit.fill,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
             height: 60.h , width: 60.h ,fit: BoxFit.cover,
          )),
      height: 60.h,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
    );
  }

  Widget _adsMyPost(int index){

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("myAds",_adsObj[index],requestsUpdated , null , null , null)) ).then((value) {
          setState((){
            _adsObj = [];
            loadAds();
          });


        });
      },
      child: Container(
        // height: 110.h,
        // width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            border: Border.all(color: Colors.white , width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(16.w))),
        child: Padding(
          padding: EdgeInsets.only(top: 5.h , bottom: 5.h),
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.w),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child :
                _adsObj[index].media!.isNotEmpty! ?  circularImageView(image: returnImageValue(index) ?? "" ,size: 60.w) : Image.asset("src/placeholder.png") ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:8.h ,),
                    Text(
                      getTitleFor(index),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: Const.aventaBold,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.sp,
                      ),maxLines: 1,
                    ),
                    SizedBox(height: 2.h,),
                    Text(
                      getSubtitleFor(index),
                      style:TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontFamily: Const.aventaBold,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.sp,
                      ),overflow: TextOverflow.clip,maxLines: 2,),
                    SizedBox(height: 2.h,),
                    Text(
                      getProductStatus(index),
                      style:TextStyle(
                        color: getProductStatus(index) == "pending" ? Style.redColor : Style.lightGreenColor,
                        fontWeight: FontWeight.w600,
                        fontFamily: Const.aventaBold,
                        fontStyle: FontStyle.normal,
                        fontSize: 12.sp,
                      ),overflow: TextOverflow.clip,maxLines: 2,),
                    SizedBox(height: 5.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getDisplayPriceFor(index),
                          style: Style.getBoldFont(12.sp,
                              color: Style.redColor),
                        ),

                          Container(
                            width: 99.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                                color: Style.redColor,
                                borderRadius:
                                BorderRadius.circular(20.w)),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RentalRequestDetail("myAds",_adsObj[index],requestsUpdated , null , null , null)) ).then((value) {
                                    setState((){
                                      _adsObj = [];
                                      loadAds();
                                    });
                                  });
                                },
                                child: Text(
                                  "Ads Details",
                                  style: Style.getBoldFont(12.sp,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),

                      ],
                    )
                  ],
                ),
              ),
              SizedBox(width: 16.w),
            ],
          ),
        ),
      ),
    );

  }

  Widget _RentalPostedBodyView()
  {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView.separated(
            itemCount: _adsObj!.length,
            itemBuilder: (context, index) {

              return _adsMyPost(index);

            },
            separatorBuilder:  (context, index) {
              return SizedBox(height: 9.w,);
            },
          ),
        ));
  }
}
