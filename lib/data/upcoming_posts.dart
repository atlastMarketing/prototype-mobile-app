import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:atlast_mobile_app/models/content_model.dart';

class UpcomingPostsStore extends ChangeNotifier {
  /// Private state
  final Map<int, PostContent> _posts = {
    0: PostContent(
      id: 0,
      dateTime: "2023-05-11T19:00:00-08:00",
      caption:
          "Looking for a way to brighten up your day? ☀️ Check out Picard’s Flowers where we have a wide variety of beautiful flowers lorem ipsum lorem ipsum lorem ipsum",
      imageUrl: "https://i.imgur.com/eHnCdZi.png",
    ),
    1: PostContent(
      id: 1,
      dateTime: "2023-05-12T19:00:00-08:00",
      caption:
          "Have you seen the new blossoms in store? Come and indulge in a floral paradise that will take your breath away 🌸🌺...",
      imageUrl: "https://i.imgur.com/rLYuuLJ.png",
    )
  };
  int _runningId = 0;

  /// Getters
  UnmodifiableListView<PostContent> get posts =>
      UnmodifiableListView(_posts.values);

  /// Setters
  void add(ContentData contentData) {
    _runningId += 1;
    PostContent newPost = PostContent(
      id: _runningId,
      dateTime: contentData.dateTime,
    );
    _posts.addAll({_runningId: newPost});
    notifyListeners();
  }

  void remove(int postId) {
    _posts.remove(postId);
    notifyListeners();
  }

  void removeAll() {
    _posts.clear();
    notifyListeners();
  }
}
