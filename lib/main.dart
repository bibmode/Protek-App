import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:protek_tracker/list-new-car/list_new_car.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/no_internet_connection.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/shared_preferences_init.dart';
import 'package:protek_tracker/start/cover_page.dart';
import 'package:protek_tracker/start/start.dart';
import 'package:protek_tracker/tracker/screens/make-payment/make_payment.dart';
import 'package:protek_tracker/tracker/screens/payment_details/payment_details.dart';
import 'package:protek_tracker/tracker/tracker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/vehicle.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs().init(); // Initialize SharedPrefs
  await Supabase.initialize(
    url: 'https://scngrphomkhxwdssipjb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNjbmdycGhvbWtoeHdkc3NpcGpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTA0MTgxMjMsImV4cCI6MjAyNTk5NDEyM30.mJ3gbqzVtVXdommYS5g39r7vWu3op2CLJKUOGYN4qUk',
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => NewVehicle()),
      ChangeNotifierProvider(create: (_) => VehicleTracked()),
      ChangeNotifierProvider(create: (_) => MakePayment()),
    ],
    child: MyApp(),
  ));
}

// It's handy to then extract the Supabase client in a variable for later uses
final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String>? _initialRoute;
  late List<Map<String, dynamic>> _freeSpaces;
  late List<Map<String, dynamic>> _allVehicles;
  bool _isconnected = false;
  late StreamSubscription<InternetStatus> _internetSubscription;

/* Theses function are from the start.dart that need to initialize so I put it here in main */
  Future<void> _getAllFreeSpaces() async {
    try {
      final data = await supabase.from('spaces').select().eq('occupied', false);

      _freeSpaces = data;
    } catch (e) {
      // make an error validation here for internet
      print('error is $e');
    }
  }

  Future<void> _getAllVehicles() async {
    try {
      final data = await supabase.from('vehicles').select();
      setState(() {
        _allVehicles = data;
        print('all vehicles :$data');
      });
    } catch (e) {
      print('error is $e');
    }
  }

  void _changeVehicleTracked(String? plateNo) async {
    if (_allVehicles.isEmpty) {
      print('Vehicles data is not yet available.');
      return;
    }

    final vehicleMatch = _allVehicles
        .where((vehicle) => vehicle['plate_no'] == plateNo)
        .toList()[0];

    Vehicle currentVehicle = Vehicle.fromMap(vehicleMatch);
    context.read<VehicleTracked>().updateCurrentVehicle(currentVehicle);
  }
/* *********************************************************************************** */

  @override
  void initState() {
    super.initState();
    // this is for the internet connection status checking.
    _checkInternetConnection();
    @override
    void dispose() {
      _internetSubscription.cancel();
      super.dispose();
    }

    _initialRoute = _determineInitialRoute();
  }

  void _checkInternetConnection() async {
    // Check initial connection status
    _isconnected = await InternetConnection().hasInternetAccess;
    setState(() {});

    // Start listening to connection changes
    _internetSubscription =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      setState(() {
        _isconnected = status == InternetStatus.connected;
      });
    });
  }

  Future<String> _determineInitialRoute() async {
    await _getAllFreeSpaces();
    await _getAllVehicles();
    final initialRoute = await loadInitRoute();
    return initialRoute; // Return the route to FutureBuilder
  }

  Future<String> loadInitRoute() async {
    await Future.delayed(Duration.zero);
    bool? isValidated = SharedPrefs().prefs.getBool('isAuth');
    String? plateNum = SharedPrefs().prefs.getString('plate_no');

    String destination =
        (isValidated == true && _isconnected == true) ? '/tracker' : '/';

    if (isValidated == true) {
      _changeVehicleTracked(plateNum);
    }
    return destination;
  }

  // internet checker screen

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _initialRoute,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        }

        final initialRoute = snapshot.data ?? '/';

        final GoRouter _router = GoRouter(
          initialLocation: initialRoute,
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (BuildContext context, GoRouterState state) {
                return const CoverPage();
              },
            ),
            GoRoute(
              path: '/start',
              builder: (BuildContext context, GoRouterState state) {
                return const StartScreen();
              },
            ),
            GoRoute(
              path: '/tracker',
              builder: (BuildContext context, GoRouterState state) {
                return const TrackerScreen();
              },
              routes: <RouteBase>[
                GoRoute(
                  path: 'payment-details',
                  builder: (BuildContext context, GoRouterState state) {
                    return PaymentDetails(
                      payment: state.extra! as Payment,
                    );
                  },
                ),
                GoRoute(
                  path: 'make-payment',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MakePaymentScreen();
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/list-new-car',
              builder: (BuildContext context, GoRouterState state) {
                return const ListNewCar();
              },
            ),
            GoRoute(
              path: '/nointernet',
              builder: (BuildContext context, GoRouterState state) {
                return NoInternetPage();
              },
            ),
            GoRoute(
              path: '/restart',
              builder: (BuildContext context, GoRouterState state) {
                return MyApp();
              },
            ),
          ],
        );

        return MaterialApp.router(
          routerConfig: _router,
          title: 'Protek',
          theme: ThemeData.light().copyWith(
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.amber.shade100,
                foregroundColor: Colors.black87,
                side: BorderSide(color: Colors.yellow.shade100),
                textStyle: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
