import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/make-payment/widgets/payment_summary.dart';
import 'package:protek_tracker/tracker/widgets/image_container.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Pay extends StatefulWidget {
  Pay({Key? key, required this.hideStepsController, required this.showSteps})
      : super(key: key);

  final ScrollController hideStepsController;
  final VoidCallback showSteps;

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {
  @override
  void initState() {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.showSteps();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? chosenPaymentMethod = context.watch<MakePayment>().method;

    var valueFormat = NumberFormat("###,###.0#", "en_US");

    double subtotal = context.read<MakePayment>().paymentSubTotal;

    String formattedTotal = valueFormat.format(subtotal);

    return chosenPaymentMethod == 'gcash'
        ? GCashPayment(widget: widget, total: formattedTotal)
        : chosenPaymentMethod == 'cash'
            ? CashPayment(widget: widget, total: formattedTotal)
            : ChecquePayment(widget: widget, total: formattedTotal);
  }
}

class GCashPayment extends StatefulWidget {
  const GCashPayment({
    super.key,
    required this.widget,
    required this.total,
  });

  final Pay widget;
  final String total;

  @override
  State<GCashPayment> createState() => _GCashPaymentState();
}

class _GCashPaymentState extends State<GCashPayment> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    void showError() {
      var snackBar = SnackBar(
        content: const Text('Error! Check your internet and try again.'),
        action: SnackBarAction(
          label: 'Okay',
          onPressed: () {},
        ),
      );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Future<String?> uploadReceipt(File? receiptFile) async {
      try {
        if (receiptFile != null) {
          String namePath = receiptFile.path.substring(
              receiptFile.path.lastIndexOf('/'), receiptFile.path.length);

          final String path = await supabase.storage.from('receipts').upload(
                namePath,
                receiptFile,
                fileOptions:
                    const FileOptions(cacheControl: '3600', upsert: false),
              );

          return path;
        } else {
          showError();
        }
      } catch (e) {
        print('upload receipt error: $e');
        showError();
      }

      return null;
    }

    Future<bool> confirmPayment() async {
      // start loader
      setState(() {
        loading = true;
      });

      // gather data
      Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;
      MakePayment makeAPaymentProvider = context.read<MakePayment>();

      try {
        // upload receipt
        String? uploadReceiptUrl =
            await uploadReceipt(makeAPaymentProvider.gcashReceipt);

        if (uploadReceiptUrl != null) {
          // add to payments
          final data = await supabase.from('payments').insert({
            'vehicle': currentVehicle.id,
            'branch': currentVehicle.branchId,
            'method': makeAPaymentProvider.method,
            'gcash_receipt': uploadReceiptUrl,
            'subtotal': widget.total.replaceAll(',', ' ').trim(),
            'total': widget.total.replaceAll(',', ' ').trim(),
          });

          print('payment successfully added');

          return true;
        }

        showError();
        return false;
      } catch (e) {
        print('make a payment: $e');
        showError();

        setState(() {
          loading = false;
        });

        return false;
      }
    }

