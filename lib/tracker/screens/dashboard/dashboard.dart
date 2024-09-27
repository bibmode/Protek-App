import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/detail_row.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/image_carousel.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/legal_dialogs/acknowledgement_dialog.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/legal_dialogs/memorandum_dialog.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/legal_paper_button.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/legal_dialogs/affidavit_dialog.dart';
import 'package:provider/provider.dart';

// helper functions
import 'package:protek_tracker/helpers/functions.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isMounted = false;
  bool loading = false;
  late List<String?> _vehicleImages;
  late List<String?> _legalImages;
  String? _branchName = '';
  String? _tellerName = '';
  String? _parkingLot = '';

  String affidavit =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  void _changeVehicleTracked() async {
    // get the vehicle from the list
    try {
      final vehicleMatch = await supabase
          .from('vehicles')
          .select()
          .eq('id', context.read<VehicleTracked>().currentVehicle.id!);

      // make new Vehicle instance
      Vehicle currentVehicle = Vehicle.fromMap(vehicleMatch.first);

      // update vehicle in provider
      if (mounted) {
        context.read<VehicleTracked>().updateCurrentVehicle(currentVehicle);
      }
    } catch (e) {
      print("Error in changeVehicleTracked(): $e");
    }
  }

  String? getImageURL(String? imagePath) {
    if (imagePath != null) {
      return 'https://scngrphomkhxwdssipjb.supabase.co/storage/v1/object/public/$imagePath';
    }

    return null;
  }

  void getBranchName() async {
    try {
      // Get the vehicle from the list
      final branch = await supabase
          .from('branches')
          .select('branch_name')
          .eq('id', context.read<VehicleTracked>().currentVehicle.branchId!)
          .single(); // Use .single() to fetch a single record

      if (_isMounted) {
        setState(() {
          _branchName = branch['branch_name'];
        });
      }
    } catch (error) {
      // Handle error and update state or UI accordingly
      if (_isMounted) {
        setState(() {
          _branchName = 'Error fetching branch name';
        });
        print('Error fetching branch name: $error');
      }
    }
  }

  void getParkingLot() {
    try {
      String spaceCode = context.read<VehicleTracked>().currentVehicle.space!;
      String phase = spaceCode.substring(
          spaceCode.indexOf('p'), spaceCode.indexOf('p') + 2);
      String lot =
          spaceCode.substring(spaceCode.indexOf('p') + 2, spaceCode.length);

      setState(() {
        _parkingLot = '${phase.toUpperCase()} - ${lot.toUpperCase()}';
      });
    } catch (e) {
      print("Error in executing getParkingLot():  $e");
    }
  }

  void getTellerName() async {
    // get the vehicle from the list
    try {
      final teller = await supabase
          .from('tellers')
          .select('name')
          .eq('id', context.read<VehicleTracked>().currentVehicle.tellerId!);

      print('teller: $teller');

      if (_isMounted) {
        setState(() {
          _tellerName = teller[0]['name'];
        });
      }
    } catch (e) {
      print("Error in getTellerName(): $e");
    }
  }

  // get payments of user
  void checkForPendingPayments() async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('vehicle', context.read<VehicleTracked>().currentVehicle.id!)
        .eq('validated', false);

    if (!mounted) return; // Check if the widget is still mounted

    if (data.isNotEmpty) {
      context.read<MakePayment>().updatePendingPayment(true);
    } else {
      context.read<MakePayment>().updatePendingPayment(false);
    }

    print('payments: $data');
  }

  // get payments of user
  void getPayments() async {
    final data = await supabase
        .from('payments')
        .select()
        .eq('vehicle', context.read<VehicleTracked>().currentVehicle.id!)
        .eq('validated', true)
        .eq('error', false);

    if (data.isNotEmpty) {
      context.read<MakePayment>().updatePendingPayment(true);
    } else {
      context.read<MakePayment>().updatePendingPayment(false);
    }

    print('payments: $data');
  }

  List<String?> getVehicleImages() {
    // imageLinks
    String? picFront =
        getImageURL(context.read<VehicleTracked>().currentVehicle.picFront);
    String? picBack =
        getImageURL(context.read<VehicleTracked>().currentVehicle.picBack);
    String? picLeft =
        getImageURL(context.read<VehicleTracked>().currentVehicle.picLeft);
    String? picRight =
        getImageURL(context.read<VehicleTracked>().currentVehicle.picRight);
    String? picInterior =
        getImageURL(context.read<VehicleTracked>().currentVehicle.picInterior);

    // setup the array
    List<String?> imageURLs = [
      picFront,
      picBack,
      picLeft,
      picRight,
      picInterior
    ];

    imageURLs.removeWhere((element) => element == null);

    return imageURLs;
  }

  List<String?> getLegalImages() {
    // imageLinks
    String? picAcknowledgement = getImageURL(
        context.read<VehicleTracked>().currentVehicle.legalAcknowledgement);
    String? picMemorandum = getImageURL(
        context.read<VehicleTracked>().currentVehicle.legalMemorandum);
    String? picAffidavit = getImageURL(
        context.read<VehicleTracked>().currentVehicle.legalAffidavit);

    // setup the array
    List<String?> imageURLs = [
      picAcknowledgement,
      picMemorandum,
      picAffidavit,
    ];

    return imageURLs;
  }

  @override
  void initState() {
    _isMounted = true;
    _vehicleImages = getVehicleImages();
    _legalImages = getLegalImages();
    checkForPendingPayments();
    _changeVehicleTracked();
    getBranchName();
    getTellerName();
    getParkingLot();
    super.initState();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;

    int numberOfDays;
    // values
    // balance
    DateTime now = DateTime.now();
    DateTime checkInDate = DateTime.parse(currentVehicle.dateOfCheckIn!);
    DateTime? checkOut = currentVehicle.dateOfCheckOut != null
        ? DateTime.parse(currentVehicle.dateOfCheckOut!)
        : null;

    if (checkOut == null) {
      numberOfDays = daysBetween(checkInDate, now) + 1;
    } else {
      numberOfDays = daysBetween(checkInDate, checkOut) + 1;
    }

    double? paid = context.read<VehicleTracked>().currentVehicle.paid ?? 0;
    double? dailyRate = context.read<VehicleTracked>().currentVehicle.dailyRate;
    double rent = (dailyRate! * numberOfDays);
    print('num checkout: $numberOfDays');
    double security = (rent * 0.06).round() * 1.0;
    double insurance = (rent * 0.08).round() * 1.0;
    double legal = (rent * 0.03).round() * 1.0;
    double admin = (rent * 0.02).round() * 1.0;
    double vat = (rent * 0.12).round() * 1.0;
    double others = (rent * 0.1).round() * 1.0;
    double total = security + insurance + legal + admin + vat + rent + others;
    double unpaid = total - paid;

    String formatDateTime(String? input) {
      // Check if the input is null or empty
      if (input == null || input.isEmpty) {
        return '-';
      }

      try {
        DateTime dateTime = DateTime.parse(input.split('.')[0]);
        DateFormat dateFormat = DateFormat('MMM d, yyyy h:mm a');
        return dateFormat.format(dateTime);
      } catch (e) {
        return '-';
      }
    }

    String formatDigits(double number) {
      final NumberFormat formatter = NumberFormat('₱ #,##0.00');
      return formatter.format(number);
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ImageCarousel(carImages: _vehicleImages),
            const Padding(padding: EdgeInsets.all(15)),
            // const Text('Balance'),
            // Text(
            //   '₱ $balance',
            //   style: const TextStyle(
            //       fontSize: 40.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black87),
            // ),
            // const Padding(padding: EdgeInsets.all(4)),
            // OutlinedButton(
            //   onPressed: () => context.push('/tracker/make-payment'),
            //   child: const Text('MAKE A PAYMENT'),
            // ),
            // const Padding(padding: EdgeInsets.all(26)),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Divider(
            //     height: 1.5,
            //     color: Colors.grey.shade300,
            //   ),
            // ),

            // VEHICLE INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VEHICLE INFORMATION',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Make',
                    data: currentVehicle.make ?? '-',
                  ),
                  DetailRow(
                    title: 'Type',
                    data: currentVehicle.type ?? '-',
                  ),
                  DetailRow(
                    title: 'Series',
                    data: currentVehicle.series ?? '-',
                  ),
                  DetailRow(
                    title: 'Year Model',
                    data: currentVehicle.yearModel ?? '-',
                  ),
                  DetailRow(
                    title: 'Color',
                    data: currentVehicle.color ?? '-',
                  ),
                  DetailRow(
                    title: 'Plate No.',
                    data: currentVehicle.plateNo ?? '-',
                  ),
                  DetailRow(
                    title: 'Engine No.',
                    data: currentVehicle.engineNo ?? '-',
                  ),
                  DetailRow(
                    title: 'Serial/Chassis No.',
                    data: currentVehicle.serialNo ?? '-',
                  ),
                  DetailRow(
                    title: 'MV File No.',
                    data: currentVehicle.mvFileNo ?? '-',
                  ),
                  DetailRow(
                    title: 'C.R. No.',
                    data: currentVehicle.crNo ?? '-',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // OWNER INFORMATION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'OWNER INFORMATION',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Full Name',
                    data: currentVehicle.ownerName ?? '-',
                  ),
                  DetailRow(
                    title: 'Email',
                    data: currentVehicle.ownerEmail ?? '-',
                  ),
                  DetailRow(
                    title: 'Phone Number',
                    data: currentVehicle.ownerPhone ?? '-',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // VEHICLE STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VEHICLE STATUS',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Gas',
                    data: '${currentVehicle.gas} litres',
                  ),
                  DetailRow(
                    title: 'Mileage',
                    data: '${currentVehicle.mileage} mi',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // VEHICLE DAMAGES
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VEHICLE DAMAGES',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  if (currentVehicle.damages != null &&
                      currentVehicle.damages!.isNotEmpty)
                    ...currentVehicle.damages!.map(
                      (damage) => Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '${currentVehicle.damages!.indexOf(damage) + 1}. $damage',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  if (currentVehicle.damages!.isEmpty)
                    Container(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'No damages listed.',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // LEGAL PAPERS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LEGAL PAPERS',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  // affidavit
                  currentVehicle.dateOfCheckOut != null
                      ? const Padding(padding: EdgeInsets.all(10))
                      : Container(),
                  currentVehicle.dateOfCheckOut != null
                      ? Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Affidavit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(3)),
                              Text(
                                affidavit,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Padding(padding: EdgeInsets.all(5)),
                              OutlinedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AffidavitDialog(
                                            affidavit: affidavit);
                                      });
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Read More',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  // Memorandum of Agreement
                  const Padding(padding: EdgeInsets.all(15)),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Memorandum of Agreement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Text(
                          affidavit,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MemorandumDialog();
                                });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Read More',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Acknowlegement
                  const Padding(padding: EdgeInsets.all(15)),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Acknowlegement',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Text(
                          affidavit,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AcknowledgementDialog();
                                });
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Read More',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ..._legalImages.map((legal) {
                  //   // get index of image link
                  //   int index = _legalImages.indexOf(legal);

                  //   // extract paper title
                  //   String paperTitle = index == 0
                  //       ? 'Affidavit'
                  //       : index == 1
                  //           ? 'Memorandum of Agreement'
                  //           : 'Acknowledgement';

                  //   if (legal != null) {
                  //     return LegalPaperButton(
                  //         imageLink: legal, paperTitle: paperTitle);
                  //   } else {
                  //     return Container();
                  //   }
                  // }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // IMPOUND STATUS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IMPOUND STATUS',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Branch',
                    data: '$_branchName',
                  ),
                  DetailRow(
                    title: 'Parking Lot',
                    data: '$_parkingLot',
                  ),
                  DetailRow(
                    title: 'Check-in',
                    data: formatDateTime(checkInDate.toString()),
                    //data: currentVehicle.dateOfCheckIn ?? '-',
                  ),
                  DetailRow(
                    title: 'Daily Rate',
                    data: '₱ $dailyRate',
                  ),
                  DetailRow(
                    title: 'No. of Days',
                    data: '$numberOfDays',
                  ),
                  DetailRow(
                    title: 'Check-out',
                    data: formatDateTime(currentVehicle.dateOfCheckOut),
                    //data: currentVehicle.dateOfCheckOut ?? '-',
                  ),
                  DetailRow(
                    title: 'Cashier',
                    data: '$_tellerName',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // FINANCIAL BREAKDOWN
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FINANCIAL BREAKDOWN',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Rental Fee',
                    //data: '₱ $rent',
                    data: formatDigits(rent),
                  ),
                  DetailRow(
                    title: 'Security Fees',
                    //data: '₱ $security',
                    data: formatDigits(security),
                  ),
                  DetailRow(
                    title: 'Insurance',
                    //data: '₱ $insurance',
                    data: formatDigits(insurance),
                  ),
                  DetailRow(
                    title: 'Legal Fees',
                    //data: '₱ $legal',
                    data: formatDigits(legal),
                  ),
                  DetailRow(
                    title: 'Administration Fees',
                    //data: '₱ $admin',
                    data: formatDigits(admin),
                  ),
                  DetailRow(
                    title: 'VAT (12%)',
                    //data: '₱ $vat',
                    data: formatDigits(vat),
                  ),
                  DetailRow(
                    title: 'Other Taxes',
                    //data: '₱ $others',
                    data: formatDigits(others),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            // PAID UNPAID
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'FINANCIAL SUMMARY',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                      title: 'Total Fees',
                      //data: '₱ $total',
                      data: formatDigits(total)),
                  DetailRow(
                    title: 'Paid',
                    //data: '₱ $paid',
                    data: formatDigits(paid),
                  ),
                  DetailRow(
                    title: 'Unpaid',
                    //data: '₱ $unpaid',
                    data: formatDigits(unpaid),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      const Text(
                        'UNPAID BALANCE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        //'₱ $unpaid',
                        formatDigits(unpaid),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
                  child: OutlinedButton(
                    onPressed: () => context.push('/tracker/make-payment'),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      child: loading
                          ? const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Color.fromARGB(255, 215, 163, 17),
                                ),
                              ),
                            )
                          : const Center(child: Text('MAKE A PAYMENT')),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
