import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_9.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';

import '../Extensions/Externsions.dart';
import '../Extensions/colors_utils.dart';
import '../Extensions/font_utils.dart';
import '../Models/ChatModel.dart';
import '../Models/MessageListModel.dart';
import '../Models/User.dart';
import '../Utils/BaseModel.dart';
import '../Utils/Prefs.dart';
import '../Utils/SimpleEditTextField.dart';
import '../Utils/socket_sessions.dart';
import 'chats_bubbles.dart';

class ChatScreen extends StatefulWidget {
  // var img;
  // var name;
  String user_name;
  String chat_Room_id;
  int other_id;

  MessageListModel? messageListModel;

  ChatScreen({Key? key, required this.user_name , required this.other_id, required  this.chat_Room_id, this.messageListModel}) : super(key: key);



  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  TextEditingController MessageTextController = TextEditingController();
  List<ChatModel> messages = [];
  User? user;
  final ScrollController listScrollController = ScrollController();

  _scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      LoadChatHistory(
        chat_id: widget.chat_Room_id,
        last_record_id: messages.last.id.toString(),
        onSuccess: (BaseModel baseModel) {
          if (mounted) {
            setState(() {
              List<ChatModel> dublicateList = (baseModel.data as List).map((
                  e) => ChatModel.fromJson(e)).toList();
              messages.addAll(dublicateList);
            });
          }
        },
        onError: (String error) {
          showToast("No Conversation Found");
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ConnectSocket(onSuccess: (success) {}, onError: (error) {});
        LoadChatHistory(
          chat_id: widget.chat_Room_id,
          last_record_id: messages.last.id.toString(),
          onSuccess: (BaseModel baseModel) {
            if (mounted) {
              setState(() {
                List<ChatModel> dublicateList = (baseModel.data as List).map((
                    e) => ChatModel.fromJson(e)).toList();
                messages.addAll(dublicateList);
              });
            }
          },
          onError: (String error) {
            showToast("No Conversation Found");
          },
        );
        break;
      case AppLifecycleState.inactive:
        LeaveChat(chat_id: int.parse(widget.chat_Room_id), onSuccess: (data) {
          toast(data.message);
          hideLoading();
        }, onError: (error) {
          toast(error);
          hideLoading();
        });
        break;
      case AppLifecycleState.paused:

        break;
      case AppLifecycleState.detached:

        break;
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });

    listScrollController.addListener(_scrollListener);


    Prefs.getUser((u) {
      if (mounted)
        setState(() {
          this.user = u;
        });
    });


