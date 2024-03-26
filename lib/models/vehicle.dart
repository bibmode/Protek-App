class Vehicle {
  Vehicle({
    this.id,
    this.tellerId,
    this.branchId,
    this.dailyRate,
    this.paid,
    this.space,
    this.color,
    this.createdAt,
    this.dateOfCheckIn,
    this.dateOfCheckOut,
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    this.make,
    this.type,
    this.series,
    this.yearModel,
    this.plateNo,
    this.engineNo,
    this.serialNo,
    this.mvFileNo,
    this.crNo,
    this.gas,
    this.mileage,
    this.damages,
    this.picFront,
    this.picBack,
    this.picLeft,
    this.picRight,
    this.picInterior,
    this.legalAffidavit,
    this.legalMemorandum,
    this.legalAcknowledgement,
  });

  int? id;
  String? tellerId;
  String? branchId;
  double? dailyRate;
  double? paid;
  String? space;
  String? color;
  String? createdAt;
  String? dateOfCheckIn;
  String? dateOfCheckOut;
  String? ownerName;
  String? ownerEmail;
  String? ownerPhone;
  String? make;
  String? type;
  String? series;
  String? yearModel;
  String? plateNo;
  String? engineNo;
  String? serialNo;
  String? mvFileNo;
  String? crNo;
  String? gas;
  String? mileage;
  List<String>? damages = [];
  String? picFront;
  String? picBack;
  String? picLeft;
  String? picRight;
  String? picInterior;
  String? legalAffidavit;
  String? legalMemorandum;
  String? legalAcknowledgement;

  void updateTellerId(String newID) {
    tellerId = newID;
  }

  void updateBranchId(String newID) {
    branchId = newID;
  }

  Vehicle.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        tellerId = map['teller_id'],
        branchId = map['branch_id'],
        dailyRate = double.parse(map['daily_rate'].toString()),
        paid = double.parse(map['paid'].toString()),
        space = map['space'],
        color = map['color'],
        createdAt = map['created_at'].toString(),
        dateOfCheckIn = map['date_of_checkin'],
        dateOfCheckOut = map['date_of_checkout'],
        ownerName = map['owner_name'],
        ownerEmail = map['owner_email'],
        ownerPhone = map['owner_phone'],
        make = map['make'],
        type = map['type'],
        series = map['series'],
        yearModel = map['year_model'],
        plateNo = map['plate_no'],
        engineNo = map['engine_no'],
        serialNo = map['serial_no'],
        mvFileNo = map['mv_file_no'],
        crNo = map['cr_no'],
        gas = map['gas'],
        mileage = map['mileage'],
        damages = List<String>.from(map['damages']),
        picFront = map['pic_front'],
        picBack = map['pic_back'],
        picLeft = map['pic_left'],
        picRight = map['pic_right'],
        picInterior = map['pic_interior'],
        legalAffidavit = map['legal_affidavit'],
        legalMemorandum = map['legal_memorandum'],
        legalAcknowledgement = map['legal_acknowledgement'];
}
