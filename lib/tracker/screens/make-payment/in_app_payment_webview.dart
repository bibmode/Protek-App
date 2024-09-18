import 'dart:async'; // Import the Timer class
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/make-payment/paymongo_services.dart';
import 'package:provider/provider.dart';

class FullScreenWebView extends StatefulWidget {
  final String url;
  final String id;

  FullScreenWebView({Key? key, required this.url, required this.id})
      : super(key: key);

  @override
  _FullScreenWebViewState createState() => _FullScreenWebViewState();
}

class _FullScreenWebViewState extends State<FullScreenWebView> {
  List<Payment> payments = [];
  int _selectedIndex = 0;
  late PayMongoService payMongoService;
  bool _isButtonEnabled = false; // Initially disable the button
  Timer? _timer; // Timer to periodically check payment status
  String? paymentMethod;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context, rootNavigator: true).pop();
  }

  // Change this for the table name and columns
  // fetchPayments() async {
  //   try {
  //     dynamic response = await supabase
  //         .from('payments')
  //         .select()
  //         .eq('junkshop_id', supabase.auth.currentUser!.id)
  //         .select();

  //     List<Payment> data =
  //         response.map<Payment>((payment) => Payment.fromMap(payment)).toList();

  //     setState(() {
  //       payments = data;
  //     });
  //   } catch (e) {
  //     print('error in fetching payments: $e');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    payMongoService = PayMongoService();
    _retrievePayment(); // Initial check
    _startPeriodicCheck();
  }

  // Method to start a periodic timer
  void _startPeriodicCheck() {
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      _retrievePayment(); // Check payment status every 30 seconds
    });
  }

  Future<void> _retrievePayment() async {
    try {
      dynamic response =
          await payMongoService.retrievePaymentStatus(paymentID: widget.id);
      print("PaymentID response: $response");

      // Check if 'data' and 'attributes' are present
      if (response != null &&
          response.containsKey('data') &&
          response['data'] != null) {
        var data = response['data'];
        var attributes = data['attributes'];

        // Check if 'status' exists in 'attributes'
        if (attributes != null && attributes.containsKey('status')) {
          String paidStatus = attributes['status'];
          print("Payment status: $paidStatus");

          if (paidStatus == 'paid') {
            // Check if 'payments' is present and contains at least one item
            if (attributes.containsKey('payments') &&
                attributes['payments'].isNotEmpty) {
              var paymentSourceType;
              try {
                // Safely access 'type' within the 'source' object
                paymentSourceType = attributes['payments'][0]['data']
                    ['attributes']['source']['type'];
              } catch (e) {
                print('Error accessing payment source type: $e');
              }

              print("Payment method type: $paymentSourceType");

              setState(() {
                _isButtonEnabled = true;
                paymentMethod = paymentSourceType ??
                    'Unknown'; // Default to 'Unknown' if type is null
              });

              //await _updatePayment();
              _timer?.cancel();
            } else {
              print('No payments data available.');
            }
          }
        } else {
          print('Payment status not available.');
        }
      } else {
        print('Response data is null or malformed.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void confirmOnlinePayment(int vehicle, String branch, String subtotal) async {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;
    String sub = subtotal.contains('.') ? subtotal.split('.').first : subtotal;
    int finalSubtotal = int.parse(sub);
    double paid = currentVehicle.paid! + finalSubtotal;
    try {
      // insert a payment in payments table
      final dynamic data = await supabase.from('payments').insert({
        'vehicle': vehicle,
        'validated': true,
        'branch': branch,
        'method': paymentMethod,
        'verified_date': DateTime.now().toIso8601String(),
        'total': subtotal.replaceAll(',', ' ').trim(),
      });
    } catch (e) {
      print("Error in inserting data to payements: $e");
    }

    try {
      // update paid in vehicle
      final dynamic data2 = await supabase
          .from('vehicles')
          .update({'paid': paid}).eq('id', currentVehicle.id!);
    } catch (e) {
      print("Error in updating data in vehicle: $e");
    }
  }

// Insert function
  // Future<void> _updatePayment() async {
  //   final dateNow = DateTime.now();
  //   try {
  //     dynamic response = await supabase
  //         .from('payments')
  //         .update({
  //           'validated': true,
  //           'paid_time': dateNow.toIso8601String(),
  //           'payment_method': paymentMethod,
  //         })
  //         .eq('junkshop_id', supabase.auth.currentUser!.id)
  //         .eq('schedule', widget.paymentSchedule);
  //   } catch (e) {
  //     print("Error in updating Payment Data: $e");
  //   }
  // }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;
    double? dailyRate = context.read<VehicleTracked>().currentVehicle.dailyRate;
    double subtotal = context.read<MakePayment>().paymentSubTotal;

    print('URL VALUE: ${widget.url}');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pay ${currentVehicle.make} balance',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true, // Center the title
        backgroundColor: const Color.fromARGB(
            255, 211, 189, 16), // Set AppBar color to green

        automaticallyImplyLeading: false, // Removes the back arrow button
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.url), // Use WebUri to create the URL request
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                useOnDownloadStart: true,
              ),
              onLoadStop: (controller, url) async {
                print('URL loaded: $url');
                if (url.toString().contains("success")) {
                  await _retrievePayment();
                }
              },
              onLoadError: (controller, url, code, message) {
                print('Error loading $url: $code $message');
              },
              onLoadHttpError: (controller, url, statusCode, description) {
                print('HTTP error loading $url: $statusCode $description');
              },
            ),
          ),
          if (_isButtonEnabled)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Go to step 4 of processing payment
                  confirmOnlinePayment(currentVehicle.id!,
                      currentVehicle.branchId.toString(), subtotal.toString());
                  context.read<MakePayment>().updateStepIndex(4);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 207, 198, 24), // Button color
                  minimumSize:
                      const Size(300, 50), // Set a larger size for the button
                  padding: const EdgeInsets.symmetric(
                      vertical:
                          16.0), // Increase vertical padding inside the button
                  textStyle:
                      const TextStyle(fontSize: 18), // Increase text size
                ),
                child: const Text('Done Paying'),
              ),
            ),
          const SizedBox(height: 35), // Add space between button and bottom
        ],
      ),
    );
  }
}