    LoadChatHistory(
      chat_id: widget.chat_Room_id,
      onSuccess: (BaseModel baseModel) {
        if(mounted) {
          setState(() {

            messages = (baseModel.data as List)
                .map((e) => ChatModel.fromJson(e))
                .toList();

            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              listScrollController.animateTo(
                  listScrollController.position.maxScrollExtent,
                  duration: Duration(milliseconds: 0), curve: Curves.easeIn);
            });
          });
        }
      },
      onError: (String error) {
        showToast("No Conversation Found");
      },
    );

    RecieveMessage(
      onSuccess: (BaseModel baseModel) {
        LoadChatHistory(
          chat_id: widget.chat_Room_id,
          onSuccess: (BaseModel baseModel) {
            if(mounted) {
              setState(() {

                messages = (baseModel.data as List)
                    .map((e) => ChatModel.fromJson(e))
                    .toList();
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                });
              });
            }
          },
          onError: (String error) {
            showToast("No Conversation Found");
          },
        );
        setState(() {
          ChatModel message = ChatModel.fromJson(baseModel.data);
          List<ChatModel> dublicateList = messages.reversed.toList();
          dublicateList.add(message);
          messages = dublicateList.reversed.toList();
        });
      },
      onError: (String error) {
        showToast("No Conversation Found");
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorUtils.background,
        appBar: AppBar(
          backgroundColor: ColorUtils.background,
          elevation: 0,
          leading: IconButton(
            icon: SizedBox(
                width: 30.w,
                height: 30.w,
                child: Image.asset(
                  "src/backimg@3x.png",
                  fit: BoxFit.cover,
                )),
            onPressed: () {
              Navigator.of(context).pop("back");
              LeaveChat(chat_id: int.parse(widget.chat_Room_id), onSuccess: (data) {
                toast(data.message);
                hideLoading();
              }, onError: (error) {
                toast(error);
                hideLoading();
              });
            },
          ),
          titleSpacing: -7,
          title: Text(
            widget.user_name ?? "",
            style: TextStyle(
                color: ColorUtils.slate,
                fontFamily: FontUtils.aventaBold,
                fontSize: 18.sp),
          ),
          centerTitle: false,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: messages.length,
                    controller: listScrollController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? false : true,
                            child: getReceiverView(
                                clipper: ChatBubbleClipper9(
                                    type: BubbleType.receiverBubble),
                                context: context,
                                text:
                                messages[index].message),
                          ),
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? false : true,
                            child: SizedBox(
                              height: 2,
                            ),
                          ),
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? false : true,
                            child: Row(
                              children: [
                                Text(
                                  timeAgoSinceDate(messages[index].createdAt.toString()),
                                  style: TextStyle(
                                      color: ColorUtils.txtColor.withOpacity(0.6),
                                      fontSize: 12.sp,
                                      fontFamily: FontUtils.gibsonzRegular),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? true : false,
                            child: getSenderView(
                                clipper:
                                ChatBubbleClipper9(type: BubbleType.sendBubble),
                                context: context,
                                text:
                                messages[index].message),
                          ),
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? true : false,
                            child: SizedBox(
                              height: 2,
                            ),
                          ),
                          Visibility(
                            visible: messages[index].userId.toString() == user!.id.toString() ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  timeAgoSinceDate(messages[index].createdAt.toString()),
                                  style: TextStyle(
                                      color: ColorUtils.txtColor.withOpacity(0.6),
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  messages[index].isRead == 0 ? "src/doubletick_grey.png" : "src/doubletick.png" ,
                                  height: 8,
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: FontUtils.side_padding,
                    left: FontUtils.side_padding,
                    bottom: 5.h),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SimpleEditText(
                            context: context,
                            controller: MessageTextController,
                            hintText: 'Write Here....',
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            // suffixIcon: "src/camera_image.png",
                            onSaved: (text) {
                              // email = text;
                            },
                            onChange: (text) {
                              // email = text;
                            },
                            onFieldSubmitted: (text){
                              if(text.trim().isEmpty){
                                showToast("Nothing to send");
                              }
                              else{
                                if (MessageTextController.text.trim() == "" ) {
                                  showToast("Nothing to send");
                                }else {
                                  ConnectSocket(onSuccess: (success) {
                                    SendMessage(
                                      chat_id: widget.chat_Room_id,
                                      otherid: widget.other_id,
                                      message: MessageTextController.text.trim(),
                                      type: "text",
                                      onSuccess: (BaseModel baseModel) {
                                      },
                                      onError: (String error) {},
                                    );

                                    if(mounted) {
                                      setState(() {
                                        MessageTextController.text = "";
                                      });
                                    }
                                  }, onError: (error) {
                                    toast(error);
                                  });

                                }

                              }

                            },
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {
                            if (MessageTextController.text.trim() == "" ) {

                            }else {
                              ConnectSocket(onSuccess: (success) {

                                SendMessage(
                                  chat_id: widget.chat_Room_id,
                                  otherid: widget.other_id,
                                  message: MessageTextController.text.trim(),
                                  type: "text",
                                  onSuccess: (BaseModel baseModel) {

                                  },
                                  onError: (String error) {},
                                );

                                if(mounted) {
                                  setState(() {
                                    MessageTextController.text = "";
                                  });
                                }
                              }, onError: (error){
                                toast(error);
                              });
                            }

                          },
                          child: SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: Image.asset(
                              "src/SendbtnMsg@3x.png",
                              fit: BoxFit.contain,
                              scale: 2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
