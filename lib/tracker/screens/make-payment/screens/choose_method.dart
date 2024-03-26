import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/detail_row.dart';
import 'package:protek_tracker/tracker/screens/make-payment/widgets/choose_method_appbar.dart';
import 'package:protek_tracker/tracker/screens/make-payment/widgets/payment_summary.dart';
import 'package:provider/provider.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';

class ChooseMethod extends StatefulWidget {
  const ChooseMethod(
      {Key? key, required this.hideStepsController, required this.showSteps})
      : super(key: key);

  final ScrollController hideStepsController;
  final VoidCallback showSteps;

  @override
  _ChooseMethodState createState() => _ChooseMethodState();
}

class _ChooseMethodState extends State<ChooseMethod> {
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

    return SingleChildScrollView(
      controller: widget.hideStepsController,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(10)),
          // CHOOSE PAYMENT METHOD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CHOOSE YOUR PREFFERED METHOD',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(7)),
                OutlinedButton(
                  onPressed: () {
                    context.read<MakePayment>().updatePaymentMethod('gcash');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: chosenPaymentMethod == 'gcash'
                        ? Colors.yellow.shade50
                        : Colors.transparent,
                    side: BorderSide(
                      color: chosenPaymentMethod == 'gcash'
                          ? Colors.yellow.shade600
                          : Colors.black26,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // method image
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(right: 18),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Image(
                            fit: BoxFit.cover,
                            image: AssetImage('lib/images/gcash.png'),
                          ),
                        ),
                        // name
                        Text(
                          'GCash',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                OutlinedButton(
                  onPressed: () {
                    context.read<MakePayment>().updatePaymentMethod('cash');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: chosenPaymentMethod == 'cash'
                        ? Colors.yellow.shade50
                        : Colors.transparent,
                    side: BorderSide(
                      color: chosenPaymentMethod == 'cash'
                          ? Colors.yellow.shade600
                          : Colors.black26,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // method image
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(right: 18),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Icon(
                            Icons.store,
                            size: 50,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        // name
                        Text(
                          'Cash on Branch',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                OutlinedButton(
                  onPressed: () {
                    context.read<MakePayment>().updatePaymentMethod('cheque');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: chosenPaymentMethod == 'cheque'
                        ? Colors.yellow.shade50
                        : Colors.transparent,
                    side: BorderSide(
                      color: chosenPaymentMethod == 'cheque'
                          ? Colors.yellow.shade600
                          : Colors.black26,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        // method image
                        Container(
                          height: 50,
                          width: 50,
                          margin: const EdgeInsets.only(right: 18),
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Iconify(
                              Mdi.checkbook,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        // name
                        Text(
                          'Cheque',
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 28, 0, 20),
            child: Divider(
              height: 1.5,
              color: Colors.grey.shade300,
            ),
          ),

          // PAYMENT SUMMARY
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const PaymentSummary(),
          ),
          const Padding(padding: EdgeInsets.all(10)),
        ],
      ),
    );
  }
}
