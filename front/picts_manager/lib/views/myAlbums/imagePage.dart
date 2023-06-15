import 'package:flutter/material.dart';
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/helper/imageHelper.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/providers/myImageProvider.dart';
import 'package:picts_manager/utils/imageOverlay.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ImagePage extends StatelessWidget {
  ImagePage({super.key, required this.album});

  final Album album;

  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    AlbumPageProvider albumPageProvider =
        Provider.of<AlbumPageProvider>(context, listen: false);

    MyImageProvider myImageProvider =
        Provider.of<MyImageProvider>(context, listen: false);
    return FutureBuilder<List<MyImage>>(
      future: ImageHelper().getListImage(
        albumId: album.albumId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        }
        myImageProvider.setListImage = snapshot.data!;
        return Column(
          children: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {
                    albumPageProvider.album = null;
                  },
                  icon: Icon(Icons.arrow_circle_left_outlined),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      album.name,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Selector<MyImageProvider, List<MyImage>>(
                  selector: (context, provider) => provider.listImage,
                  shouldRebuild: (previous, next) => true,
                  builder: (context, listImage, child) {
                    return GridView.builder(
                      itemCount: listImage.length,
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
                              image: listImage[index],
                            ),
                            onLongPressEnd: (_) =>
                                removeOverlay(overlayEntry: overlayEntry),
                            onLongPress: () => showOverlay(
                                context: context,
                                overlayEntry: overlayEntry,
                                link: link,
                                image: listImage[index]),
                            child: Image.network(
                              "$link/${listImage[index].id}/1",
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        );
      },
    );
  }
}
