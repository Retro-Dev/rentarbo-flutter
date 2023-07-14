
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class OnboardingViewModel {
  List<OnboardingModel> _onboardingModels = [
    OnboardingModel(
        imageName: "onboarding-1@2x.png",
        imageSize: const Size(290, 225),
        caption: "Get access to the rental world with all you want to rent.",
        buttonCaption: "Next"),
    OnboardingModel(
        imageName: "onboarding-2@2x.png",
        imageSize: const Size(345, 225),
        caption: "Rent whatever you want in your nearby vicinity.",
        buttonCaption: "Next"),
    OnboardingModel(
        imageName: "onboarding-3@2x.png",
        imageSize: const Size(345, 225),
        caption: "Transparent process to make it the best platform",
        buttonCaption: "Get Started")
  ];


  int _currentIndex = 0;
  final PageController _pageController = PageController();

  int getCurrentIndex() {
    return _currentIndex;
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;

  }

  void changePage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);

  }

  PageController getController() {
    return _pageController;
  }

  String getImageNameFor(int index) {
    return _onboardingModels[index].imageName;
  }

  Size getImageSizeFor(int index) {
    return _onboardingModels[index].imageSize;
  }

  String getCaptionFor(int index) {
    return _onboardingModels[index].caption;
  }

  String getButtonCaptionFor(int index) {
    return _onboardingModels[index].buttonCaption;
  }
}




class OnboardingModel {
  String imageName;
  Size imageSize;
  String caption;
  String buttonCaption;

  OnboardingModel(
      {required this.imageName,
        required this.imageSize,
        required this.caption,
        required this.buttonCaption});
}
