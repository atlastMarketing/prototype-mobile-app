class ContentData {
  String? dateTime;
  String? caption;
  String? imageUrl;

  ContentData({
    this.dateTime,
    this.caption,
    this.imageUrl,
  });
}

class PostContent extends ContentData {
  int id;

  PostContent({
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
