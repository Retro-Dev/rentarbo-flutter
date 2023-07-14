
import "package:collection/collection.dart";

class NotificationModel {
  String userDp;
  String userName;
  String title;
  bool isNew;
  String displayTime;
  String group;

  NotificationModel(
      {required this.userDp,
        required this.userName,
        required this.title,
        required this.isNew,
        required this.displayTime,
        required this.group});
}


class NotificationViewModel {
  late List<NotificationModel> _notificationModels;
  late Map<dynamic, List<NotificationModel>> _notificationMap;

  setDataNotification() {
    _notificationModels = [NotificationModel(
        userDp: "dp-2.png",
        userName: "Eric John",
        title: "has posted a photos on your fanwall, please view details",
        isNew: true,
        displayTime: "2m",
        group: "Today"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: true,
    displayTime: "5m",
    group: "Today"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: false,
    displayTime: "12m",
    group: "Today"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: true,
    displayTime: "28h",
    group: "Yesterday"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: true,
    displayTime: "28h",
    group: "Yesterday"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: false,
    displayTime: "28h",
    group: "Yesterday"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: false,
    displayTime: "28h",
    group: "Yesterday"),
    NotificationModel(
    userDp: "dp-2.png",
    userName: "Eric John",
    title: "has posted a photos on your fanwall, please view details",
    isNew: false,
    displayTime: "28h",
    group: "Yesterday"),
    ];
  }

  NotificationViewModel() {

    _notificationModels = [NotificationModel(
        userDp: "dp-2.png",
        userName: "Eric John",
        title: "has posted a photos on your fanwall, please view details",
        isNew: true,
        displayTime: "2m",
        group: "Today"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: true,
          displayTime: "5m",
          group: "Today"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: false,
          displayTime: "12m",
          group: "Today"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: true,
          displayTime: "28h",
          group: "Yesterday"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: true,
          displayTime: "28h",
          group: "Yesterday"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: false,
          displayTime: "28h",
          group: "Yesterday"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: false,
          displayTime: "28h",
          group: "Yesterday"),
      NotificationModel(
          userDp: "dp-2.png",
          userName: "Eric John",
          title: "has posted a photos on your fanwall, please view details",
          isNew: false,
          displayTime: "28h",
          group: "Yesterday"),
    ];
    _notificationMap =
        _notificationModels.groupListsBy((element) => element.group);

    print(_notificationMap);
  }

  getElements() {
    return _notificationModels;
  }
}
