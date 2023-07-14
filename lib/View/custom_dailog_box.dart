import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../View/views.dart';

import '../Utils/utils.dart';
import '../Utils/Const.dart';

String? makeOfferValue ;
AlertDialog Alert({title: String, content: String, context: BuildContext ,required Function(String value) CallBack}) {
  return AlertDialog(
    title: Stack(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            title,

            style: TextStyle(
                fontFamily: 'Gibson-SemiBold',
                fontSize: 22,
                color: Color.fromRGBO(69, 79, 99, 1.0)),
            textAlign: TextAlign.center,
          ),
        ),

        // Spacer(),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 12,
              child: Image.asset(
                'src/closebtn@3x.png',
                scale: 2.0,
              ),
            ),
          ),
        ),
      ],
    ),
    content: Container(
      // height: 230,
      width: 360,
      child: TextFormField(

        onChanged: (value)
        {
          makeOfferValue = value;
        },
        onSaved: (value)
        {
          makeOfferValue = value;
        },
        keyboardType: TextInputType.number,



        decoration: InputDecoration(


          // 240 240 240
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 0),
              borderRadius: BorderRadius.circular(18),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 0),
              borderRadius: BorderRadius.circular(18),
            ),
            // 120 132 158

            fillColor: Color.fromRGBO(240, 240, 240, 1.0),
            filled: true,
            hintText: '\$',
            // contentPadding: const EdgeInsets.all(15),
            border: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromRGBO(120, 132, 158, 1.0), width: 0),
                borderRadius: BorderRadius.circular(18))),
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(11),
    ),
    actions: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: MyButtonWithgradient(
              text: 'SUBMIT',
              //245 175 25  ,  241 39 17
              width: 180,
              startColor: Color.fromARGB(255, 245, 175, 25),
              endColor: Color.fromARGB(255, 241, 39, 17),
              onPress: () {
                if (makeOfferValue != "")
                {
                  CallBack(makeOfferValue ?? '');
                }
                else
                {
                  toast("Please add amount");
                }

              },
            ),
          ),
        ],
      )
    ],
  );
}

AlertDialog AlertYesNo({title : String , content : String , context : BuildContext , Callback : Void }){
  return AlertDialog(
    title: Text(title , style: TextStyle(fontFamily: 'Gibson-SemiBold' , fontSize: 20 , color: Colors.black),textAlign: TextAlign.center,),
    content: Container(
      width: 343,
      child: Text(content , style: TextStyle(fontFamily: 'Gibson-Regular' , fontSize: 14 , color: Colors.black),textAlign: TextAlign.center,),
    ), shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(11),
  ),
    actions: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: MyButtonWithgradient(
              text: 'YES',
              height: 50,
              //245 175 25  ,  241 39 17
              width: 125,//255 55 33 \\199 19 0
              startColor: Color.fromARGB(255, 255, 55, 33),
              endColor: Color.fromARGB(255, 199, 19, 0),
              onPress: Callback,
            ),
          ),
          SizedBox(width: 12,),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: MyButtonWithgradient(
              text: 'NO',
              //245 175 25  ,  241 39 17 \\69 79 99
              width: 125,
              height: 50,
              startColor: Color.fromARGB(255, 69, 79, 99),
              endColor: Color.fromARGB(255, 69, 79, 99),
              onPress: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ),
        ],
      )
    ],


  );

}

Container AlertDone({img : String , heading : String,msg : String , context : BuildContext }){
  return Container(
    width: double.infinity,
    height: double.infinity,//54 62 81
    color: Color.fromRGBO(54, 62, 81, 0.5),
    child: GestureDetector(
      onTap: () {
        // Navigator.of(context, rootNavigator: true).pop();

      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(img , scale: 2.5,),
          SizedBox(height: 22.1,),
          Text(heading , style: TextStyle(fontFamily: 'Gibson-SemiBold' , fontSize: 17 ,color: Colors.white),),
          SizedBox(height: 16.6,),
          Text(msg,style: TextStyle(fontFamily: 'Gibson-Regular' , fontSize: 12 ,color: Colors.white),textAlign: TextAlign.center,),
        ],
      ),
    ),
  );
}