import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/make-payment/screens/amount.dart';
import 'package:protek_tracker/tracker/screens/make-payment/screens/choose_method.dart';
import 'package:protek_tracker/tracker/screens/make-payment/screens/confirm.dart';
import 'package:protek_tracker/tracker/screens/make-payment/screens/pay.dart';
import 'package:protek_tracker/tracker/screens/make-payment/screens/terms_and_conditions.dart';
import 'package:protek_tracker/tracker/screens/make-payment/widgets/choose_method_appbar.dart';
import 'package:protek_tracker/tracker/screens/make-payment/widgets/make_payment_appbar.dart';
import 'package:protek_tracker/tracker/widgets/appbar_step.dart';
import 'package:provider/provider.dart';
import '../../../models/vehicle.dart';

class MakePaymentScreen extends StatefulWidget {
  const MakePaymentScreen({Key? key}) : super(key: key);

  @override
  _MakePaymentScreenState createState() => _MakePaymentScreenState();
}

class _MakePaymentScreenState extends State<MakePaymentScreen> {
  late ScrollController _hideStepsController;
  late bool _isVisible;

  void showSteps() {
    setState(() {
      _isVisible = true;
    });
  }

  @override
  initState() {
    _isVisible = true;
    _hideStepsController = ScrollController();
    _hideStepsController.addListener(
      () {
        if (_hideStepsController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisible) {
            setState(() {
              _isVisible = false;
            });
          }
        }
        if (_hideStepsController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!_isVisible) {
            setState(() {
              _isVisible = true;
            });
          }
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _hideStepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Vehicle currentVehicle = context.read<VehicleTracked>().currentVehicle;
    bool pendingPayment = context.watch<MakePayment>().pendingPayment;
    int currentStepIndex =
        pendingPayment ? 4 : context.watch<MakePayment>().stepIndex;

    List<Widget> paymentScreens = [
      TermsAndConditions(
          hideStepsController: _hideStepsController, showSteps: showSteps),
      Amount(showSteps: showSteps),
      ChooseMethod(
          showSteps: showSteps, hideStepsController: _hideStepsController),
      Pay(hideStepsController: _hideStepsController, showSteps: showSteps),
      Confirm(showSteps: showSteps),
    ];

    List<Widget?> bottomAppBars = [
      const MakeAPaymentAppBar(),
      null,
      ChooseMethodAppbar(),
      null,
      null
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<MakePayment>().restoreNew();
            Navigator.of(context).pop();
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Make a Payment'),
            Text(
              '${currentVehicle.make}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, _isVisible ? 70 : 5),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 8,
                width: double.infinity,
                color: Colors.black12,
                margin: EdgeInsets.only(top: _isVisible ? 15 : 0),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: currentStepIndex == 0
                      ? 0.1
                      : currentStepIndex == 1
                          ? 0.4
                          : currentStepIndex == 2
                              ? 0.65
                              : currentStepIndex == 3
                                  ? 0.9
                                  : 1,
                  child: Container(
                    height: 8,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: _isVisible ? 15 : 0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isVisible
                        ? AppBarStep(
                            number: '1',
                            title: 'Terms &\nConditions',
                            done: currentStepIndex >= 0,
                          )
                        : Container(),
                    _isVisible
                        ? AppBarStep(
                            number: '2',
                            title: 'Amount',
                            done: currentStepIndex >= 1,
                          )
                        : Container(),
                    _isVisible
                        ? AppBarStep(
                            number: '3',
                            title: 'Payment\nSummary',
                            done: currentStepIndex >= 2,
                          )
                        : Container(),
                    _isVisible
                        ? AppBarStep(
                            number: '4',
                            title: 'Confirm',
                            done: currentStepIndex >= 3,
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: paymentScreens[currentStepIndex],
      bottomNavigationBar: bottomAppBars[currentStepIndex],
    );
  }
}
