import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Extensions/Externsions.dart';
import '../Extensions/colors_utils.dart';
import '../Extensions/font_utils.dart';
import '../Models/MessageListModel.dart';
import '../Models/User.dart';
import '../Utils/Prefs.dart';
import '../Utils/SimpleEditTextField.dart';
import '../Utils/socket_sessions.dart';
import '../Utils/string_utils.dart';
import '../Utils/utils.dart';
import 'ChatScreen.dart';


class InboxTab extends StatefulWidget {
  static const route = 'InboxTab';
  var user;
  InboxTab({Key? key, this.user}) : super(key: key);

  @override
  State<InboxTab> createState() => _InboxTabState();
}

class _InboxTabState extends State<InboxTab> {

  List<MessageListModel> messageList = [];
  List<MessageListModel> filteredmessageList = [];
  FocusNode searchFocus = FocusNode();
  User? user;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  TextEditingController searchTextController = TextEditingController();
  String? search;

  @override
  void initState() {
    super.initState();
    Prefs.getUser((u) {
      if (mounted) {
        setState(() {
          this.user = u;

          loadChatList();
        });
      }
    });
  }


  void _onRefresh() async{

    loadChatList();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    _refreshController.loadComplete();
  }

  void loadChatList(){
    showLoading();
    messageList = [];
    filteredmessageList = [];
    GetChatList(
        onSuccess: (List<MessageListModel> messagesList) {
          setState(() {
            hideLoading();
            messageList = messagesList;
            filteredmessageList = messagesList;
          });

        },
        onError: (String error) {
          hideLoading();
          showToast("No Conversation Found");
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: ColorUtils.background,
        appBar: AppBar(
          backgroundColor:ColorUtils.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(StringUtils.Messages,
            style: TextStyle(color: ColorUtils.slate , fontFamily: FontUtils.aventaBold , fontSize: 18.sp),),
          centerTitle: false,
        ),
        body: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: Container(
              decoration: BoxDecoration(color: ColorUtils.background),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.only(top: 0.h, bottom: 5.h),
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.h, bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 14.w, left: 14.w,),
                          child: SimpleEditText(
                            // controller: searchTextController,
                            context: context
                            ,hintText: 'Search',
                            borderColor: Colors.transparent,
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            currentFocus: searchFocus,
                            prefixIcon:"src/searchIcon@2x.png",
                            isFilled: true,
                            filledColor: Color(0x0f0a3746),
                            onSaved: (text){

                            },
                            onFieldSubmitted: (value){
                              print("value LENGTH");
                              print(value.length.toString());
                              if(value.length > 2){
                                search = value;
                                filterSearchResults(value);
                              }
                              else{

                                loadChatList();
                              }
                            },
                            onChange: (text){
                              print("TEXT LENGTH");
                              print(text!.length.toString());
                              if(text.length > 1){
                                search = text;
                                filterSearchResults(search!);
                              }
                              else{
                                loadChatList();

                              }

                            },
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w, left: 10.w,),
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  color: ColorUtils.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  child: ListTile(
                                    visualDensity: VisualDensity(horizontal: -3, vertical: -1.5),
                                    onTap: (){
                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(builder: (context) =>
                                          ChatScreen(chat_Room_id: filteredmessageList[index].id.toString(),user_name: filteredmessageList[index].targetUserData!.name.toString(), other_id: filteredmessageList[index].targetUserData!.id!,),))
                                          .then((value){


                                             loadChatList();


                                      });
                                      // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => ChatScreen(img: messageData[index]["img"], name: messageData[index]["name"],),));
                                    },
                                    contentPadding: EdgeInsets.symmetric(vertical: 3.h,horizontal: 14.w),
                                    leading: CircleAvatar(maxRadius: 20,minRadius: 20,
                                      // foregroundImage:AssetImage(messageList[index].targetUserData!.imageUrl ?? ""),
                                      foregroundImage: Image.network(filteredmessageList[index].targetUserData!.imageUrl ?? "").image,
                                    ),
                                    title: Text(filteredmessageList[index].targetUserData!.name ?? "",
                                      style: TextStyle(
                                          fontFamily: FontUtils.aventaBold,
                                          fontSize: 15 .sp,
                                          color: ColorUtils.slate),
                                    ),
                                    subtitle: Text(filteredmessageList[index].lastChatMessage?.message ?? "",
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontFamily: FontUtils.aventaSemiBold,
                                          fontSize: 11.sp,
                                          color: ColorUtils.slate.withOpacity(0.8)),),
                                    trailing: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 1.w),
                                          child: Text(
                                            filteredmessageList[index].lastMessageTimestamp != null ? timeAgoSinceDate(filteredmessageList[index].lastMessageTimestamp.toString()) : "",
                                            style: TextStyle(
                                                fontFamily: FontUtils.aventaSemiBold,
                                                fontSize: 10.sp,
                                                color: ColorUtils.slate.withOpacity(0.5)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: Visibility(
                                            visible: filteredmessageList[index].lastChatMessage?.userId != user!.id &&
                                                filteredmessageList[index].unreadMessageCounts != null && filteredmessageList[index].unreadMessageCounts! > 0
                                                && filteredmessageList[index].lastChatMessage != null
                                                ? true
                                                : false,
                                            child: Container(
                                              height: 18.h,
                                              width: 20.w,
                                              decoration: BoxDecoration(
                                                  color: ColorUtils.noti_yellow,
                                                  borderRadius: BorderRadius.circular(100)
                                              ),
                                              child: Center(child: Text(filteredmessageList[index].unreadMessageCounts.toString() ?? "",
                                                  style: TextStyle(
                                                      fontFamily: FontUtils.gibsonSemiBold,
                                                      fontSize: 9,
                                                      color: ColorUtils.white))),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 3.h),
                              itemCount: filteredmessageList.length),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }



  void filterSearchResults(String query) {
    List<MessageListModel> dummySearchList = [];
    dummySearchList.addAll(filteredmessageList);
    if(query.isNotEmpty) {
      List<MessageListModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.targetUserData!.name!.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredmessageList.clear();
        messageList.clear();
        filteredmessageList.addAll(dummyListData);
      });
      return;
    } else {
      loadChatList();
    }
  }
}
