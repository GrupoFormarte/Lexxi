import 'package:flutter/material.dart';

class StateAppBarProvider with ChangeNotifier {
  bool _hidden = true;

  double _height = 368;
  double get height => _height;

  bool get hidden => _hidden;

  set height(double value) {
    _height = value;
    notifyListeners();
  }

  set hidden(bool value) {
    _hidden = value;
    notifyListeners();
  }
}
