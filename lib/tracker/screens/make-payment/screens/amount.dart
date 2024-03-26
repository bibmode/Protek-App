import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:provider/provider.dart';

// helper functions
import 'package:protek_tracker/helpers/functions.dart';

class Amount extends StatefulWidget {
  Amount({Key? key, required this.showSteps}) : super(key: key);

  final VoidCallback showSteps;

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  String? value;

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
    Vehicle currentVehicle = context.watch<VehicleTracked>().currentVehicle;

    // values
    // balance
    DateTime now = DateTime.now();
    DateTime checkInDate = DateTime.parse(currentVehicle.createdAt!);
    int numberOfDays = daysBetween(checkInDate, now);

    double? paid = context.read<VehicleTracked>().currentVehicle.paid ?? 0;
    double? dailyRate = context.read<VehicleTracked>().currentVehicle.dailyRate;
    double rent = (dailyRate! * numberOfDays);
    double security = (rent * 0.06).round() * 1.0;
    double insurance = (rent * 0.08).round() * 1.0;
    double legal = (rent * 0.03).round() * 1.0;
    double admin = (rent * 0.12).round() * 1.0;
    double vat = (rent * 0.12).round() * 1.0;
    double others = (rent * 0.1).round() * 1.0;
    double total = security + insurance + legal + admin + vat + rent + others;
    double unpaid = total - paid;

    void addValue(String newVal) {
      setState(() {
        value = value != null ? '$value$newVal' : newVal;
      });
    }

    void erase() {
      if (value != null) {
        if (value!.contains('.')) {
          bool secondToLast = '$value'.indexOf('.') == '$value'.length - 2;

          if (secondToLast) {
            String newVal = value!.substring(0, value!.indexOf('.'));

            setState(() {
              value = newVal;
            });
          } else {
            String newVal = value!.substring(0, value!.length - 1);

            setState(() {
              value = newVal;
            });
          }
        } else {
          if (value!.length > 1) {
            String newVal = value!.substring(0, value!.length - 1);

            setState(() {
              value = newVal;
            });
          } else {
            setState(() {
              value = null;
            });
          }
        }
      }
    }

    void showError(String errorMessage) {
      final snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );

      // Find the ScaffoldMessenger in the widget tree
      // and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void goToNextStep() {
      // check if value exceeds current balance or less than 50 pesos
      double parsedValue = double.parse(value!);

      if (parsedValue < 50) {
        showError('Error! Amount must be atleast ₱ 50');
      } else if (parsedValue > unpaid) {
        showError('Error! Amount exceeds ₱ $unpaid');
      } else {
        // update subtotal value
        context.read<MakePayment>().updatePaymentSubTotal(double.parse(value!));

        // go to next step
        context.read<MakePayment>().updateStepIndex(2);
      }
    }

    return Column(
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter amount to pay',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
              const Padding(padding: EdgeInsets.all(5)),
              RichText(
                text: TextSpan(
                    text: '₱',
                    style: const TextStyle(fontSize: 45, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: ' ${value ?? '0.00'}',
                        style: TextStyle(
                          color:
                              value != null ? Colors.black87 : Colors.black26,
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.black12),
            ),
          ),
          child: Center(
              child: Text(
            'Balance - ₱ $unpaid',
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          )),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.black12),
            ),
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(8)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      addValue('1');
                    },
                    child: const Text(
                      '1',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('2');
                    },
                    child: const Text(
                      '2',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('3');
                    },
                    child: const Text(
                      '3',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      addValue('4');
                    },
                    child: const Text(
                      '4',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('5');
                    },
                    child: const Text(
                      '5',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('6');
                    },
                    child: const Text(
                      '6',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      addValue('7');
                    },
                    child: const Text(
                      '7',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('8');
                    },
                    child: const Text(
                      '8',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('9');
                    },
                    child: const Text(
                      '9',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: value != null && value!.contains('.') == false
                        ? () {
                            addValue('.');
                          }
                        : null,
                    child: const Text(
                      '.',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      addValue('0');
                    },
                    child: const Text(
                      '0',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: erase,
                    child: const Icon(
                      Icons.backspace_outlined,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12.0,
                ),
                child: OutlinedButton(
                  onPressed: value != null ? goToNextStep : null,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: const Center(child: Text('CONTINUE')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
