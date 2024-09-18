import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:protek_tracker/tracker/screens/make-payment/in_app_payment_webview.dart';
import 'package:protek_tracker/tracker/screens/make-payment/paymongo_services.dart';
import 'package:provider/provider.dart';

class ChooseMethodAppbar extends StatefulWidget {
  ChooseMethodAppbar({Key? key}) : super(key: key);

  @override
  State<ChooseMethodAppbar> createState() => _ChooseMethodAppbarState();
}

class _ChooseMethodAppbarState extends State<ChooseMethodAppbar> {
  PayMongoService payMongoService = PayMongoService();

  /// ***********************************************************************
  // function for calling the inappwebview
  void openInAppView(BuildContext context, String url, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenWebView(
          url: url,
          id: id,
        ),
      ),
    );
  }

  int finalValue(String val) {
    try {
      // Parse the string to a double
      double number = double.parse(val);
      // Multiply by 100 to shift the decimal two places to the right
      int result = (number * 100).toInt();
      return result;
    } catch (e) {
      // Handle parsing errors or any unexpected exceptions
      print('Error parsing the string to integer: $e');
      return 0; // or handle the error as appropriate for your use case
    }
  }

  // Proccess the payment
  Future<void> processPayment(String amount, String description) async {
    try {
      dynamic response = await payMongoService.createPaymenLink(
          amount: finalValue(amount),
          description: description,
          remarks: "Protek Payment for car balance");
      print('Payment Intent Response: $response');

      Map<String, dynamic> responseMap = response as Map<String, dynamic>;

      String checkoutUrl = responseMap['data']['attributes']['checkout_url'];
      String id = responseMap['data']['id'];

      print('Checkout URL: $checkoutUrl');
      print('ID: $id');

      openInAppView(context, checkoutUrl, id);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  /// ********************************************************************************

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;
    String? chosenPaymentMethod = context.watch<MakePayment>().method;

    var valueFormat = NumberFormat("###,###.0#", "en_US");

    double subtotal = context.read<MakePayment>().paymentSubTotal;

    return BottomAppBar(
      elevation: 0,
      height: 130,
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Spacer(),
                Text(
                  '₱ ${valueFormat.format(subtotal)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 12.0,
            ),
            child: OutlinedButton(
              onPressed: () async {
                // if (chosenPaymentMethod == 'online-payment') {
                await processPayment(
                    subtotal.toString(), 'Pay ${currentVehicle.make} balance');
                SharedPrefs().prefs.setBool('online-payment', true);
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //         content: Center(
                //             child: Text('Please select payment method'))),
                //   );
                // }
              },

              // chosenPaymentMethod != null
              //     ? () => context.read<MakePayment>().updateStepIndex(3)
              //     : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text('CONTINUE')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
