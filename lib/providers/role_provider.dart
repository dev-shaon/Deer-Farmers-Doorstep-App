import 'package:flutter/material.dart';

enum UserRole { none, talent, fan }

class RoleProvider extends ChangeNotifier {
  UserRole _selectedRole = UserRole.none;

  UserRole get selectedRole => _selectedRole;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  bool get isTalent => _selectedRole == UserRole.talent;
  bool get isFan => _selectedRole == UserRole.fan;
}
