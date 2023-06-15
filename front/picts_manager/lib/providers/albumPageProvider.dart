import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Album.dart';
import 'package:picts_manager/model/core/Tag.dart';

class AlbumPageProvider extends ChangeNotifier {
  Album? _album;

  Album? get album => _album;
  set album(Album? value) {
    _album = value;
    notifyListeners();
  }

  List<Tag> _listTag = [];
  List<Tag> get listTag => _listTag;
  set listTag(List<Tag> value) {
    _listTag = value;
    notifyListeners();
  }

  set setListTag(List<Tag> value) {
    _listTag = value;
  }
}
