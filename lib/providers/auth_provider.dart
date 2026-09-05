import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAccept = false;
  bool get isAccept => _isAccept;
  void toggleIsAccept() {
    _isAccept = !_isAccept;
    notifyListeners();
  }

  bool _isChangeOldPass = true;
  bool get isChangeOldPass => _isChangeOldPass;
  void toggleChangeOldPass() {
    _isChangeOldPass = !_isChangeOldPass;
    notifyListeners();
  }

  bool _isChangeNewPass = true;
  bool get isChangeNewPass => _isChangeNewPass;
  void toggleChangeNewPass() {
    _isChangeNewPass = !_isChangeNewPass;
    notifyListeners();
  }
}
