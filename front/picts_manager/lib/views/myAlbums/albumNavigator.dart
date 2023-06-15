import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:picts_manager/providers/authenticationProvider.dart';
import 'package:picts_manager/views/myAlbums/albumWidget.dart';
import 'package:picts_manager/views/myAlbums/imagePage.dart';
import 'package:provider/provider.dart';

const List<Tab> tabs = <Tab>[
  Tab(text: 'Mes albums'),
  Tab(text: 'Albums partagés'),
];

class AlbumNavigator extends StatelessWidget {
  const AlbumNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    AlbumProvider albumProvider =
        Provider.of<AlbumProvider>(context, listen: false);
    AuthenticationProvider userProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {}
        });
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: [
              Selector<AlbumPageProvider, Album?>(
                  selector: (context, provider) => provider.album,
                  builder: (context, data, child) {
                    return data != null
                        ? ImagePage(album: data)
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Selector<AlbumProvider, List<Album?>>(
                                selector: (context, provider) =>
                                    provider.listAlbum,
                                shouldRebuild: (previous, next) => true,
                                builder: (context, data, child) {
                                  return GridView.count(
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 15,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    crossAxisCount: 2,
                                    children: albumProvider.listAlbum
                                        .where((album) =>
                                            album.idOwner ==
                                            userProvider.user.userId)
                                        .map((album) =>
                                            AlbumWidget(album: album))
                                        .toList(),
                                  );
                                }),
                          );
                  }),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 15,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  crossAxisCount: 2,
                  children: albumProvider.listAlbum
                      .where((album) => album.isPublic)
                      .map((album) => AlbumWidget(album: album))
                      .toList(),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
