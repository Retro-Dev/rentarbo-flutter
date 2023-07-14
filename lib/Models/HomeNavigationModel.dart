import 'package:flutter/material.dart';

class HomeNavigationViewModel {
  int _previousScreenIndex = 0;
  int currentScreenIndex = 0;


  getCurrentScreenIndex() {
    return currentScreenIndex;
  }

  setCurrentNavigation(int current){
    currentScreenIndex = current;
  }

  setPreviousScreenIndex(int previous){
    _previousScreenIndex = previous;
  }

  updateToPreviousScreen() {
    updateCurrentScreen(_previousScreenIndex);
  }

  updateCurrentScreen(int index) {
    currentScreenIndex = index;
    if (index != 2) {
      _previousScreenIndex = index;
    }
  }
}
