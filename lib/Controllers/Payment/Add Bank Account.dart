import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rentarbo_flutter/component/custom_button.dart';
import 'package:uuid/uuid.dart';

import '../../Models/BankInfo.dart';
import '../../Utils/BankAndCardServices.dart';
import '../../Utils/Const.dart';
import '../../Utils/utils.dart';
import '../../View/views.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddBankAccount extends StatefulWidget {
  static const route = 'AddBankAccount';
  //const AddBankAccount({Key? key}) : super(key: key);

  CheckAccountStatusModel? accountData;

  AddBankAccount({this.accountData});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {

  GlobalKey<FormState> _formKey =
  GlobalKey<FormState>(debugLabel: '_Login');
  bool autoValidate = false;

  String? bankName,accountNo,routingNo;
  bool isButtonEnable = true;

  FocusNode bankNameFocus = FocusNode(),
      routingFocus = FocusNode(),
      accountFocus = FocusNode();

  TextEditingController accountHolderController = TextEditingController(),
      routingController = TextEditingController(),
      accountNumberController = TextEditingController();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: bankNameFocus),
        KeyboardActionsItem(focusNode: routingFocus),
        KeyboardActionsItem(focusNode: accountFocus),

      ],
    );
  }

  void checkAccountInfo()
  {
    if (widget.accountData != null)
    {
      if (widget.accountData?.bankInfo != null) {
        this.accountHolderController.text =
            widget.accountData?.bankInfo?.accountHolderName ?? '';
        this.accountNumberController.text =
            '**** **** ${widget.accountData?.bankInfo?.last4Digit}' ?? '';
      }
      if (widget.accountData?.bankInfo != null)
      {

        isButtonEnable = false;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Stripe.publishableKey = "pk_test_R2lh0jAc5eQFLLe1nNHBPQFH00n0hfasgA";
    checkAccountInfo();

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

  void addBankToken()
  {
    if (_validateInputs())
    {
      getTokenFromStripeApi();
    }

  }

  void getTokenFromStripeApi()
  {
    Stripe.publishableKey = "pk_test_R2lh0jAc5eQFLLe1nNHBPQFH00n0hfasgA";

    // var newbank =  Stripe.instance.collectBankAccountToken(clientSecret: ConstantKeys.StripeSandboxKey);

    showLoading();
    Stripe.instance.createToken(
        CreateTokenParams.bankAccount(
            params: BankAccountTokenParams(accountNumber: accountNo!, country: "us", currency: "usd",routingNumber: routingNo!,accountHolderName: bankName!))).then((value){
      hideLoading();
      print("value.id ${value.id}");
      updateTokenAtServer(value.id);
    }).catchError((error){
      hideLoading();
      StripeException value = error;
      showToast("${value.error.message}",duration:Duration(milliseconds: 3000) );
      print(error);


      // print("value.error.localizedMessage ${value.error.message}");
      //print("error:${error.toString()}");
    } );

  }

  void updateTokenAtServer(String token)
  {
    showLoading();
    BankAndCardServices.AddBankInfo(url: Const.Bank_payout_external, params: {"bank_token":token}, onSuccess: (data)
    {
      hideLoading();
      Navigator.pop(context);

    }, onError: (error){
      hideLoading();
      toast(error);
      print(error);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('${widget.accountData?.bankInfo == null ? 'Add':'View'} bank account' , style: TextStyle(color: Colors.black , fontFamily: Const.aventaBold),),
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

      ),
      body: KeyboardActions(
          config: _buildConfig(context),
          child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) {
                // print("hide keyboard ${_.localPosition}");
                FocusManager.instance.primaryFocus?.unfocus();

              },
              child: body())),
    );
  }

  Widget body()
  {
    return Container(
      padding: const EdgeInsets.only(right: 20,left: 20,top: 30,bottom: 40),
      child: Form(
        key: _formKey,
        autovalidateMode: autoValidate ? AutovalidateMode.onUserInteraction
            :AutovalidateMode.disabled,
        child: Column(

          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('${widget.accountData?.bankInfo == null ? 'Select':''} Mode of Payment',
                  style: TextStyle(
                    fontFamily: Const.aventaBold,
                    fontSize: 14,
                    //78 81 100
                    color: Color.fromARGB(255, 78, 81, 100),

                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 10,),
            EditText(context: context,
              hintText: 'Account Holder Name',
              textInputAction: TextInputAction.next,
              controller: accountHolderController,
              setEnable: isButtonEnable,
              validator: validateAccountHolderNmae,
              onChange: (text) {
                bankName = text;
              },
              onSaved: (val) {
                bankName = val;
              },
              currentFocus: bankNameFocus,
              nextFocus: routingFocus,
            ),
            SizedBox(height: 15,),
            if (isButtonEnable == true)
              EditText(context: context,
                hintText: 'Routing Number',
                validator: validateRoutingNumber,
                textInputAction: TextInputAction.next,
                textInputType: TextInputType.number,
                //textInputType:  TextInputType.numberWithOptions(signed: true, decimal: true),
                currentFocus: routingFocus,
                nextFocus: accountFocus,
                onChange: (text) {
                  routingNo = text;
                },
                onSaved: (val) {
                  routingNo = val;
                },

              ),
            if (isButtonEnable == true)
              SizedBox(height: 15,),
            EditText(context: context,
              hintText: 'Bank Account Number',
              validator: validateAccountNumber,
              controller: accountNumberController,
              setEnable:isButtonEnable ,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.number,
              //textInputType: TextInputType.numberWithOptions(signed: true, decimal: true),
              currentFocus: accountFocus,
              onChange: (text) {
                accountNo = text;
              },
              onSaved: (val) {
                accountNo = val;
              },
            ),

            // Spacer(),
            SizedBox(height: 50,),
            if (isButtonEnable == true)
              CustomButton(onPressed: (){
                addBankToken();
              },

                btnText: 'SAVE',
                width: MediaQuery.of(context).size.width,
              ),


          ],
        ),
      ),

    );
  }
}
