

import 'package:flutter/material.dart';

class MainVM extends ChangeNotifier {
  int pageIndex = 0;

  void changePageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }

}
