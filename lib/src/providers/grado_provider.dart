import 'package:flutter/foundation.dart';

class GradoProvider with ChangeNotifier {
   String _grado = '';
   String _idGrado = '';
  String get idGrado => _idGrado;
  String get grado => _grado;
  set grado(String v) {
    _grado = v;
    notifyListeners();
  }
  set idGrado(String v) {
    _idGrado = v;
    notifyListeners();
  }
}
