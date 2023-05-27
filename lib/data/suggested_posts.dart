import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/content_model.dart';

class SuggestedPostsStore extends ChangeNotifier {
  /// Private state
  final List<PostDraft> _collections = [];

  /// Getters
  UnmodifiableListView<PostDraft> get suggestions =>
      UnmodifiableListView(_collections);

  /// Setters
  void addCollections(List<PostDraft> newSuggestions) {
    _collections.addAll(newSuggestions);
    notifyListeners();
  }

  void remove(int postIdx) {
    _collections.removeAt(postIdx);
    notifyListeners();
  }

  void removeAll() {
    _collections.clear();
    notifyListeners();
  }
}
