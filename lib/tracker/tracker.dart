import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
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
            context.read<VehicleTracked>().restoreNew();
            context.go('/start');
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
