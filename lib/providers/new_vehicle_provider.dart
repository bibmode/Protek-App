import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:protek_tracker/models/vehicle.dart';

class NewVehicle with ChangeNotifier, DiagnosticableTreeMixin {
  int _pageIndex = 0;
  String? _space;
  Vehicle? _newVehicle;
  File? _frontImage;
  File? _backImage;
  File? _leftImage;
  File? _rightImage;
  File? _interiorImage;
  File? _affidavitImage;
  File? _memorandumOfAgreementImage;
  File? _acknowledgementImage;

  int get pageIndex => _pageIndex;
  String? get space => _space;
  Vehicle? get newVehicle => _newVehicle;
  File? get frontImage => _frontImage;
  File? get backImage => _backImage;
  File? get leftImage => _leftImage;
  File? get rightImage => _rightImage;
  File? get interiorImage => _interiorImage;
  File? get affidavitImage => _affidavitImage;
  File? get memorandumOfAgreementImage => _memorandumOfAgreementImage;
  File? get acknowledgementImage => _acknowledgementImage;

  void restoreNew() {
    _pageIndex = 0;
    _space = null;
    _newVehicle = Vehicle();
    _frontImage = null;
    _backImage = null;
    _leftImage = null;
    _rightImage = null;
    _interiorImage = null;
    _affidavitImage = null;
    _memorandumOfAgreementImage = null;
    _acknowledgementImage = null;
    notifyListeners();
  }

  void updateImage(File image, String imageType) {
    if (imageType == "front") _frontImage = image;
    if (imageType == "back") _backImage = image;
    if (imageType == "left") _leftImage = image;
    if (imageType == "right") _rightImage = image;
    if (imageType == "interior") _interiorImage = image;
    if (imageType == "affidavit") _affidavitImage = image;
    if (imageType == "memorandumOfAgreement")
      _memorandumOfAgreementImage = image;
    if (imageType == "acknowledgement") _acknowledgementImage = image;

    print('image is changed: $imageType');

    notifyListeners();
  }

  void updateSpace(String? spaceCode) {
    _space = spaceCode;
    notifyListeners();
  }

  void updateNewVehicle(Vehicle updatedVehicle) {
    _newVehicle = updatedVehicle;
    print('updatedVehicle: $updatedVehicle');
    notifyListeners();
  }

  void updatePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('pageIndex', pageIndex));
  }
}
