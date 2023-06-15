class Tag {
  String id;

  String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json["tagId"].toString(),
      name: json["tagName"].toString(),
    );
  }
}
