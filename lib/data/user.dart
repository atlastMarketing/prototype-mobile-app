import 'package:flutter/material.dart';

class User {
  String id;
  String? email;
  String? businessName;
  String? businessType;
  String? businessIndustry;

  User({
    required this.id,
    this.email,
    this.businessName,
    this.businessType,
    this.businessIndustry,
  });
}

class UserModel extends ChangeNotifier {
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

  User get data => User(
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
