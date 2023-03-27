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
  String _businessVoice = "";
  String _businessUrl = "";
  String _avatarImageUrl = "";

  // TODO: move app logic settings elswhere
  bool _isOnboarded = false;
  bool _hasHelpPopups = true;

  /// Getters
  bool get isLoggedIn => _id != "";
  bool get isOnboarded => _isOnboarded;
  bool get hasHelpPopups => _hasHelpPopups;

  UserModel get data => UserModel(
        id: _id,
        email: _email,
        businessName: _businessName,
        businessType: _businessType,
        businessIndustry: _businessIndustry,
        businessDescription: _businessDescription,
        businessVoice: _businessVoice,
        businessUrl: _businessUrl,
        avatarImageUrl: _avatarImageUrl,
      );

  /// Setters
  void setIsOnboarded(bool newState) {
    _isOnboarded = newState;
    notifyListeners();
  }

  void setHasHelpPopups(bool newState) {
    _hasHelpPopups = newState;
    notifyListeners();
  }

  void save(
    String id, {
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
    String? businessDescription,
    String? businessVoice,
    String? businessUrl,
    String? avatarImageUrl,
  }) {
    _id = id;
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    _businessDescription = businessDescription ?? _businessDescription;
    _businessVoice = businessVoice ?? _businessVoice;
    _businessUrl = businessUrl ?? _businessUrl;
    _avatarImageUrl = avatarImageUrl ?? _avatarImageUrl;
    notifyListeners();
  }

  void clear() {
    _id = "";
    _email = "";
    _businessName = "";
    _businessType = "";
    _businessIndustry = "";
    _businessDescription = "";
    _businessVoice = "";
    _avatarImageUrl = "";
    _businessUrl = "";
    _isOnboarded = false;
    notifyListeners();
  }

  void update({
    String? email,
    String? businessName,
    String? businessType,
    String? businessIndustry,
    String? businessDescription,
    String? businessVoice,
    String? businessUrl,
    String? avatarImageUrl,
  }) {
    _email = email ?? _email;
    _businessName = businessName ?? _businessName;
    _businessType = businessType ?? _businessType;
    _businessIndustry = businessIndustry ?? _businessIndustry;
    _businessDescription = businessDescription ?? _businessDescription;
    _businessVoice = businessVoice ?? _businessVoice;
    _businessUrl = businessUrl ?? _businessUrl;
    _avatarImageUrl = avatarImageUrl ?? _avatarImageUrl;
    notifyListeners();
  }
}
