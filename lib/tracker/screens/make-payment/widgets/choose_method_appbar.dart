import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:provider/provider.dart';

class ChooseMethodAppbar extends StatefulWidget {
  ChooseMethodAppbar({Key? key}) : super(key: key);

  @override
  State<ChooseMethodAppbar> createState() => _ChooseMethodAppbarState();
}

class _ChooseMethodAppbarState extends State<ChooseMethodAppbar> {
  @override
  Widget build(BuildContext context) {
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
              onPressed: chosenPaymentMethod != null
                  ? () => context.read<MakePayment>().updateStepIndex(3)
                  : null,
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