    return SingleChildScrollView(
      controller: widget.widget.hideStepsController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STEP 1 - PAY ON GCASH',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '1. Open the ',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'GCash',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                      Text(
                        ' app.',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // method image
                      Container(
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/images/gcash.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    children: [
                      Text(
                        '2. Click the "Send" option.',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // method image
                      Container(
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('lib/images/gcash-send.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Row(
                    children: [
                      Text(
                        '3. Choose "Express Send".',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // method image
                      Container(
                        height: 40,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: const Image(
                          fit: BoxFit.cover,
                          image:
                              AssetImage('lib/images/gcash-express-send.jpg'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: [
                      Text(
                        '4. Send ',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₱ ${widget.total}0 ',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'to ',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '09100273409.',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    '5. Download/Screenshot picture of receipt.',
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(16)),
                const Text(
                  'STEP 2 - UPLOAD GCASH RECEIPT',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                ImageContainer(
                    initialImage: context.read<MakePayment>().gcashReceipt),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          // IMPOUND STATUS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const PaymentSummary(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
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
                const Spacer(),
                Text(
                  '₱ ${widget.total}',
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
              onPressed:
                  context.watch<MakePayment>().gcashReceipt != null && !loading
                      ? () async {
                          context
                              .read<MakePayment>()
                              .updatePaymentTotal(widget.total);

                          bool confirmed = await confirmPayment();

                          if (confirmed) {
                            context.read<MakePayment>().updateStepIndex(4);
                          }
                        }
                      : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: loading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : const Center(child: Text('CONFIRM')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CashPayment extends StatefulWidget {
  const CashPayment({Key? key, required this.widget, required this.total})
      : super(key: key);

  final Pay widget;
  final String total;

  @override
  State<CashPayment> createState() => _CashPaymentState();
}

class _CashPaymentState extends State<CashPayment> {
  @override
  Widget build(BuildContext context) {
    List<String> branchItems = ['Butuan City (Main Branch)'];

    String dropDownValue = 'Butuan City (Main Branch)';

    return SingleChildScrollView(
      controller: widget.widget.hideStepsController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STEP 1 - GO TO NEAREST BRANCH',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton(
                      value: dropDownValue,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        fontSize: 16.0,
                      ),
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      items: branchItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropDownValue = value!;
                        });
                      }),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: 35,
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(
                      'Protek Warehouse, Brgy. Silad, Butuan City.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(3)),
                const Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black54,
                      size: 35,
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(
                      '091234567789 / 092344321233',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(18)),
                const Text(
                  'STEP 2 - PAY TO TELLER',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                const Text(
                  'Enter premises with a valid ID and go to branch teller to pay your fees.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          // IMPOUND STATUS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const PaymentSummary(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
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
                const Spacer(),
                Text(
                  '₱ ${widget.total}',
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
              onPressed: () {
                context.read<MakePayment>().updateStepIndex(2);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text('GO BACK')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChecquePayment extends StatefulWidget {
  const ChecquePayment({Key? key, required this.widget, required this.total})
      : super(key: key);

  final Pay widget;
  final String total;

  @override
  State<ChecquePayment> createState() => _ChecquePaymentState();
}

class _ChecquePaymentState extends State<ChecquePayment> {
  @override
  Widget build(BuildContext context) {
    List<String> branchItems = ['Butuan City (Main Branch)'];

    String dropDownValue = 'Butuan City (Main Branch)';

    return SingleChildScrollView(
      controller: widget.widget.hideStepsController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STEP 1 - GO TO A PROTEK BRANCH',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton(
                      value: dropDownValue,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(10),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                        fontSize: 16.0,
                      ),
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      items: branchItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropDownValue = value!;
                        });
                      }),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.black54,
                      size: 35,
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(
                      'Protek Warehouse, Brgy. Silad, Butuan City.',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(3)),
                const Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.black54,
                      size: 35,
                    ),
                    Padding(padding: EdgeInsets.all(3)),
                    Text(
                      '091234567789 / 092344321233',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(18)),
                const Text(
                  'STEP 2 - WRITE YOUR CHEQUE',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                RichText(
                  text: const TextSpan(
                    text: 'To the order of: ',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'PROTEK BRIGHTSTAR',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                RichText(
                  text: TextSpan(
                    text: 'Amount: ',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '₱ ${widget.total}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.all(18)),
                const Text(
                  'STEP 3 - HAND THE CHEQUE TO TELLER',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                const Text(
                  'Enter premises with a valid ID and go to branch teller and hand your cheque.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),
          // IMPOUND STATUS
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: const PaymentSummary(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
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
                const Spacer(),
                Text(
                  '₱ ${widget.total}',
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
              onPressed: () {
                context.read<MakePayment>().updateStepIndex(2);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text('GO BACK')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
