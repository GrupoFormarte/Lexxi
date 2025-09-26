import 'package:flutter/foundation.dart';
import 'package:lexxi/src/global/models/auth/userViewModel.dart';

class DataUserProvider with ChangeNotifier {
  late ValueNotifier<UserViewModel> _userViewModel;

  ValueNotifier<UserViewModel> get userViewModel => _userViewModel;

  set userViewModel(user) {

    _userViewModel =
        ValueNotifier<UserViewModel>(UserViewModel.fromJson(user.toJson()));

    notifyListeners();
  }
}
