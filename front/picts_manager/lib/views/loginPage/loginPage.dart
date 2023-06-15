import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picts_manager/model/helper/authHelper.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String email = "";
    String password = "";
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('Connexion',
                    style: GoogleFonts.comfortaa(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              TextFormField(
                initialValue: "test@test.com",
                decoration: InputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ obligatoire";
                  }
                  email = value;
                  return null;
                },
              ),
              TextFormField(
                initialValue: "test",
                decoration: InputDecoration(hintText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ obligatoire";
                  }
                  password = value;

                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState == null) return;
                    if (formKey.currentState!.validate()) {
                      AuthHelper().login(
                        email: email,
                        password: password,
                        authenticationProvider: authenticationProvider,
                      );
                    }
                  },
                  child: Text("Connexion"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
