import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/Tag.dart';

class TagApi {
  String baseUrl = "http://$ip:7000/pictsmanager/";

  Future<List<Tag>> getTag() async {
    Uri uri = Uri.parse("${baseUrl}tags");
    http.Response response;
    print("${baseUrl}tags");
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
      List<Tag> listTag;
      try {
        listTag = iterable.map((e) => Tag.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
      return listTag;
    }
    return [];
  }

  Future<bool?> addTagToImage(
      {required String imageId, required String tagName}) async {
    Uri uri = Uri.parse("${baseUrl}tag/image/$imageId");
    http.Response response;
    print("${baseUrl}tag/image/$imageId");
    try {
      response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tagName': "#$tagName"}),
      );
    } catch (e) {
      print(e);
      return null;
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    return null;
  }

  Future<bool> deleteTag(
      {required String imageId, required String tagId}) async {
    Uri uri = Uri.parse("${baseUrl}tag/image/$tagId/$imageId");
    http.Response response;
    print("${baseUrl}tag/image/$tagId/$imageId");
    try {
      response = await http.delete(
        uri,
      );
    } catch (e) {
      print(e);
      return false;
    }
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<List<Tag>> getTagForImage({required String imageId}) async {
    Uri uri = Uri.parse("${baseUrl}tags/image/$imageId");
    http.Response response;
    print("${baseUrl}tags/image/$imageId");
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
      List<Tag> listTag;
      try {
        listTag = iterable.map((e) => Tag.fromJson(e)).toList();
      } catch (e) {
        return [];
      }
      return listTag;
    }
    return [];
  }
}
