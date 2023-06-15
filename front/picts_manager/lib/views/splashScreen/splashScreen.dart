import 'package:flutter/material.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:picts_manager/views/homePage/homePage.dart';
import 'package:picts_manager/views/loginPage/loginNavigator.dart';
import 'package:picts_manager/views/loginPage/loginPage.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return Selector<AuthenticationProvider, String>(
      selector: (context, provider) => provider.token,
      shouldRebuild: (previous, next) => true,
      builder: (context, data, child) {
        print("data : ${authenticationProvider.token}");
        return authenticationProvider.token.isEmpty
            ? LoginNavigator()
            : HomePage();
      },
    );
  }
}
