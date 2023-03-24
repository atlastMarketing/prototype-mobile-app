import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/content_model.dart';

class ScheduledPostsStore extends ChangeNotifier {
  /// Private state
  final List<PostContent> _posts = [];

  /// Getters
  UnmodifiableListView<PostContent> get posts => UnmodifiableListView(_posts);
  UnmodifiableListView<PostContent> get somePosts =>
      UnmodifiableListView(_posts.sublist(0, min(_posts.length, 5)));

  /// Setters
  void add(List<PostContent> newPosts) {
    _posts.addAll(newPosts);
    notifyListeners();
  }

  void remove(String postId) {
    _posts.removeWhere((p) => p.id == postId);
    notifyListeners();
  }

  void removeAll() {
    _posts.clear();
    notifyListeners();
  }
}
