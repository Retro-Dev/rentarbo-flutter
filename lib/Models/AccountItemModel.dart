enum AccountItemType {
  rentalRequests,
  myAds,
  myRentalPosted,
  returnStatus,
  myEarning,
  paymentDetails,
  payout,
  settings,
  disputeManagement,
  logout
}

class AccountItemModel {
  String title;
  String iconName;
  AccountItemType type;

  AccountItemModel(
      {required this.title, required this.iconName, required this.type});
}
