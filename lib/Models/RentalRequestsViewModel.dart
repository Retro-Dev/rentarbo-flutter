import 'package:flutter/material.dart';

import 'RentalItemModel.dart';


class RentalRequestsViewModel {
  final List<RentalItemModel> _rentalItemModels = [
    RentalItemModel(
        title: "Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$120/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.viewStatus),
    RentalItemModel(
        title: "2019 Atlantic VX Jet Ski",
        subtitle: "Electric Vehicle",
        displayPrice: "\$110/hr",
        displayImage: "item-image.png",
        buttonType: RentalButtonType.viewStatus),
  ];

  int getInboxItemsCount() {
    return _rentalItemModels.length;
  }

  String getTitleFor(int index) {
    return _rentalItemModels[index].title;
  }

  String getSubtitleFor(int index) {
    return _rentalItemModels[index].subtitle;
  }

  String getDisplayPriceFor(int index) {
    return _rentalItemModels[index].displayPrice;
  }

  String getDisplayImageFor(int index) {
    return _rentalItemModels[index].displayImage;
  }

  RentalButtonType getButtonTypeFor(int index) {
    return _rentalItemModels[index].buttonType;
  }
}
