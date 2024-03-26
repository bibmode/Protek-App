import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:protek_tracker/list-new-car/list_new_car.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/start/cover_page.dart';
import 'package:protek_tracker/start/start.dart';
import 'package:protek_tracker/tracker/screens/make-payment/make_payment.dart';
import 'package:protek_tracker/tracker/screens/payment_details/payment_details.dart';
import 'package:protek_tracker/tracker/tracker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

class MyApp extends StatelessWidget {
  MyApp({super.key});

  /// The route configuration.
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const CoverPage();
        },
        redirect: (BuildContext context, GoRouterState state) {
          print(
              'redirect vehicle: ${context.read<VehicleTracked>().currentVehicle.id}');

          if (context.read<VehicleTracked>().currentVehicle.id != null) {
            return '/tracker';
          } else {
            return null;
          }
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
    ],
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
  }
}
