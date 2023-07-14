class ChatModel {
  int? id;
  int? chatRoomId;
  String? message;
  String? fileUrl;
  String? fileData;
  int? userId;
  String? messageType;
  UserData? userData;
  int? isAnonymous;
  int? isRead;
  String? createdAt;

  ChatModel(
      {this.id,
        this.chatRoomId,
        this.message,
        this.fileUrl,
        this.fileData,
        this.userId,
        this.messageType,
        this.userData,
        this.isAnonymous,
        this.isRead,
        this.createdAt});

  ChatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chatRoomId = json['chat_room_id'];
    message = json['message'];
    fileUrl = json['file_url'];
    fileData = json['file_data'];
    userId = json['user_id'];
    messageType = json['message_type'];
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
    isAnonymous = json['is_anonymous'];
    isRead = json['is_read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chat_room_id'] = this.chatRoomId;
    data['message'] = this.message;
    data['file_url'] = this.fileUrl;
    data['file_data'] = this.fileData;
    data['user_id'] = this.userId;
    data['message_type'] = this.messageType;
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    data['is_anonymous'] = this.isAnonymous;
    data['is_read'] = this.isRead;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? imageUrl;
  String? onlineStatus;
  int? isAnonymous;

  UserData(
      {this.id, this.name, this.imageUrl, this.onlineStatus, this.isAnonymous});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['image_url'];
    onlineStatus = json['online_status'];
    isAnonymous = json['is_anonymous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image_url'] = this.imageUrl;
    data['online_status'] = this.onlineStatus;
    data['is_anonymous'] = this.isAnonymous;
    return data;
  }
}