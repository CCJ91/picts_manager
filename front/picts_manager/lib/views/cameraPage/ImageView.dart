import 'dart:io';

import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';
import 'package:picts_manager/model/helper/imageHelper.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/providers/cameraProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';
import 'package:picts_manager/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.myImage,
  });

  final MyImage myImage;

  @override
  Widget build(BuildContext context) {
    CameraProvider cameraProvider =
        Provider.of<CameraProvider>(context, listen: false);

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    String name = "";

    cameraProvider.setListTag = [];

    File fileImage = File(myImage.link);
    return SizedBox.expand(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            fileImage.delete();
                            cameraProvider.image = null;
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("Annuler"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          String? albumId =
                              await showSelectAlbum(context: context);
                          if (albumId == null) return;
                          await ImageHelper().saveImage(
                            albumId: albumId,
                            image: fileImage.path,
                            imageName: name,
                            listTag: cameraProvider.listTag,
                            // ignore: use_build_context_synchronously
                            tagProvider: Provider.of<TagProvider>(context,
                                listen: false),
                          );
                          await Future.delayed(Duration.zero);
                          try {
                            fileImage.delete();
                            cameraProvider.image = null;
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text("Enregistrer"),
                      ),
                    ],
                  ),
                ),
                Image.file(fileImage),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: InputDecoration(hintText: "Nom de l'image"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Champs obligatoire";
                        }
                        if (value.length > 20) return "20 caractères max";
                        name = value;
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Selector<CameraProvider, List<Tag>>(
                    selector: (context, provider) => provider.listTag,
                    shouldRebuild: (previous, next) => true,
                    builder: (context, data, child) {
                      return Wrap(
                        children: data
                            .map(
                              (e) => Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        e.name,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          cameraProvider.listTag.removeWhere(
                                              (element) =>
                                                  element.name == e.name);
                                          cameraProvider.listTag =
                                              cameraProvider.listTag;
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  showAddTag(context: context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Ajouter tag"),
                    Icon(
                      Icons.add,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String?> showSelectAlbum({
    required BuildContext context,
  }) async {
    AlbumProvider albumProvider =
        Provider.of<AlbumProvider>(context, listen: false);
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String albumId = '';
    return showDialog<String>(
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
                  child: Selector<AlbumProvider, Album?>(
                    selector: (context, provider) => provider.currentAlbum,
                    shouldRebuild: (previous, next) => true,
                    builder: (context, data, child) {
                      Album currentAlbum =
                          data ?? albumProvider.listAlbum.first;
                      return DropdownButtonFormField<Album>(
                        value: currentAlbum,
                        items: albumProvider.listAlbum
                            .map<DropdownMenuItem<Album>>(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          albumProvider.currentAlbum = value;
                        },
                        validator: (value) {
                          if (value == null) return "";
                          albumId = value.albumId;
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (formKey.currentState == null) return;
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, albumId);
                  }
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddTag({
    required BuildContext context,
  }) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    CameraProvider cameraProvider =
        Provider.of<CameraProvider>(context, listen: false);
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    tagProvider.setCurrentTag = tagProvider.listTag.first;
    String text = '';
    TextEditingController textEditingController = TextEditingController();
    showDialog(
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
                  child: Selector<TagProvider, Tuple2<List<Tag>, Tag>>(
                    selector: (context, provider) =>
                        Tuple2(provider.listTag, provider.currentTag),
                    shouldRebuild: (previous, next) => true,
                    builder: (context, data, child) {
                      return DropdownSearch<Tag>(
                        popupProps: PopupProps.menu(
                          searchFieldProps:
                              TextFieldProps(controller: textEditingController),
                          fit: FlexFit.loose,
                          emptyBuilder: (context, data) => Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Selector<TagProvider, List<Tag>>(
                                selector: (context, provider) =>
                                    provider.listTag,
                                shouldRebuild: (previous, next) => true,
                                builder: (context, listTag, child) {
                                  return TextButton(
                                    onPressed: () {
                                      if (!validCharacters.hasMatch(
                                          textEditingController.text)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                          "No special character",
                                        )));
                                        return;
                                      }

                                      Tag tag = Tag(
                                        id: '',
                                        name: "#${textEditingController.text}",
                                      );
                                      tagProvider.listTag.add(tag);
                                      tagProvider.listTag = tagProvider.listTag;

                                      cameraProvider.listTag.add(tag);
                                      cameraProvider.listTag =
                                          cameraProvider.listTag;
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Créer tag"),
                                  );
                                },
                              ),
                            ],
                          ),
                          showSearchBox: true,
                          searchDelay: Duration.zero,
                        ),
                        selectedItem: data.item2,
                        items: data.item1,
                        itemAsString: (tag) => tag.name,
                        onChanged: (value) {
                          if (value == null) return;
                          tagProvider.currentTag = value;
                        },
                        validator: (value) {
                          if (value == null) return "";
                          text = value.name;
                          return null;
                        },
                      );
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (formKey.currentState == null) return;
                  if (formKey.currentState!.validate()) {
                    if (cameraProvider.listTag
                            .indexWhere((element) => element.name == text) !=
                        -1) {
                      return;
                    }
                    cameraProvider.listTag.add(
                      Tag(id: '', name: text),
                    );
                    cameraProvider.listTag = cameraProvider.listTag;
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  /* void showCreateTag({required BuildContext context}) {
    GlobalKey<FormState> formKeyCreateTag = GlobalKey<FormState>();
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);

    String text = "";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKeyCreateTag,
                child: TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text('nom du #'),
                    hintText: 'nom',
                    prefixText: "#",
                  ),
                  validator: (value) {
                    print(value);
                    if (value == null || value.isEmpty) {
                      return 'Champ obligatoire';
                    } else if (value.length > 50) {
                      return '50 caractères max';
                    } else if (!validCharacters.hasMatch(value)) {
                      return 'Caractères spéciaux interdit';
                    } else {
                      text = "#$value";
                      return null;
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  if (formKeyCreateTag.currentState == null) return;
                  if (formKeyCreateTag.currentState!.validate()) {
                    tagProvider.listTag.add(
                      Tag(id: '', name: text),
                    );
                    tagProvider.listTag = tagProvider.listTag;
                    Navigator.of(context).pop();
                  }
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
        );
      },
    );
  } */
}
// img.adjustColor(Image.file(fileImage));https://github.com/brendan-duncan/image/blob/main/doc/tutorial.md
// /data/user/0/com.example.picts_manager/cache/CAP5717053676191022942.jpg

// Directory directory = await getTemporaryDirectory();
// print("directory.path ${directory.path}");
// List<FileSystemEntity> listFileSystemEntity =
//     directory.listSync();
// for (FileSystemEntity fileSystemEntity
//     in listFileSystemEntity) {
//   print(fileSystemEntity.path);
// }
// directory.path /data/user/0/com.example.picts_manager/cache
// /data/user/0/com.example.picts_manager/cache/CAP6603569231629496509.jpg
// /data/user/0/com.example.picts_manager/cache/CAP217572977585811165.jpg
// /data/user/0/com.example.picts_manager/cache/CAP5717053676191022942.jpg
// /data/user/0/com.example.picts_manager/cache/CAP8594997824930503179.jpg