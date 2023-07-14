enum SettingType { changeCategory,changePassword, notification }

class SettingsModel {
  String title;
  String iconName;
  SettingType type;

  SettingsModel(
      {required this.title, required this.iconName, required this.type});
}
