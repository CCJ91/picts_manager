import 'package:flutter/material.dart';
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';
import 'package:picts_manager/model/helper/imageHelper.dart';
import 'package:picts_manager/providers/searchPageProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';
import 'package:picts_manager/utils/imageOverlay.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context, listen: false);
    SearchPageProvider searchPageProvider =
        Provider.of<SearchPageProvider>(context, listen: false);
    searchPageProvider.setCurrentTag = tagProvider.listTag.first;
    OverlayEntry? overlayEntry;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Selector<SearchPageProvider, Tag>(
                  selector: (context, provider) => provider.currentTag,
                  builder: (context, data, child) {
                    return DropdownButton<Tag>(
                      isExpanded: true,
                      value: data,
                      items: tagProvider.listTag
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Center(child: Text(e.name)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        searchPageProvider.currentTag = value;
                      },
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: () {
                  ImageHelper().getImagesPublicWithTag(
                    tagId: searchPageProvider.currentTag.id,
                    searchPageProvider: searchPageProvider,
                  );
                },
                icon: Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Selector<SearchPageProvider, List<MyImage>>(
              selector: (context, provider) => provider.listImage,
              shouldRebuild: (previous, next) => true,
              builder: (context, data, child) {
                return GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    String link = "http://$ip:7000/pictsmanager/image";
                    return RotatedBox(
                      quarterTurns: 1,
                      child: GestureDetector(
                        onTap: () => showCompleteOverlay(
                          context: context,
                          overlayEntry: overlayEntry,
                          link: link,
                          image: data[index],
                        ),
                        onLongPressEnd: (_) =>
                            removeOverlay(overlayEntry: overlayEntry),
                        onLongPress: () => showOverlay(
                          context: context,
                          overlayEntry: overlayEntry,
                          link: link,
                          image: data[index],
                        ),
                        child: Image.network(
                          "$link/${data[index].id}/1",
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
