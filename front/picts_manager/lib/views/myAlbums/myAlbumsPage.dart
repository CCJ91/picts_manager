import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/helper/albumHelper.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:picts_manager/views/myAlbums/albumNavigator.dart';
import 'package:provider/provider.dart';

class MyAlbumsPage extends StatefulWidget {
  const MyAlbumsPage({super.key});

  @override
  State<MyAlbumsPage> createState() => _MyAlbumsPageState();
}

class _MyAlbumsPageState extends State<MyAlbumsPage> {
  late AuthenticationProvider authenticationProvider;
  late AlbumProvider albumProvider;
  Album? album;

  @override
  void initState() {
    authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    albumProvider = Provider.of<AlbumProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Text(
                "Bonjour ${authenticationProvider.user.username}",
                style: GoogleFonts.comfortaa(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(child: AlbumNavigator())
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              myShowDialog(context: context, formKey: formKey);
            },
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> myShowDialog(
      {required BuildContext context,
      required GlobalKey<FormState> formKey}) async {
    String text = "";
    bool? value = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text("Nom de l'album *"),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "champ obligatoire";
                      }
                      text = value;
                      return null;
                    },
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState == null) return;
                  if (formKey.currentState!.validate()) {
                    print("validate ok : $text");
                    AlbumHelper().createAlbum(
                      name: text,
                      public: 0,
                      idOwner: int.parse(authenticationProvider.user.userId),
                      albumProvider: albumProvider,
                    );
                    Navigator.of(context).pop();
                  } else {
                    print("validate Nok");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Ajouter"),
                    Icon(Icons.add),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    return value ?? false;
  }
}
