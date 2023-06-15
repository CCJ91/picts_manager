import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/Album.dart';

class AlbumProvider extends ChangeNotifier {
  List<Album> _listAlbum = [];

  Album? _currentAlbum;

  List<Album> get listAlbum => _listAlbum;

  set listAlbum(List<Album> value) {
    _listAlbum = value;
    notifyListeners();
  }

  void setListAlbum(List<Album> value) {
    _listAlbum = value;
  }

  Album? get currentAlbum => _currentAlbum;

  set currentAlbum(Album? value) {
    _currentAlbum = value;
    notifyListeners();
  }

  set setCurrentAlbum(Album? value) {
    _currentAlbum = value;
  }
}
