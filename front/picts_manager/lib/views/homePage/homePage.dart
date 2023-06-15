import 'package:flutter/material.dart';
import 'package:picts_manager/model/helper/albumHelper.dart';
import 'package:picts_manager/model/helper/tagHelper.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:picts_manager/providers/navigationProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';
import 'package:picts_manager/views/cameraPage/CameraPage.dart';
import 'package:picts_manager/views/homePage/MyBottomNavigationBar.dart';
import 'package:picts_manager/views/homePage/MyTopAppBar.dart';
import 'package:picts_manager/views/myAlbums/myAlbumsPage.dart';
import 'package:picts_manager/views/searchPage/searchPage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return FutureBuilder(
        future: Future.wait(
          [
            TagHelper().getTag(
              tagProvider: Provider.of<TagProvider>(context, listen: false),
            ),
            AlbumHelper().getAlbum(
              userId: authenticationProvider.user.userId,
              albumProvider: Provider.of<AlbumProvider>(context, listen: false),
            ),
          ],
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          return SafeArea(
            child: Scaffold(
              body: Selector<NavigationProvider, int>(
                selector: (context, provider) => provider.index,
                builder: (context, index, child) {
                  return [
                    MyAlbumsPage(),
                    CameraPage(),
                    SearchPage(),
                  ][index];
                },
              ),
              bottomNavigationBar: MyBottomNavigationBar(),
              appBar: MyTopAppBar(),
            ),
          );
        });
  }
}
