import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';

class ImageApi {
  String baseUrl = "http://$ip:7000/pictsmanager/";

  Future<void> saveImage({
    required String albumId,
    required String image,
    required String imageName,
    required List<Tag> listTag,
  }) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://$ip:7000/pictsmanager/image/save/$albumId'));
    request.fields.addAll({
      'body':
          '{"image":{"imageName": "$imageName","imageLink": "","imageIsPublic": 0},"tagList":${listTag.map((e) => '{"tagName" :"${e.name}"}').toList()}}'
    });
    request.files.add(await http.MultipartFile.fromPath('image', image));

    http.StreamedResponse response = await request.send();

    print(response.statusCode);

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.stream);
    }
  }

  Future<bool> deleteImage({required String imageId}) async {
    Uri uri = Uri.parse("${baseUrl}image/$imageId");
    http.Response response;
    print("${baseUrl}image/$imageId");
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

  Future<List<MyImage>> getImage(String albumId) async {
    Uri uri = Uri.parse("${baseUrl}image/album/$albumId");
    http.Response response;
    print("${baseUrl}image/album/$albumId");
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
      List<MyImage> listImage;
      try {
        listImage = iterable.map((e) => MyImage.fromJson(e)).toList();
      } catch (e) {
        print(e);
        return [];
      }
      return listImage;
    }
    return [];
  }

  Future<List<MyImage>> getImagesPublicWithTag({required String tagId}) async {
    Uri uri = Uri.parse("${baseUrl}image/album/public/$tagId");
    http.Response response;
    print("${baseUrl}image/album/public/$tagId");
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
      List<MyImage> listImage;
      try {
        listImage = iterable.map((e) => MyImage.fromJson(e)).toList();
      } catch (e) {
        print(e);
        return [];
      }
      return listImage;
    }
    return [];
  }
}
