import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:provider/provider.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key, required this.showSteps}) : super(key: key);

  final VoidCallback showSteps;

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  bool? isOnlinePayment = SharedPrefs().prefs.getBool('online-payment');

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
    return isOnlinePayment!
        ? Column(
            children: [
              Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'THANK YOU FOR YOUR PAYMENT',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(padding: EdgeInsets.all(4)),
                      Icon(
                        Icons.done_outline,
                        size: 170,
                        color: Colors.yellow.shade700,
                      ),
                      const Padding(padding: EdgeInsets.all(4)),
                      const Text(
                        'THIS PAYMENT HAS BEEN RECORDED',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<MakePayment>().updateStepIndex(0);
                    context.read<MakePayment>().restoreNew();
                    context.pop();
                    SharedPrefs().prefs.remove('online-payment');
                  },
                  child: const Text('OKAY'),
                ),
              )
            ],
          )
        : Column(
            children: [
              Flexible(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'YOUR PAYMENT IS BEING\nVERIFIED. THANK YOU!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(padding: EdgeInsets.all(4)),
                      Icon(
                        Icons.update,
                        size: 170,
                        color: Colors.yellow.shade700,
                      ),
                      const Padding(padding: EdgeInsets.all(4)),
                      const Text(
                        'PLEASE WAIT FOR VERIFICATION TEXT\nBETWEEN 24-48 HOURS',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 0),
                        child: Text(
                          'Please be advised: The indicated time-frame may vary due to technical issues, power outages, or other unforeseen circumstances. Your patience is greatly appreciated.',
                          style: TextStyle(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<MakePayment>().updateStepIndex(0);
                    context.read<MakePayment>().restoreNew();
                    context.pop();
                  },
                  child: const Text('OKAY'),
                ),
              )
            ],
          );
  }
}
