import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/content_model.dart';

class SuggestedPostsStore extends ChangeNotifier {
  /// Private state
  final List<List<PostDraft>> _collections = [];

  /// Getters
  UnmodifiableListView<List<PostDraft>> get suggestions =>
      UnmodifiableListView(_collections);

  /// Setters
  void addCollections(List<List<PostDraft>> newCollections) {
    _collections.addAll(newCollections);
    notifyListeners();
  }

  void removeAll() {
    _collections.clear();
    notifyListeners();
  }
}
