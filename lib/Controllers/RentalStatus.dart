import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentarbo_flutter/Controllers/ReturnStatusDetail.dart';
import 'package:rentarbo_flutter/Models/ReturnStatus.dart';
import 'package:rentarbo_flutter/Utils/BookingAds.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';
import '../Extensions/style.dart';
import '../Models/RentalItemModel.dart';

class RentalStatus extends StatefulWidget {
  const RentalStatus({Key? key}) : super(key: key);

  static const String route = "RentalStatus";

  @override
  State<RentalStatus> createState() => _RentalStatusState();
}

class _RentalStatusState extends State<RentalStatus> {

  final List<RentalItemModel> _rentalItemModels = [
    RentalItemModel(
        title: "Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$120/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.delete),
    RentalItemModel(
        title: "2019 Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$110/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.delete),
  ];

  int getInboxItemsCount() {
    return _rentalItemModels.length;
  }

  String getTitleFor(int index) {
    return returnStatus?.returnData?[index]?.product?.name ?? "";
  }

  String getSubtitleFor(int index) {
    return returnStatus?.returnData?[index]?.product?.category?.name ?? "";
  }

  String getDisplayPriceFor(int index) {
    return "\$"+"${returnStatus?.returnData?[index]?.product?.rentCharges ?? ""}";
  }

  String getDisplayImageFor(int index) {
    return _rentalItemModels[index].displayImage;
  }

  RentalButtonType getButtonTypeFor(int index) {
    return _rentalItemModels[index].buttonType;
  }

  ReturnStatus? returnStatus;
  String? returnImageValue(int i) {
    if (returnStatus!.returnData![i]!.product!.media!.first!.fileType == "image") {
      return returnStatus!.returnData?[i]?.product?.media?.first?.fileUrl ?? "";
    } else {
      return returnStatus!.returnData?[i]?.product?.media?.first?.thumbnailUrl ?? "";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var jsonParam = {"returned_status":"1" , "booking_type":"recieved" };
    showLoading();
    getReturnStatus(jsonData: jsonParam, slug: "", onSuccess: (data) {
      hideLoading();
      setState((){
        returnStatus = data;
        if (data.returnData!.isEmpty) {
          toast("Record not found.");
        }
      });



    }, onError: (error) {
      toast(error);
      hideLoading();
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
            "Return Status",
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
        body: _RentalStatusBodyView());
  }


  Widget circularImageView(
      {required String image, double size = 50, bool profile = true}) {
    return CachedNetworkImage(
      // imageUrl: "http://via.placeholder.com/350x150",
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (context, url) => FittedBox(
        fit: BoxFit.cover,
        child: Image.asset('src/placeholder.png' , height: 60.h , width: 60.h , fit: BoxFit.cover,),
      ),
      errorWidget: (context, url, error) => FittedBox(
          child: Image.asset(
            profile ? 'src/placeholder.png' : 'src/placeholder.png',
             height: 60.h , width: 60.h ,fit: BoxFit.cover,
          )),
      height: 60.w,
      width: size.w,
      memCacheHeight: 600 ,
      memCacheWidth: 600,
      maxHeightDiskCache: 800,
      maxWidthDiskCache: 800,
    );
  }

  Widget  _RentalStatusBodyView()
  {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ListView.separated(
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) =>
                        ReturnStatusDetail(product: returnStatus!.returnData![index]!,),))
                        .then((value){


                    });
                  },
                  child: Container(
                    height: 80.w,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.all(Radius.circular(16.w))),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 16.w),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child :circularImageView(image: returnImageValue(index) ?? "" ,size: 60.w),),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getTitleFor(index),
                                style: Style.getBoldFont(14.sp,
                                    color: Style.textBlackColor),
                              ),
                              Text(
                             getSubtitleFor(index),
                                style: Style.getBoldFont(12.sp,
                                    color: Style.textBlackColor),
                              ),
                              SizedBox(height: 5.w),
                              Text(
                                getDisplayPriceFor(index),
                                style:
                                Style.getBoldFont(12.sp, color: Style.redColor),
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8.w,
                );
              },
              itemCount: returnStatus?.returnData?.length ?? 0),
        ));
  }
}
