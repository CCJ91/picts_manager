import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/User.dart';
import 'package:tuple/tuple.dart';

class AuthApi {
  String baseUrl = "http://$ip:7000/pictsmanager/";

  Future<bool> signup({
    required String email,
    required String name,
    required String password,
  }) async {
    Uri uri = Uri.parse("${baseUrl}user/create");
    http.Response response;
    print("${baseUrl}user/create");
    try {
      response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            "username": name,
            "email": email,
            "password": password,
          },
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
    if (response.statusCode == 200) {
      return true;
    }
    print(response.statusCode);
    print(response.body);
    return false;
  }

  Future<Tuple3<User?, String?, int>?> login({
    required String email,
    required String password,
  }) async {
    Uri uri = Uri.parse("${baseUrl}user/login");
    http.Response response;
    print("${baseUrl}user/login");
    try {
      response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
    } on SocketException {
      return null;
    } catch (e) {
      print(e);
      return Tuple3(null, null, 404);
    }
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String token;
      User user;
      try {
        token = json['token'] ?? "";
        user = User.fromJson(json['user']);
      } catch (e) {
        print(e);
        return Tuple3(null, null, 500);
      }
      return Tuple3(user, token, 200);
    }

    return Tuple3(null, null, 500);
  }
}
