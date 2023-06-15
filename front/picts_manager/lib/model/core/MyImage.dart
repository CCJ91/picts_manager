class MyImage {
  String id;

  String name;

  String link;

  String imageIsPublic;

  MyImage({
    required this.id,
    required this.name,
    required this.link,
    required this.imageIsPublic,
  });

  factory MyImage.fromJson(Map<String, dynamic> json) {
    return MyImage(
      id: json["imageId"].toString(),
      name: json["imageName"].toString(),
      link: json["imageLink"].toString(),
      imageIsPublic: json['imageIsPublic'].toString(),
    );
  }
}
