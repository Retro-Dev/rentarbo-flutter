import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Extensions/style.dart';
import '../Models/Category.dart';
import '../Models/UserCategory.dart';
import '../Utils/Const.dart';
import '../Utils/user_services.dart';
import '../Utils/utils.dart';
import '../View/views.dart';
import '../component/custom_button.dart';
import 'Dashboard.dart';

class SelectCategory extends StatefulWidget {
  static const String route = "SelectCategory";
  bool? isCommingFromSignUp;
  SelectCategory({this.isCommingFromSignUp});
  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  bool isSelected = false;

  List<bool>? _selectedCategories = [];

  List<int> selectedCategoriesIds = [];

  late List<CategoryObj>? _categoryObj = [];
  late List<UserCategoryObj>? _userCategory = [];

  String? getCategoryNameFor(int index) {
    return _categoryObj?[index].name;
  }



  removeSelectedCategoryItem(int index) {
    _selectedCategories![index] = false;
  }


  getCategorySelectedFor(int index) {
   _selectedCategories![index] = true;
  }


  bool showCategorySelectedFor(int index) {
    return _selectedCategories![index];
  }

  setCategorySelectedFor(int index, bool selected) {

  }

  int getCategoriesCount() {
    return _categoryObj?.length ?? 0;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      load();



  }


  load() async {
    showLoading();
    getCategory(onSuccess: ( List<CategoryObj> list) {
      hideLoading();
      _categoryObj?.addAll(list);
      addAllBooleanValues();
      loadUserCategory();
      if(mounted){
        setState((){});
      }

    }, onError: (error) {
       toast(error);
       hideLoading();
    });
  }

  loadUserCategory() async {
    showLoading();
    getUserCategories(onSuccess: (list) {
      _userCategory = list;
      hideLoading();
      if (mounted) {
        setState(() {});
      }
      loadAllCategory();
    }, onError: (error) {
      hideLoading();
      toast(error);
    });
  }

  loadAllCategory() {

    var counti = -1;
    var countj = -1;
    for (var cat in _categoryObj!){
      counti++;
      for (var select in _userCategory!){
        countj++;

        if (cat.name == select.category?.name) {
          _selectedCategories![counti] == true;
          getCategorySelectedFor(counti);
          print("Selected");
          if(mounted){
            setState((){});
          }

        }
      }
    }
  }


  addAllBooleanValues() {
    for (var id in _categoryObj!) {
       _selectedCategories!.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            "Change Category",
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
       body: SelectCategoryBody(context));
  }

  Widget SelectCategoryBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10 , left: 16 , right: 16 , bottom: 16),
      child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 10),
      Text("Select Category",
          style: const TextStyle(
              color: const Color(0xff1f1f1f),
              fontWeight: FontWeight.w700,
              fontFamily: Const.aventaBold,
              fontStyle: FontStyle.normal,
              fontSize: 22.0),
          textAlign: TextAlign.left),
      SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Opacity(
          opacity: 0.6000000238418579,
          child: Text("Please select category",
              style: const TextStyle(
                  color: const Color(0xff1f1f1f),
                  fontWeight: FontWeight.w400,
                  fontFamily: Const.aventaRegular,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
              textAlign: TextAlign.left),
        ),
      ),

      SizedBox(height: 16),
      Expanded(
        child: ListView.separated(
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {

                    this.isSelected = !this.isSelected;
                    if (this.isSelected == true) {
                      getCategorySelectedFor(index);
                      // _selectedCategories![index] = true;
                      print("selected");
                      if(mounted){
                        setState(() {

                        });
                      }


                    }else {
                      removeSelectedCategoryItem(index);
                      // _selectedCategories![index] = false;
                      print("unselected");
                      if(mounted){
                        setState(() {


                        });
                      }

                    }



                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getCategoryNameFor(index) ?? "",
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Image.asset(showCategorySelectedFor(index)
                            ? "assets/images/icons/round_check_selected_icon@2x.png"
                            : "assets/images/icons/round_check_unselected_icon@2x.png"),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: const Color(0xFF707070).withOpacity(0.1),
              );
            },
            itemCount: getCategoriesCount()),
      ),
      SizedBox(height: 24),
      CustomButton(

        onPressed: () {
          Iterable<int>.generate(_selectedCategories!.length).forEach( (index) => {
            if (_selectedCategories![index] == true) {
              selectedCategoriesIds.add(_categoryObj![index].id!)
            }
          });

          if (selectedCategoriesIds.length > 0 ){
            var jsonParam = {
              "category": selectedCategoriesIds,
            };

            print(jsonParam);
            showLoading();
            createCategory(jsonData: jsonParam, onSuccess: (data) {
              if(!(widget.isCommingFromSignUp ?? false)) {
                toast(data.message ?? "");
              }

             hideLoading();
              Navigator.pushNamedAndRemoveUntil(context, Dashboard.route, (route) => false);


            }, onError: (error) {
              toast(error);
              hideLoading();
            });
          }else {
            toast("Select atleast a category");
          }


        },
        btnText: "Done",
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
      ),
      SizedBox(height: 24),
    ],
      ),
    );
  }
}
