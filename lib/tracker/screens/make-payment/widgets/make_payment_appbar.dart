import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MakeAPaymentAppBar extends StatefulWidget {
  const MakeAPaymentAppBar({
    super.key,
  });

  @override
  State<MakeAPaymentAppBar> createState() => _MakeAPaymentAppBarState();
}

class _MakeAPaymentAppBarState extends State<MakeAPaymentAppBar> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black12, width: 1.5),
        ),
      ),
      child: BottomAppBar(
        elevation: 0,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18),
            //   child: Row(
            //     children: [
            //       const Text(
            //         'TOTAL',
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 17,
            //         ),
            //       ),
            //       const Spacer(),
            //       Text(
            //         '₱ ${context.read<MakePayment>().paymentTotal}0',
            //         style: const TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 17,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                // vertical: 12.0,
              ),
              child: OutlinedButton(
                onPressed: !loading
                    ? () {
                        context.read<MakePayment>().updateStepIndex(1);
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
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 215, 163, 17),
                            ),
                          ),
                        )
                      : const Center(child: Text('I ACCEPT & CONTINUE')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
