enum RentalButtonType { viewStatus, requests, details, delete }

class RentalItemModel {
  String title;
  String subtitle;
  String displayPrice;
  String displayImage;
  RentalButtonType buttonType;

  RentalItemModel({
    required this.title,
    required this.subtitle,
    required this.displayPrice,
    required this.displayImage,
    required this.buttonType,
  });
}
