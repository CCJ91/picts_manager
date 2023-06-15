import 'package:flutter/material.dart';
import 'package:picts_manager/ip.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/views/myAlbums/albumModalOptions.dart';
import 'package:provider/provider.dart';

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({super.key, required this.album});
  final Album album;

  @override
  Widget build(BuildContext context) {
    AlbumPageProvider albumPageProvider =
        Provider.of<AlbumPageProvider>(context, listen: false);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                albumPageProvider.album = album;
              },
              child: RotatedBox(
                quarterTurns: 1,
                child: album.imageId == null
                    ? Container(
                        color: Colors.transparent,
                      )
                    : Image.network(
                        "http://$ip:7000/pictsmanager/image/${album.imageId}/1",
                        fit: BoxFit.fill,
                      ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Text(
                    album.name,
                    style: GoogleFonts.mavenPro(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.35,
                    ),
                    builder: (BuildContext context) {
                      return AlbumModalOptions(
                        album: album,
                      );
                    },
                  );
                },
                icon: Icon(Icons.more_vert),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerRight,
              ),
            ],
          )
        ],
      ),
    );
  }
}
