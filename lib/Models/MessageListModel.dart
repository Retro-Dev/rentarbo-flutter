class MessageListModel {
  int? id;
  String? identifier;
  int? createdBy;
  String? title;
  String? slug;
  String? imageUrl;
  String? description;
  int? status;
  String? type;
  TargetUserData? targetUserData;
  int? memberLimit;
  String? lastMessageTimestamp;
  LastChatMessage? lastChatMessage;
  int? unreadMessageCounts;
  int? isAnonymous;
  String? createdAt;

  MessageListModel(
      {this.id,
        this.identifier,
        this.createdBy,
        this.title,
        this.slug,
        this.imageUrl,
        this.description,
        this.status,
        this.type,
        this.targetUserData,
        this.memberLimit,
        this.lastMessageTimestamp,
        this.lastChatMessage,
        this.unreadMessageCounts,
        this.isAnonymous,
        this.createdAt});

  MessageListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    identifier = json['identifier'];
    createdBy = json['created_by'];
    title = json['title'];
    slug = json['slug'];
    imageUrl = json['image_url'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    targetUserData = json['target_user_data'] != null
        ? new TargetUserData.fromJson(json['target_user_data'])
        : null;
    memberLimit = json['member_limit'];
    lastMessageTimestamp = json['last_message_timestamp'];
    lastChatMessage = json['last_chat_message'].toString() != "[]"
        ? new LastChatMessage.fromJson(json['last_chat_message'])
        : null;
    unreadMessageCounts = json['unread_message_counts'];
    isAnonymous = json['is_anonymous'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['identifier'] = this.identifier;
    data['created_by'] = this.createdBy;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['image_url'] = this.imageUrl;
    data['description'] = this.description;
    data['status'] = this.status;
    data['type'] = this.type;
    if (this.targetUserData != null) {
      data['target_user_data'] = this.targetUserData!.toJson();
    }
    data['member_limit'] = this.memberLimit;
    data['last_message_timestamp'] = this.lastMessageTimestamp;
    if (this.lastChatMessage != null) {
      data['last_chat_message'] = this.lastChatMessage!.toJson();
    }
    data['unread_message_counts'] = this.unreadMessageCounts;
    data['is_anonymous'] = this.isAnonymous;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class TargetUserData {
  int? id;
  String? name;
  String? imageUrl;
  String? onlineStatus;
  int? isAnonymous;

  TargetUserData(
      {this.id, this.name, this.imageUrl, this.onlineStatus, this.isAnonymous});

  TargetUserData.fromJson(Map<String, dynamic> json) {
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

class LastChatMessage {
  int? id;
  String? message;
  Null? fileUrl;
  Null? fileData;
  int? userId;
  String? messageType;
  int? isAnonymous;
  String? createdAt;

  LastChatMessage(
      {this.id,
        this.message,
        this.fileUrl,
        this.fileData,
        this.userId,
        this.messageType,
        this.isAnonymous,
        this.createdAt});

  LastChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    fileUrl = json['file_url'];
    fileData = json['file_data'];
    userId = json['user_id'];
    messageType = json['message_type'];
    isAnonymous = json['is_anonymous'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['file_url'] = this.fileUrl;
    data['file_data'] = this.fileData;
    data['user_id'] = this.userId;
    data['message_type'] = this.messageType;
    data['is_anonymous'] = this.isAnonymous;
    data['created_at'] = this.createdAt;
    return data;
  }
}