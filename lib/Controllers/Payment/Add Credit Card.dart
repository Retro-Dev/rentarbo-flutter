import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


import '../../Extensions/style.dart';
import '../../Utils/BankAndCardServices.dart';
import '../../Utils/Const.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import '../../component/custom_button.dart';


class AddCreditCard extends StatefulWidget {
  static const route = 'AddDebitCard';

  const AddCreditCard({Key? key}) : super(key: key);

  @override
  State<AddCreditCard> createState() => _AddCreditCardState();
}

class _AddCreditCardState extends State<AddCreditCard> {

  CardFormEditController cardController = CardFormEditController();
  CardFieldInputDetails? cardDetails;
  FocusNode stripeField = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void updateTokenAtServer(String token)
  {
    BankAndCardServices.AddBankInfo(url: Const.AddCard, params: {"card_token":token}, onSuccess: (data)
    {
      hideLoading();
      Navigator.pop(context);

    }, onError: (error){

    });
  }

  SizedBox addPaddingWhenKeyboardAppears() {
    final viewInsets = EdgeInsets.fromWindowPadding(
      WidgetsBinding.instance!.window.viewInsets,
      WidgetsBinding.instance!.window.devicePixelRatio,
    );

    final bottomOffset = viewInsets.bottom;
    const hiddenKeyboard = 0.0; // Always 0 if keyboard is not opened
    final isNeedPadding = bottomOffset != hiddenKeyboard;

    return SizedBox(height: isNeedPadding ? bottomOffset : hiddenKeyboard);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset:false,
        appBar:
        AppBar(
        backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
        "Add Debit Card",
        textAlign: TextAlign.start,
        style: Style.getBoldFont(18, color: Style.textBlackColor),
    ),
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

        body:Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (_) {
              print("hide keyboard ${_.localPosition}");
              FocusManager.instance.primaryFocus?.unfocus();

            },
            child: body() )

    );
  }

  Widget body() {
    String phone;
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.only(right: 20, left: 20, top: 20,bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          SizedBox(height: 20,),
          // CardFormField(controller:cardController,),
          // SizedBox(height: 20,),
          MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.2),
            child: CardField(
              style: TextStyle(color: Colors.black),
              onCardChanged: (card){
                print(card.toString().length);
                cardDetails = card;
                print(card);
              },
            ),
          ),
          // SizedBox(height: 100,),
          Spacer(),

          Center(
            child: SizedBox(
              // width: 170,
              child: CustomButton(

                width: MediaQuery.of(context).size.width,
                btnText: 'SAVE',
                onPressed: (){
                  if (cardDetails != null)
                  {
                    print(cardDetails.toString().length);
                    if (cardDetails.toString().length == 275)
                    {
                      showToast("Card details required.",position:ToastPosition.bottom);
                      return;
                    }
                    else if (cardDetails.toString().length == 276)
                    {
                      showToast("Card details required.",position:ToastPosition.bottom);
                      return;
                    }
                    else
                    {
                      if (cardDetails!.complete == false) {
                        showToast("Invalid card details.",
                            position: ToastPosition.bottom);
                        return;
                      }
                    }


                    showLoading();
                    Stripe.instance.createToken(CreateTokenParams.card(params: CardTokenParams(name: cardDetails!.brand))).then((value){
                      print(value.id);
                      updateTokenAtServer(value.id);
                    });
                  }
                  else
                  {
                    showToast('Card details required.',position:ToastPosition.bottom);
                  }



                  //Navigator.pop(context);

                },
              ),
            ),
          ),
          addPaddingWhenKeyboardAppears(),

          //SizedBox(height: 40,)

        ],
      ),
    );
  }
}

