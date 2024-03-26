import 'dart:io';

import 'package:flutter/foundation.dart';

class MakePayment with ChangeNotifier, DiagnosticableTreeMixin {
  int _stepIndex = 0;
  double _paymentSubTotal = 0;
  String? _paymentTotal;
  String? _method;
  File? _gcashReceipt;
  bool _pendingPayment = false;

  int get stepIndex => _stepIndex;
  double get paymentSubTotal => _paymentSubTotal;
  String? get paymentTotal => _paymentTotal;
  String? get method => _method;
  File? get gcashReceipt => _gcashReceipt;
  bool get pendingPayment => _pendingPayment;

  void updatePendingPayment(bool status) {
    _pendingPayment = status;
    notifyListeners();
  }

  void updateGCashReceipt(File image) {
    _gcashReceipt = image;
    notifyListeners();
  }

  void restoreNew() {
    _stepIndex = 0;
    _paymentSubTotal = 0;
    _paymentTotal = null;
    _method = null;
    _gcashReceipt = null;
    notifyListeners();
  }

  void updateStepIndex(int index) {
    _stepIndex = index;
    notifyListeners();
  }

  void updatePaymentMethod(String newMethod) {
    _method = newMethod;
    notifyListeners();
  }

  void updatePaymentSubTotal(double newVal) {
    _paymentSubTotal = newVal;
    notifyListeners();
  }

  void updatePaymentTotal(String newVal) {
    _paymentTotal = newVal;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('stepIndex', stepIndex));
  }
}
