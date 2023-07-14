import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/RentalCategoryViewModel.dart';
import '../../utils/style.dart';

class RentalCategoryView extends StatelessWidget {
  // const RentalCategoryView({Key? key}) : super(key: key);

  RentalCategoryViewModel rentalCategoryViewModel = RentalCategoryViewModel();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          childAspectRatio: 4 / 4.3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5),
      itemCount: rentalCategoryViewModel.getCategoriesCount(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                color: Style.textWhiteColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      rentalCategoryViewModel.getImageForCategoryFor(index),
                      fit: BoxFit.fill,
                      width: 200,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        rentalCategoryViewModel.getTitleForCategoryFor(index),
                        style: Style.getSemiBoldFont(14.sp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            rentalCategoryViewModel
                                .getPriceForCategoryFor(index),
                            style: Style.getSemiBoldFont(13.sp),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                  height: 16.h,
                                  width: 16.w,
                                  child: Image.asset(
                                      Style.getIconImage("ic_rating@2x.png"))),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                rentalCategoryViewModel
                                    .getRatingForCategoryFor(index),
                                style: Style.getSemiBoldFont(12.sp,
                                    color:
                                        Style.textBlackColor.withOpacity(0.5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        );
      },
    );
  }
}
