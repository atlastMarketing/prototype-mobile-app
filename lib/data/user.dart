import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/user_model.dart';

class UserStore extends ChangeNotifier {
  /// Private state
  String _id = "";
  String _email = "";
  String _businessName = "";
  String _businessType = "";
  String _businessIndustry = "";

  bool _isOnboarded = false;

  /// Getters
  bool get isLoggedIn => _id != "";
  bool get isOnboarded => _isOnboarded;

  UserModel get data => UserModel(
        id: _id,
        email: _email,
        businessName: _businessName,
        businessType: _businessType,
        businessIndustry: _businessIndustry,
      );

  /// Setters
  void setIsOnboarded(bool newState) {
    _isOnboarded = newState;
    notifyListeners();
  }

  void login(
    String id, {
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
  }) {
    _id = id;
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    notifyListeners();
  }

  void logout() {
    _id = "";
    _email = "";
    _businessName = "";
    _businessType = "";
    _businessIndustry = "";
    _isOnboarded = false;
    notifyListeners();
  }

  void updateUser({
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
  }) {
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    notifyListeners();
  }
}
