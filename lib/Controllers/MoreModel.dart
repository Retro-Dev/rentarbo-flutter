enum MoreType { tnc, privacy, faqs, contact }

class MoreModel {
  String title;
  String iconName;
  MoreType type;

  MoreModel({required this.title, required this.iconName, required this.type});
}