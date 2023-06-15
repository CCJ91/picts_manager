import 'package:picts_manager/model/core/Tag.dart';
import 'package:picts_manager/model/service/tagApi.dart';
import 'package:picts_manager/providers/albumPageProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';

class TagHelper {
  TagApi tagApi = TagApi();

  Future<List<Tag>> getTag({required TagProvider tagProvider}) async {
    List<Tag> listTag = await tagApi.getTag();
    tagProvider.setListTag = listTag;
    return listTag;
  }

  Future<bool> addTagToImage({
    required String imageId,
    required String tagName,
    required AlbumPageProvider albumPageProvider,
    required TagProvider tagProvider,
  }) async {
    bool? ret = await tagApi.addTagToImage(imageId: imageId, tagName: tagName);
    albumPageProvider.listTag.add(Tag(id: "", name: "#$tagName"));
    albumPageProvider.listTag = albumPageProvider.listTag;
    getTag(tagProvider: tagProvider);
    return ret ?? false;
  }

  Future<bool> deleteTag(
      {required String imageId,
      required String tagId,
      required AlbumPageProvider albumPageProvider}) async {
    if (await tagApi.deleteTag(imageId: imageId, tagId: tagId)) {
      albumPageProvider.listTag.removeWhere((element) => element.id == tagId);
      albumPageProvider.listTag = albumPageProvider.listTag;
      return true;
    }
    return false;
  }

  Future<List<Tag>> getTagForImage({required String imageId}) async {
    return tagApi.getTagForImage(imageId: imageId);
  }
}
