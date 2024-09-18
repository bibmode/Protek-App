import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:protek_tracker/tracker/screens/dashboard/dashboard.dart';
import 'package:protek_tracker/tracker/screens/payments/payments.dart';
import 'package:provider/provider.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({Key? key}) : super(key: key);

  @override
  _TrackerScreenState createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  int currentPageIndex = 0;

  List<Widget> pages = [Dashboard(), Payments()];
  List<PreferredSizeWidget?> appBars = [
    null,
    AppBar(
      toolbarHeight: 80,
      title: const Text('Payments History'),
      shape: const Border(bottom: BorderSide(color: Colors.black12, width: 4)),
    )
  ];
  Future<void> showExitConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text('Confirm Exit', style: TextStyle(color: Colors.black)),
          content: const Text('Are you sure you want to exit?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                context.read<VehicleTracked>().restoreNew();
                SharedPrefs().prefs.remove('isAuth');
                SharedPrefs().prefs.remove('plate_no');
                context.go('/start');
              },
              child: const Text(
                'Exit',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 226, 183, 30),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBars[currentPageIndex],
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index != 2) {
            setState(() {
              currentPageIndex = index;
            });
          } else {
            showExitConfirmationDialog(context);
          }
        },
        indicatorColor: Colors.yellow.shade600,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_rounded),
            label: 'Payments',
          ),
          NavigationDestination(
            icon: Icon(Icons.exit_to_app),
            label: 'Exit',
          ),
        ],
      ),
    );
  }
}
