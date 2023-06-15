import 'package:picts_manager/model/core/User.dart';

class Album {
  String albumId;

  String name;

  String idOwner;

  bool isPublic;

  String? imageId;

  Album({
    required this.albumId,
    required this.name,
    required this.idOwner,
    required this.isPublic,
    this.imageId,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    try {
      return Album(
          albumId: json['album']["albumId"].toString(),
          name: json['album']["albumName"].toString(),
          idOwner: json['album']["albumIdOwner"].toString(),
          isPublic: json['album']["albumIsPublic"].toString() == "1",
          imageId: json['image']['imageId'].toString());
    } catch (e) {
      try {
        return Album(
          albumId: json['album']["albumId"].toString(),
          name: json['album']["albumName"].toString(),
          idOwner: json['album']["albumIdOwner"].toString(),
          isPublic: json['album']["albumIsPublic"].toString() == "1",
        );
      } catch (e) {
        return Album(
          albumId: json["albumId"].toString(),
          name: json["albumName"].toString(),
          idOwner: json["albumIdOwner"].toString(),
          isPublic: json["albumIsPublic"].toString() == "1",
        );
      }
    }
  }

  factory Album.fromJson2(Map<String, dynamic> json) {
    return Album(
        albumId: json["albumId"].toString(),
        name: json["albumName"].toString(),
        idOwner: json["albumIdOwner"].toString(),
        isPublic: json["albumIsPublic"].toString() == "1",
        imageId: json['imageId'].toString());
  }
}
