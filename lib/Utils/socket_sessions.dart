
import 'package:oktoast/oktoast.dart';
import 'package:rentarbo_flutter/Utils/utils.dart';
import 'package:rentarbo_flutter/View/views.dart';

import '../Models/MessageListModel.dart';
import '../Models/User.dart';
import '../Utils/string_utils.dart';
import 'BaseModel.dart';
import 'Prefs.dart';
import 'package:socket_io_client/socket_io_client.dart';

String baseUrl = StringUtils.SOCKET_URL;
Socket sharedinstance = io(baseUrl);

Future<void> ConnectSocket({
  required Function(bool connected) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  String? authToken =
  user != null && user.apiToken != null && user.apiToken!.isNotEmpty
      ? user.apiToken!
      : null;
  var headers = {
    "Authorization": authToken,
    "device_token": user?.deviceToken,
    "device_type": user?.deviceType
  };
  Socket socket = io(baseUrl, <String, dynamic>{
    'autoConnect': true,
    'transports': ['websocket'],
    'query': headers
  });

  if(socket.connected == true){
    sharedinstance = socket;
    onSuccess(true);
  }
  else{
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
      sharedinstance = socket;
      onSuccess(true);
    });
    socket.onConnectError((err){
      print(err);
      onError(err.toString());
    });
    socket.onError((err){
      print(err);

      onError(err.toString());
    });
  }
}

Future<void> JoinSocket({
  required Function(bool connected) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  var map = {
    "id": user?.id
  };
  sharedinstance.emitWithAck(StringUtils.JOIN_SOCKET, map, ack: (data) {
    print('ack $data') ;
    if (data != null) {
      print('from server $data');
      onSuccess(true);
    } else {
      print("Null") ;
      onError(false.toString());
    }
  });
}


Future<void> GetChatList({
  required Function(List<MessageListModel> messagesList) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  var map = {
    "user_id": user?.id
  };
  sharedinstance.emitWithAck(StringUtils.GET_CHAT_EMIT, map, ack: (data) {
    print('ack $data') ;
    if (data != null) {
      var DATA = BaseModel.fromJson(data);
      List<MessageListModel> messagesList =  (DATA.data as List).map((e) => MessageListModel.fromJson(e)).toList() ;
      onSuccess(messagesList);
      print('from server $data');
    } else {
      print("Null") ;
      onError("ERROR");
      hideLoading();
    }
  });
}

Future<void> LoadChatHistory({
  required String chat_id,
  String? last_record_id,
  required Function(BaseModel baseModel) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  var map = {
    "user_id": user?.id,
    "chat_room_id": chat_id,
    if(last_record_id != null) "last_record_id": last_record_id
  };
  sharedinstance.emitWithAck(StringUtils.CHAT_HISTORY, map, ack: (data) {
    print('ack $data') ;
    if (data != null) {
      BaseModel baseModel = BaseModel.fromJson(data);
      onSuccess(baseModel);
      print('from server $data');
    } else {
      print("Null") ;
      onError("ERROR");
      hideLoading();
    }
  });
}

Future<void> SendMessage({
  required String chat_id,
  required String message,
  required String type,
  required int otherid,
  required Function(BaseModel data) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  print("<><><><><><><><><>Message<><><><><><><>>");
  print(message.isEmpty);
  print("<><><><><><><><><>Message<><><><><><><>>");
  var map = {
    "user_id": user?.id,
    "chat_room_id": chat_id,
    "target_id" : otherid,
    "message": message,
    "message_type": type
  };
  print(map);
  if (message.isNotEmpty) {
    sharedinstance.emit(StringUtils.SEND_MESSAGE, map);
  }else {
    // showToast("Nothing to send");
  }

  // sharedinstance.on(StringUtils.RECIEVE_MESSAGE, (data){
  //   print('ack $data') ;
  //   if (data != null) {
  //     BaseModel baseModel = BaseModel.fromJson(data);
  //     onSuccess(baseModel);
  //   } else {
  //     print("Null") ;
  //     onError("ERROR");
  //   }
  // });

}

Future<void> LeaveChat({

  required int chat_id,
  required Function(BaseModel data) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  var map = {
    "user_id": user?.id,
    "chat_room_id": chat_id,
  };
  print(map);
  sharedinstance.emit(StringUtils.LEAVECHAT, map);
  // sharedinstance.on(StringUtils.RECIEVE_MESSAGE, (data){
  //   print('ack $data') ;
  //   if (data != null) {
  //     BaseModel baseModel = BaseModel.fromJson(data);
  //     onSuccess(baseModel);
  //   } else {
  //     print("Null") ;
  //     onError("ERROR");
  //   }
  // });

}

Future<void> RecieveMessage({
  required Function(BaseModel data) onSuccess,
  required Function(String error) onError}) async {

  User? user = (await Prefs.getUserSync());
  sharedinstance.on(StringUtils.RECIEVE_MESSAGE, (data){
    print('ack $data') ;
    if (data != null) {
      BaseModel baseModel = BaseModel.fromJson(data);
      onSuccess(baseModel);
      print('from server $data');
    } else {
      print("Null") ;
      onError("ERROR");
      hideLoading();
    }
  });
}
