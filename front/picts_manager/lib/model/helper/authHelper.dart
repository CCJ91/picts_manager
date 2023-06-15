import 'package:picts_manager/model/core/User.dart';
import 'package:picts_manager/model/service/authApi.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:tuple/tuple.dart';

class AuthHelper {
  AuthApi authApi = AuthApi();

  Future<bool> signup({
    required String email,
    required String name,
    required String password,
  }) async {
    return authApi.signup(email: email, name: name, password: password);
  }

  Future<int?> login({
    required String email,
    required String password,
    required AuthenticationProvider authenticationProvider,
  }) async {
    Tuple3<User?, String?, int>? tuple3 =
        await authApi.login(email: email, password: password);

    if (tuple3 == null) {
      return null;
    } else if (tuple3.item3 == 404) {
      return 404;
    } else if (tuple3.item2 == null ||
        tuple3.item1 == null ||
        tuple3.item2!.isEmpty) {
      return 500;
    } else {
      print("token : ${tuple3.item2!}");
      authenticationProvider.token = tuple3.item2!;
      authenticationProvider.user = tuple3.item1!;
      return 200;
    }
  }
}
