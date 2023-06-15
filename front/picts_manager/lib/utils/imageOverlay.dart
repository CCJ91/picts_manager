// ignore_for_file: use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';
import 'package:picts_manager/model/helper/imageHelper.dart';
import 'package:picts_manager/model/helper/tagHelper.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/providers/myImageProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';
import 'package:picts_manager/utils/const.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

void showOverlay(
    {required BuildContext context,
    required OverlayEntry? overlayEntry,
    required String link,
    required MyImage image}) {
  overlayEntry = OverlayEntry(
    builder: (BuildContext context) {
      return Stack(
        children: [
          ModalBarrier(
            color: Colors.black.withOpacity(0.4),
            onDismiss: () {
              overlayEntry!.remove();
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                color: Colors.grey.shade50,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotatedBox(
                      quarterTurns: 1,
                      child: Image.network("$link/${image.id}/0"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  Overlay.of(context).insert(overlayEntry);
}

Future<void> showCompleteOverlay(
    {required BuildContext context,
    required OverlayEntry? overlayEntry,
    required String link,
    required MyImage image}) async {
  AlbumPageProvider albumPageProvider =
      Provider.of<AlbumPageProvider>(context, listen: false);
  albumPageProvider.setListTag = [];
  TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
  tagProvider.setCurrentTag = tagProvider.listTag.first;
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            color: Colors.grey.shade800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        image.name,
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () async {
                          if (await ImageHelper().deleteImage(
                            imageId: image.id,
                            myImageProvider: Provider.of<MyImageProvider>(
                              context,
                              listen: false,
                            ),
                          )) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: (Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                      ),
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Image.network(
                    "$link/${image.id}/0",
                  ),
                ),
                Selector<AlbumPageProvider, List<Tag>>(
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
                                        TagHelper().deleteTag(
                                          imageId: image.id,
                                          tagId: e.id,
                                          albumPageProvider: albumPageProvider,
                                        );
                                        // cameraProvider.listTag.removeWhere(
                                        //     (element) =>
                                        //         element.name == e.name);
                                        // cameraProvider.listTag =
                                        //     cameraProvider.listTag;
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
                ElevatedButton(
                  onPressed: () {
                    showAddTag(context: context, image: image);
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
              ],
            ),
          ),
        ),
      );
    },
  );

  albumPageProvider.listTag =
      await TagHelper().getTagForImage(imageId: image.id);
}

void removeOverlay({required OverlayEntry? overlayEntry}) {
  overlayEntry?.remove();
}

void showAddTag({
  required BuildContext context,
  required MyImage image,
}) {
  GlobalKey<FormState> overlayFormKey = GlobalKey<FormState>();
  TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
  AlbumPageProvider albumPageProvider =
      Provider.of<AlbumPageProvider>(context, listen: false);
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
              key: overlayFormKey,
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
                              selector: (context, provider) => provider.listTag,
                              shouldRebuild: (previous, next) => true,
                              builder: (context, listTag, child) {
                                return TextButton(
                                  onPressed: () async {
                                    if (!validCharacters
                                        .hasMatch(textEditingController.text)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                        "No special character",
                                      )));
                                      return;
                                    }
                                    await TagHelper().addTagToImage(
                                        imageId: image.id,
                                        tagName: textEditingController.text,
                                        albumPageProvider: albumPageProvider,
                                        tagProvider: tagProvider);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
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
                if (overlayFormKey.currentState == null) {
                  return;
                }
                if (overlayFormKey.currentState!.validate()) {
                  if (albumPageProvider.listTag
                          .indexWhere((element) => element.name == text) !=
                      -1) {
                    return;
                  }
                  TagHelper().addTagToImage(
                      imageId: image.id,
                      tagName: text,
                      albumPageProvider: albumPageProvider,
                      tagProvider: tagProvider);
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
