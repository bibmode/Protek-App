import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/list-new-car/screens/check_details.dart';
import 'package:protek_tracker/list-new-car/screens/confirm.dart';
import 'package:protek_tracker/list-new-car/screens/general-info.dart';
import 'package:protek_tracker/list-new-car/screens/legal_papers.dart';
import 'package:protek_tracker/list-new-car/screens/pictures.dart';
import 'package:protek_tracker/list-new-car/screens/teller_login.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/tracker/widgets/appbar_step.dart';
import 'package:provider/provider.dart';

class ListNewCar extends StatefulWidget {
  const ListNewCar({Key? key}) : super(key: key);

  @override
  _ListNewCarState createState() => _ListNewCarState();
}

class _ListNewCarState extends State<ListNewCar> {
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
    int currentPageIndex = context.watch<NewVehicle>().pageIndex;

    List<Widget> enlistmentScreens = [
      GeneralInfo(hideStepsController: _hideStepsController),
      Pictures(hideStepsController: _hideStepsController, showSteps: showSteps),
      LegalPapers(
          hideStepsController: _hideStepsController, showSteps: showSteps),
      // step 4
      CheckDetails(
          hideStepsController: _hideStepsController, showSteps: showSteps),
      TellerLogin(showSteps: showSteps),
      Confirm(showSteps: showSteps),
    ];

    List<bool> resizePageSetting = [true, true, true, true, false, false];

    return Scaffold(
      resizeToAvoidBottomInset: resizePageSetting[currentPageIndex],
      appBar: AppBar(
        toolbarHeight: 90,
        scrolledUnderElevation: 0,
        title: const Text('List a New Car'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<NewVehicle>().restoreNew();
                context.go('/');
              },
              icon: const Icon(Icons.exit_to_app)),
        ],
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, _isVisible ? 60 : 5),
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
                  widthFactor: currentPageIndex == 0
                      ? 0.1
                      : currentPageIndex == 1
                          ? 0.4
                          : currentPageIndex == 2
                              ? 0.6
                              : currentPageIndex == 5
                                  ? 1.0
                                  : 0.9,
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
                        ? GestureDetector(
                            onTap: currentPageIndex > 0
                                ? () {
                                    context
                                        .read<NewVehicle>()
                                        .updatePageIndex(0);
                                  }
                                : null,
                            child: AppBarStep(
                              number: '1',
                              title: 'General\nInfo',
                              done: currentPageIndex >= 0 ? true : false,
                            ),
                          )
                        : Container(),
                    _isVisible
                        ? GestureDetector(
                            onTap: currentPageIndex > 1
                                ? () {
                                    context
                                        .read<NewVehicle>()
                                        .updatePageIndex(1);
                                  }
                                : null,
                            child: AppBarStep(
                              number: '2',
                              title: 'Pictures',
                              done: currentPageIndex >= 1 ? true : false,
                            ),
                          )
                        : Container(),
                    _isVisible
                        ? GestureDetector(
                            onTap: currentPageIndex > 2
                                ? () {
                                    context
                                        .read<NewVehicle>()
                                        .updatePageIndex(2);
                                  }
                                : null,
                            child: GestureDetector(
                              child: AppBarStep(
                                number: '3',
                                title: 'Legal\nPapers',
                                done: currentPageIndex >= 2 ? true : false,
                              ),
                            ),
                          )
                        : Container(),
                    _isVisible
                        ? AppBarStep(
                            number: '4',
                            title: 'Confirm',
                            done: currentPageIndex >= 3 ? true : false,
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: enlistmentScreens[currentPageIndex],
    );
  }
}
