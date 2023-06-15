import 'package:flutter/material.dart';
import 'package:picts_manager/model/core/MyImage.dart';
import 'package:picts_manager/model/core/Tag.dart';

class CameraProvider extends ChangeNotifier {
  MyImage? _image;

  List<Tag> _listTag = [];

  double _zoom = 0;

  MyImage? get image => _image;
  set image(MyImage? value) {
    _image = value;
    notifyListeners();
  }

  List<Tag> get listTag => _listTag;
  set listTag(List<Tag> value) {
    _listTag = value;
    notifyListeners();
  }

  set setListTag(List<Tag> value) {
    _listTag = value;
  }

  double get zoom => _zoom;
  set zoom(double value) {
    _zoom = value;
    notifyListeners();
  }
}
