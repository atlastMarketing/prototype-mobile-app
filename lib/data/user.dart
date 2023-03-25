import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/user_model.dart';

class UserStore extends ChangeNotifier {
  /// Private state
  String _id = "";
  String _email = "";
  String _businessName = "";
  String _businessType = "";
  String _businessIndustry = "";
  String _businessDescription = "";

  // TODO: move app logic settings elswhere
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
        businessDescription: _businessDescription,
      );

  /// Setters
  void setIsOnboarded(bool newState) {
    _isOnboarded = newState;
    notifyListeners();
  }

  void save(
    String id, {
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
    String? businessDescription,
  }) {
    _id = id;
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    _businessDescription = businessDescription ?? _businessDescription;
    notifyListeners();
  }

  void clear() {
    _id = "";
    _email = "";
    _businessName = "";
    _businessType = "";
    _businessIndustry = "";
    _businessDescription = "";
    _isOnboarded = false;
    notifyListeners();
  }

  void update({
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
    String? businessDescription,
  }) {
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    _businessDescription = businessDescription ?? _businessDescription;
    notifyListeners();
  }
}
