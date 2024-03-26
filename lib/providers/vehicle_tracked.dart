import 'package:flutter/foundation.dart';
import 'package:protek_tracker/models/vehicle.dart';

class VehicleTracked with ChangeNotifier, DiagnosticableTreeMixin {
  int _pageIndex = 0;
  Vehicle _currentVehicle = Vehicle();

  int get pageIndex => _pageIndex;
  Vehicle get currentVehicle => _currentVehicle;

  void restoreNew() {
    _pageIndex = 0;
    _currentVehicle = Vehicle();
    notifyListeners();
  }

  void updateCurrentVehicle(Vehicle updatedVehicle) {
    _currentVehicle = updatedVehicle;
    notifyListeners();
  }

  void updatePageIndex(int index) {
    _pageIndex = index;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('pageIndex', pageIndex));
  }
}
