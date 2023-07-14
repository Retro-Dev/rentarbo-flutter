class InboxModel {
  String title;
  String subtitle;
  String displayPrice;
  String displayImage;
  int badgeCount;

  InboxModel(
      {required this.title,
        required this.subtitle,
        required this.displayPrice,
        required this.displayImage,
        required this.badgeCount});
}




class InboxDetailItemModel {
  String userName;
  String userDp;
  String title;
  String displayTime;
  bool seen;

  InboxDetailItemModel({required this.userName,
    required this.userDp,
    required this.title,
    required this.displayTime,
    required this.seen});
}

  class InboxDetailItemViewModel {

  List<InboxDetailItemModel> _inboxDetailItemModels = [
    InboxDetailItemModel(
        userName: "Marie Winter",
        userDp: "avatar-1.png",
        title:
        "Happiness is not something readymade. It comes from your own actions.",
        displayTime: "1 hr ago",
        seen: false),
    InboxDetailItemModel(
        userName: "Grant Marshall",
        userDp: "avatar-2.png",
        title:
        "Happiness is not something readymade. It comes from your own actions.",
        displayTime: "Yesterday",
        seen: true),
    InboxDetailItemModel(
        userName: "Duran Clayton",
        userDp: "avatar-3.png",
        title:
        "Happiness is not something readymade. It comes from your own actions.",
        displayTime: "22 July",
        seen: true),
    InboxDetailItemModel(
        userName: "Julia Petersen",
        userDp: "avatar-4.png",
        title:
        "Happiness is not something readymade. It comes from your own actions.",
        displayTime: "19 July",
        seen: true),
    InboxDetailItemModel(
        userName: "Burns Marks",
        userDp: "avatar-5.png",
        title:
        "Happiness is not something readymade. It comes from your own actions.",
        displayTime: "11 Apr",
        seen: true),
  ];

  int getInboxDetailItemsCount() {
    return _inboxDetailItemModels.length;
  }

  String getUserNameFor(int index) {
    return _inboxDetailItemModels[index].userName;
  }

  String getUserDpFor(int index) {
    return _inboxDetailItemModels[index].userDp;
  }

  String getTitleFor(int index) {
    return _inboxDetailItemModels[index].title;
  }

  String getDisplayTimeFor(int index) {
    return _inboxDetailItemModels[index].displayTime;
  }

  bool getSeenStatusFor(int index) {
    return _inboxDetailItemModels[index].seen;
  }
}

