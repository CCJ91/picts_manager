import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:tuple/tuple.dart';

class AlbumApi {
  String baseUrl = "http://$ip:7000/pictsmanager/";

  Future<Tuple2<Album?, int>> createAlbum(
      String name, int public, int idOwner, int albumDefault) async {
    Uri uri = Uri.parse("${baseUrl}album");
    http.Response response;
    print("${baseUrl}album");
    try {
      response = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "albumName": name,
            "albumIsPublic": public,
            "albumIdOwner": idOwner,
            "albumIsDefault": albumDefault,
          }));
    } catch (e) {
      print(e);
      return Tuple2(null, 404);
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Album album;
      try {
        album = Album.fromJson(json);
      } catch (e) {
        print(e);
        return Tuple2(null, 404);
      }
      return Tuple2(album, 200);
    }
    return Tuple2(null, response.statusCode);
  }

  Future<Tuple2<Album?, int>> updateAlbum(String albumId, String name,
      int public, String idOwner, int albumDefault) async {
    Uri uri = Uri.parse("${baseUrl}album");
    http.Response response;
    print("${baseUrl}album");
    try {
      response = await http.put(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "albumId": int.parse(albumId),
            "albumName": name,
            "albumIsPublic": public,
            "albumIdOwner": int.parse(idOwner),
            "albumIsDefault": albumDefault,
          }));
    } catch (e) {
      print(e);
      return Tuple2(null, 404);
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Album album;
      try {
        album = Album.fromJson2(json);
      } catch (e) {
        print(e);
        return Tuple2(null, 404);
      }
      return Tuple2(album, 200);
    }
    return Tuple2(null, response.statusCode);
  }

  Future<Tuple2<Album?, int>> updateAlbumPrivacy(String albumId, String name,
      int public, String idOwner, int albumDefault) async {
    Uri uri = Uri.parse(public == 0
        ? "${baseUrl}album/private/$albumId"
        : "${baseUrl}album/public/$albumId");
    http.Response response;
    print("${baseUrl}album");
    try {
      response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print(e);
      return Tuple2(null, 404);
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      Album album;
      try {
        album = Album.fromJson2(json);
      } catch (e) {
        print(e);
        return Tuple2(null, 404);
      }
      return Tuple2(album, 200);
    }
    return Tuple2(null, response.statusCode);
  }

  Future<List<Album>> getAlbum(String userId) async {
    Uri uri = Uri.parse("${baseUrl}albums/user/$userId");
    http.Response response;
    print("${baseUrl}albums/user/$userId");
    try {
      response = await http.get(
        uri,
      );
    } catch (e) {
      print(e);
      return [];
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Iterable iterable = jsonDecode(response.body);
      List<Album> listAlbum;
      try {
        listAlbum = iterable.map((e) => Album.fromJson(e)).toList();
      } catch (e) {
        print(e);
        return [];
      }
      return listAlbum;
    }
    return [];
  }

  Future<bool> deleteAlbum(String albumId) async {
    Uri uri = Uri.parse("${baseUrl}album/$albumId");
    http.Response response;
    print("${baseUrl}album/$albumId");
    try {
      response = await http.delete(
        uri,
      );
    } on SocketException {
      return false;
    } catch (e) {
      print(e);
      return false;
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
