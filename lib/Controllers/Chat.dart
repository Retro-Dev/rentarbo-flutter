import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Models/InboxDetailViewModel.dart';

import '../Extensions/style.dart';
import '../Models/NotificationModel.dart';
// import 'package:grouped_list/grouped_list.dart';

class Chat extends StatefulWidget {
  static const String route = "Chat";

  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

   int userOwn = 0;
   List<Widget> chatMessages = [
    const MyChatMessage(message: "hi", image: ""),
     const MyChatMessage(message: "how r u",image: ""),
   ];
   TextEditingController messageTxt = TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatMessages = chatMessages.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
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
          centerTitle: false,
          titleSpacing: 0,
          title: Text(
            "Marie Winter",
            style: Style.getBoldFont(18.sp, color: Style.textBlackColor),
          ),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(top: true, child: ChatDetailBody()),
        ));
  }

  Widget ChatDetailBody() {
    return getMessagesDetailView(context);
  }

  getMessagesDetailView(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ChatDetailChatListView(), ChatDetailViewFooter()]),
      ]),
    );
  }

  Widget returnMsg(int value){
    userOwn = value;
    if (userOwn == 1) {
      return  const MyChatMessage(message: "hello", image: "");
    }else {
      return const OtherChatMessage(message: "hi", image: "");
    }
  }

  sendMsg(int value){
    userOwn = value;
  }

  Widget ChatDetailChatListView() {
    return Expanded(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView.builder(
            reverse: true,
            itemCount: chatMessages.length,
            itemBuilder: (context, index) {
             return chatMessages[index];
            },
          ),
        ));
  }

  Widget ChatDetailViewFooter() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.w, color: const Color(0xFFF4F4F6)),
            ),
            color: Colors.white),
        height: 82.w,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: messageTxt,
                  textInputAction: TextInputAction.send,
                  autocorrect: false,
                  maxLines: null,
                  style:
                  Style.getRegularFont(14.sp, color: Style.textBlackColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    contentPadding: const EdgeInsets.all(10),
                    hintText: "Add comment …",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.w),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),

              onChanged: (value) {

              },
              onSubmitted: (value) {
                chatMessages.add( MyChatMessage(message: (value ?? "") , image: ""));
              },
              ),

            ),
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: () {
                chatMessages.add( MyChatMessage(message: (messageTxt.text ?? "") , image: ""));
                messageTxt.text = "";
               chatMessages = chatMessages.reversed.toList();
                    setState((){

                    });
              },
              child: SizedBox(
                width: 18.w,
                height: 16.w,
                child: Image.asset(Style.getIconImage("send-chat-icon@2x.png")),
              ),
            )
          ]),
        ),
      ),
    );
  }


}


class MyChatMessage extends StatelessWidget {
  final String message;
  final String image;

  const MyChatMessage({Key? key, required this.message, required this.image})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xFF707070).withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.w),
                          )),
                      child: Text(message,
                          style: Style.getRegularFont(14.sp,
                              color: const Color(0xFF454F63))),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ],
            ),
          ]),
    );
  }
}

class OtherChatMessage extends StatelessWidget {
  final String message;
  final String image;

  const OtherChatMessage({Key? key, required this.message, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                          color: const Color(0xFF363E51).withOpacity(0.6),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.w),
                          )),
                      child: Text(message,
                          style:
                          Style.getRegularFont(14.sp, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ]),
    );
  }
}
