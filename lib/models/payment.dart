class Payment {
  Payment({
    this.id,
    this.vehicleId,
    this.branchId,
    this.method,
    this.gcashReceipt,
    this.subTotal,
    this.total,
    this.date,
    this.verifiedDate,
    this.validated,
    this.error,
  });

  int? id;
  int? vehicleId;
  String? branchId;
  String? method;
  String? gcashReceipt;
  String? subTotal;
  String? total;
  String? date;
  String? verifiedDate;
  bool? validated;
  bool? error;

  Payment.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        vehicleId = map['vehicle'],
        branchId = map['branch'],
        method = map['method'],
        gcashReceipt = map['gcash_receipt'],
        subTotal = map['subtotal'].toString(),
        total = map['total'].toString(),
        validated = map['validated'],
        error = map['error'],
        verifiedDate = map['verified_date'].toString(),
        date = map['created_at'].toString();
}
