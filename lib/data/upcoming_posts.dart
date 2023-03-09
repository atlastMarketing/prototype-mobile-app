import 'dart:collection';

import 'package:flutter/material.dart';

class UpcomingPostData {
  String? dateTime;
  String? caption;
  String? imageUrl;

  UpcomingPostData({
    this.dateTime,
    this.caption,
    this.imageUrl,
  });
}

class UpcomingPost extends UpcomingPostData {
  int id;

  UpcomingPost({
    required this.id,
    dateTime,
    caption,
    imageUrl,
  }) : super(
          dateTime: dateTime,
          caption: caption,
          imageUrl: imageUrl,
        );
}

class UpcomingPostsModel extends ChangeNotifier {
  /// Private state
  final Map<int, UpcomingPost> _posts = {
    0: UpcomingPost(
      id: 0,
      dateTime: "2023-05-11T19:00:00-08:00",
      caption:
          "Looking for a way to brighten up your day? ☀️ Check out Picard’s Flowers where we have a wide variety of beautiful flowers lorem ipsum lorem ipsum lorem ipsum",
      imageUrl: "https://i.imgur.com/eHnCdZi.png",
    ),
    1: UpcomingPost(
      id: 1,
      dateTime: "2023-05-12T19:00:00-08:00",
      caption:
          "Have you seen the new blossoms in store? Come and indulge in a floral paradise that will take your breath away 🌸🌺...",
      imageUrl: "https://i.imgur.com/rLYuuLJ.png",
    )
  };
  int _runningId = 0;

  /// Getters
  UnmodifiableListView<UpcomingPost> get posts =>
      UnmodifiableListView(_posts.values);

  /// Setters
  void add(UpcomingPostData postData) {
    _runningId += 1;
    UpcomingPost newPost = UpcomingPost(
      id: _runningId,
      dateTime: postData.dateTime,
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
