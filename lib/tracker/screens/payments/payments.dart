import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/main.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/payments/widgets/payment_item.dart';
import 'package:provider/provider.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key}) : super(key: key);

  @override
  _PaymentsState createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  Widget build(BuildContext context) {
    final paymentsStream = supabase
        .from('payments')
        .stream(primaryKey: ['id'])
        .eq('vehicle', context.read<VehicleTracked>().currentVehicle.id!)
        .map((map) => map.map((item) => Payment.fromMap(item)).toList());

    return StreamBuilder<List<Payment>>(
        stream: paymentsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('payments: ${snapshot.data}');
            if (snapshot.data!.length > 0) {
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PaymentItem(
                      payment: snapshot.data!.reversed.toList()[index],
                    );
                  });
            } else {
              return const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text('No payments yet'),
                ),
              );
            }
          } else {
            return const Padding(
              padding: EdgeInsets.all(28.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator()),
            );
          }
        });
  }
}
