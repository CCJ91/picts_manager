import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/service/albumApi.dart';
import 'package:picts_manager/providers/albumProvider.dart';
import 'package:tuple/tuple.dart';

class AlbumHelper {
  AlbumApi albumApi = AlbumApi();

  Future<bool> createAlbum(
      {required String name,
      required int public,
      required int idOwner,
      int albumDefault = 0,
      required AlbumProvider albumProvider}) async {
    Tuple2<Album?, int> tuple2 =
        await albumApi.createAlbum(name, public, idOwner, albumDefault);
    if (tuple2.item2 == 200) {
      albumProvider.listAlbum.add(tuple2.item1!);
      albumProvider.listAlbum = albumProvider.listAlbum;
      return true;
    }
    return false;
  }

  Future<bool> updateAlbumPrivacy(
      {required String albumId,
      required String name,
      required int public,
      required String idOwner,
      int albumDefault = 0,
      required AlbumProvider albumProvider}) async {
    Tuple2<Album?, int> tuple2 = await albumApi.updateAlbumPrivacy(
        albumId, name, public, idOwner, albumDefault);
    if (tuple2.item2 == 200) {
      var index = albumProvider.listAlbum
          .indexWhere((element) => element.albumId == albumId);
      albumProvider.listAlbum[index] = tuple2.item1!;
      albumProvider.listAlbum = albumProvider.listAlbum;

      return true;
    }
    return false;
  }

  Future<bool> updateAlbum(
      {required String albumId,
      required String name,
      required int public,
      required String idOwner,
      int albumDefault = 0,
      required AlbumProvider albumProvider}) async {
    Tuple2<Album?, int> tuple2 = await albumApi.updateAlbum(
        albumId, name, public, idOwner, albumDefault);
    if (tuple2.item2 == 200) {
      var index = albumProvider.listAlbum
          .indexWhere((element) => element.albumId == albumId);
      albumProvider.listAlbum[index] = tuple2.item1!;
      albumProvider.listAlbum = albumProvider.listAlbum;

      return true;
    }
    return false;
  }

  Future<List<Album>> getAlbum({
    required String userId,
    required AlbumProvider albumProvider,
  }) async {
    List<Album> listAlbum = await albumApi.getAlbum(userId);
    albumProvider.listAlbum = listAlbum;
    return listAlbum;
  }

  Future<bool> deletedAlbum({required String albumId}) async {
    return albumApi.deleteAlbum(albumId);
  }
}
