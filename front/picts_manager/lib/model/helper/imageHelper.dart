import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';
import 'package:picts_manager/model/helper/tagHelper.dart';
import 'package:picts_manager/model/service/imageApi.dart';
import 'package:picts_manager/providers/myImageProvider.dart';
import 'package:picts_manager/providers/searchPageProvider.dart';
import 'package:picts_manager/providers/tagProvider.dart';

class ImageHelper {
  ImageApi imageApi = ImageApi();
  TagHelper tagHelper = TagHelper();

  Future<void> saveImage({
    required String albumId,
    required String image,
    required String imageName,
    required List<Tag> listTag,
    required TagProvider tagProvider,
  }) async {
    await imageApi.saveImage(
        albumId: albumId, image: image, imageName: imageName, listTag: listTag);
    tagHelper.getTag(tagProvider: tagProvider);
  }

  Future<bool> deleteImage({
    required String imageId,
    required MyImageProvider myImageProvider,
  }) async {
    if (await imageApi.deleteImage(
      imageId: imageId,
    )) {
      myImageProvider.listImage.removeWhere((element) => element.id == imageId);
      myImageProvider.listImage = myImageProvider.listImage;
      return true;
    }
    return false;
  }

  Future<List<MyImage>> getListImage({
    required String albumId,
  }) async {
    return imageApi.getImage(
      albumId,
    );
  }

  Future<void> getImagesPublicWithTag({
    required String tagId,
    required SearchPageProvider searchPageProvider,
  }) async {
    List<MyImage> listImage = await imageApi.getImagesPublicWithTag(
      tagId: tagId,
    );
    searchPageProvider.listImage = listImage;
  }
}
