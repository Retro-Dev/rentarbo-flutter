import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../Models/CardDetailModel.dart';
import '../../Models/User.dart';
import '../../Utils/BankAndCardServices.dart';
import '../../Utils/Const.dart';
import '../../Utils/Prefs.dart';
import '../../Utils/user_services.dart';
import '../../Utils/utils.dart';
import '../../View/custom_dailog_box.dart';
import '../../View/views.dart';
import 'Add Credit Card.dart';
import 'PaymentHistory.dart';


class PaymentDetails extends StatefulWidget {
  static const route = "PaymentDetails";

  const PaymentDetails({Key? key}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  bool agree = false;

  List<CardDetailsModel> cardObjectList = [];
  CardDetailsModel? selectedCard;
  AlertDialog? alert;

  User? userSavedData;





  void markAsDefault(CardDetailsModel cardDataObject) {
    showLoading();
    BankAndCardServices.markAsDefaultCard(
        url: Const.MakeCardDefaultOrDelete + "${cardDataObject?.slug}",
        params: {"_method": "PUT", "is_default": "1"},
        onSuccess: (code, message) {
          hideLoading();
          if (code == 200) {
            toast(message);
            getCardLists();
            //Navigator.pop(context);
          }
        },
        onError: (error) {
          hideLoading();
          toast(error);
        });
  }

  void deleteCard()
  {
    print("Delete test popup");
    deleteUserCard(selectedCard!);

  }
  void deleteUserCard(CardDetailsModel objectData) async
  {
    showLoading();
    Navigator.pop(context);

    BankAndCardServices.deleteCardApiMehtod(params: {'id':'${objectData?.slug}'}, onSuccess: (code,message)
    {
      hideLoading();
      if (code == 200)
      {
        toast(message);
        getCardLists();
        //Navigator.pop(context);
      }

    }, onError: (error)
    {
      hideLoading();
      toast(error);

    });

  }
  void getCardLists()
  {
    showLoading();
    BankAndCardServices.getCardList(apiUrl: Const.GetCardList, onSuccess: (List<CardDetailsModel> cardList){
      hideLoading();
      cardObjectList = cardList;

      setState(()
      {

      });
    }, onError: (error)
    {
      hideLoading();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCardLists();
    load();
  }

  load() async {
    Prefs.getUser((User? user){
      setState(() {
        this.userSavedData = user;

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Payment Details', style: TextStyle(fontFamily: Const.aventaBold, color: Colors.black),),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.light,
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
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => PaymentHistory()));
                  // Navigator.pushNamed(context, PaymentHistory.route);
                },
                //Image.asset('src/payment_history.png',scale: 2.2,),
                child: ImageIcon(AssetImage('src/payment_data.png'),size: 28,),
              )
          ),
          SizedBox(width: 10,),
          Padding(
              padding: EdgeInsets.only(right: 25),
              child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AddCreditCard.route).then((value) {

                      if (cardObjectList.isEmpty)
                      {
                        var urlString = 'user/${userSavedData?.slug}';
                        showLoading();
                        getUserProfile(url: urlString, onSuccess: (userData){
                          //hideLoading();
                          // print('userData.isCardInfo ${userData.isCardInfo}');
                          cardObjectList = [];
                          getCardLists();

                        }, onError: (error)
                        {
                          hideLoading();
                          toast(error);

                        });
                      }
                      else
                      {
                        cardObjectList = [];
                        getCardLists();
                      }


                    });
                  },
                  //Image.asset('src/payment_history_add.png',scale: 3.2,),
                  child:  ImageIcon(AssetImage('src/payment_history_add.png'),size: 28,)
              )
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: body(),
      //   padding: EdgeInsets.only(left: 20, right: 20, top: 0),
      // ),
      body: SingleChildScrollView(
        child: cardObjectList.isEmpty ? showEmpty() : body(),
        padding: EdgeInsets.only(left: 20, right: 20, top: 0),

      ),
    );
  }

  Column showEmpty() {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 100,),
        Align(
            alignment: Alignment.center,
            child: Image.asset(
              'src/emptyCard.png',
              height: 200,
              width: 200,
            )),
        SizedBox(
          height: 3.2,
        ),
        Text(
          'No data found',
          style: TextStyle(
              fontFamily: Const.aventaBold,
              fontSize: 20,
              color: ColorsConstant.grayishColor),
          textAlign: TextAlign.center,
        ),

      ],
    );
  }


  Widget body() {
    return Column(
      children: [

        SizedBox(
          height: 20,
        ),
        // CardMenuItem('payment_visa', '****  ****  **** 2356', 'Added 15-02-2017'),
        // SizedBox(height: 5,),

        for( var cardData in cardObjectList)
          CardMenuItem(getImageName('${cardData?.brand}'),imageScaleSize('${cardData?.brand}'), '****  ****  **** ${cardData.last4Digit}', 'Added ${cardData?.createdAt?.substring(0, 10)}',cardData,isSelected: cardData.isDefault == "1" ? true:false ),
        SizedBox(height: 5,),

      ],
    );
  }

  String getImageName(String brandName)
  {
    String? cardImage = '';
    switch(brandName)
    {
      case CardBrandConstant.American_Express:
        cardImage = 'AmericanExpress';
        break;
      case CardBrandConstant.Diners_Club:
        cardImage = 'diners';
        break;
      case CardBrandConstant.Discover:
        cardImage = 'Discover';
        break;
      case CardBrandConstant.JCB:
        cardImage = 'jcb';
        break;
      case CardBrandConstant.MasterCard:
        cardImage = 'master';
        break;
      case CardBrandConstant.UnionPay:
        cardImage = 'UnionPay';
        break;
      case CardBrandConstant.Visa:
        cardImage = 'payment_visa';
        break;

        default:
          cardImage = 'payment_visa';
          break;
    }
    return cardImage;
  }

  double imageScaleSize(String brandName)
  {
    double? cardImageSize = 3.5;
    switch(brandName)
    {
      case CardBrandConstant.American_Express:
        cardImageSize = 2.8;
        break;
      case CardBrandConstant.Diners_Club:
        cardImageSize = 3.5;
        break;
      case CardBrandConstant.Discover:
        cardImageSize = 4.0;
        break;
      case CardBrandConstant.JCB:
        cardImageSize = 2.5;
        break;
      case CardBrandConstant.MasterCard:
        cardImageSize = 3.0;
        break;
      case CardBrandConstant.UnionPay:
        cardImageSize = 2.5;
        break;
      case CardBrandConstant.Visa:
        cardImageSize = 3.5;
        break;
    }
    return cardImageSize;
  }


  Widget CardMenuItem(image,scaleSize, cardnumber, date,CardDetailsModel? cardData ,{bool isSelected = false}) {
    return Container(
      child: Card(
        // shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 10,top: 10,bottom: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(isSelected == true)
                    SizedBox(height: 15,),
                  Image.asset(
                    'src/$image.png',
                    scale: scaleSize,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('$cardnumber',
                    style: TextStyle(
                      fontFamily: Const.aventaBold,
                      fontSize: 15,
                      color: Color.fromARGB(255, 69, 79, 99),

                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('$date',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: Const.aventaBold,
                        //178 185 200
                        color: Color.fromARGB(255, 178, 185, 200)
                    ),),
                ],
              ),
              Spacer(),
              Column(
                children: [

                  SizedBox(height: 10,),

                  Checkbox(
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.all(Colors.green),
                    activeColor: Colors.grey,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashRadius: 0.0,
                    value: isSelected,
                    shape: CircleBorder(),
                    onChanged: (bool? value) {
                      setState(() {
                        print("value $value");
                        isSelected = value ?? false;
                        if (value == true)
                        {
                          markAsDefault(cardData!);
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if(isSelected == true)
                    SizedBox(
                      height: 25,
                    ),
                  if(isSelected == false)
                    IconButton(
                      icon: Image.asset(
                        'src/payment_delete.png',
                        scale: 3.5,
                      ),
                      onPressed: () {
                        print('Hellow world');
                        selectedCard = cardData;

                        this.alert = AlertYesNo(
                            title: "Alert!",
                            content: "Are you sure you want to delete?",
                            context: context,
                            Callback: deleteCard);

                        showDialog(
                          context: context,
                          builder: (BuildContext _context) {
                            return this.alert!;
                          },
                        );



                      },
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
