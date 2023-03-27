import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/content_model.dart';

class ScheduledPostsStore extends ChangeNotifier {
  /// Private state
  final Map<String, PostContent> _posts = {};

  /// Getters
  UnmodifiableListView<PostContent> get posts =>
      UnmodifiableListView(_posts.values.toList()
        ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!)));

  PostContent? postById(String postId) => _posts[postId];

  /// Setters
  void add(List<PostContent> newPosts) {
    for (PostContent post in newPosts) {
      _posts[post.id] = post;
    }
    notifyListeners();
  }

  void update(PostContent post) {
    _posts[post.id] = post;
    notifyListeners();
  }

  void remove(String postId) {
    _posts.remove(postId);
    notifyListeners();
  }

  void removeAll() {
    _posts.clear();
    notifyListeners();
  }
}
