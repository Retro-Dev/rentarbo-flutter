import 'package:flutter/material.dart';


class OtherRequestsViewModel{
  List<OtherRequestModel> _requestModels = [
    OtherRequestModel(
        userName: "Keanu Sullivan",
        title: "Rent for 2 hours",
        userDp: "dp-1.png"),
    OtherRequestModel(
        userName: "Martha Diaz", title: "Rent for 6 hours", userDp: "dp-1.png")
  ];

  int getRequestsCount() {
    return _requestModels.length;
  }

  String getUserNameFor(int index) {
    return _requestModels[index].userName;
  }

  String getUserDpFor(int index) {
    return _requestModels[index].userDp;
  }

  String getTitleFor(int index) {
    return _requestModels[index].title;
  }
}


class OtherRequestModel {
  String userName;
  String title;
  String userDp;

  OtherRequestModel(
      {required this.userName, required this.title, required this.userDp});
}
