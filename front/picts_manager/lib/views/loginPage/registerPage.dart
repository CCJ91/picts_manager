import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picts_manager/model/helper/authHelper.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String username = "";
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
                child: Text('Inscription',
                    style: GoogleFonts.comfortaa(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Username"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ obligatoire";
                  }
                  username = value;
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Champ obligatoire";
                  }
                  email = value;
                  return null;
                },
              ),
              TextFormField(
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
                  onPressed: () async {
                    if (formKey.currentState == null) return;
                    if (formKey.currentState!.validate()) {
                      if (await AuthHelper().signup(
                        // Faire le register
                        name: username,
                        email: email,
                        password: password,
                      )) {
                        final snackBar = SnackBar(
                          content: const Text('Inscription réussie !'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {},
                          ),
                        );
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        tabController.animateTo(0);
                      }
                    }
                  },
                  child: Text("Inscription"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
