import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/helper/albumHelper.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/views/myAlbums/CustomDialog.dart';
import 'package:picts_manager/views/myAlbums/albumModalOptionDialog.dart';
import 'package:provider/provider.dart';

class AlbumModalOptions extends StatelessWidget {
  const AlbumModalOptions({super.key, required this.album});
  final Album album;
  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider =
        Provider.of<AlbumProvider>(context, listen: false);
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  album.name,
                  style: TextStyle(fontSize: 28),
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 1.5,
              ),
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () async {
                        print("album ${album.isPublic}");
                        var response = await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AlbumModalOptionDialog(
                            title: 'Confirmation',
                            message:
                                'Voulez-vous vraiment rendre ${album.isPublic ? "privé" : "public"} cet album ?',
                          ),
                        );
                        if (response) {
                          AlbumHelper().updateAlbum(
                              albumId: album.albumId,
                              name: album.name,
                              public: album.isPublic ? 0 : 1,
                              idOwner: album.idOwner,
                              albumProvider: albumProvider);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Passer cet album en ${album.isPublic ? "privé" : "public"}",
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(album.isPublic
                              ? Icons.lock_open
                              : Icons.lock_open),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(title: 'Rennomer cet album');
                            }).then((value) async {
                          if (value != null) {
                            print(value);
                            if (await AlbumHelper().updateAlbumPrivacy(
                                albumId: album.albumId,
                                name: value,
                                public: album.isPublic ? 1 : 0,
                                idOwner: album.idOwner,
                                albumProvider: albumProvider)) {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            }
                          }
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Renommer cet album"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.edit),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var choice = showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AlbumModalOptionDialog(
                            title: 'Confirmation',
                            message:
                                'Voulez-vous vraiment rendre supprimer cet album ?',
                          ),
                        );
                        if (await choice) {
                          var response = await AlbumHelper()
                              .deletedAlbum(albumId: album.albumId);
                          final snackBar = SnackBar(
                            content: Text(
                                "La suppression ${response ? "a bien été réalisée" : "n'a pas pu être réalisée"}"),
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {},
                            ),
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          albumProvider.listAlbum.removeWhere(
                              (element) => element.albumId == album.albumId);
                          albumProvider.listAlbum = albumProvider.listAlbum;
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Supprimer cet album",
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
