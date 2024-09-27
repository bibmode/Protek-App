import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/models/payment.dart';
import 'package:protek_tracker/models/vehicle.dart';
import 'package:protek_tracker/providers/vehicle_tracked.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/detail_row.dart';
import 'package:provider/provider.dart';

// helper functions
import 'package:protek_tracker/helpers/functions.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key, required this.payment}) : super(key: key);

  final Payment payment;

  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    // format date submitted
    Payment payment = widget.payment;

    String? method = payment.method;

    DateTime date = DateTime.parse(payment.date!);
    DateTime? verifiedDate =
        payment.validated! ? DateTime.parse(payment.verifiedDate!) : null;

    String paymentMethodImage() {
      if (method == 'gcash') {
        return 'lib/images/gcash.png';
      } else if (method == 'paymaya') {
        return 'lib/images/maya.jpg';
      } else if (method == 'grab_pay') {
        return 'lib/images/grab.jpg';
      } else {
        return 'lib/images/Pay-online.png';
      }
    }

    String paymentMethod() {
      if (method == 'gcash') {
        return 'GCash';
      } else if (method == 'paymaya') {
        return 'Pay Maya';
      } else if (method == 'grab_pay') {
        return 'Grab Pay';
      } else if (method == 'atome') {
        return 'Atome';
      } else if (method == 'coins_ph') {
        return 'coins.ph';
      } else if (method == 'dob') {
        return 'Direct Online Banking';
      } else {
        return 'Other Payment Method';
      }
    }

    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // number formats
    NumberFormat minutesFormatter = NumberFormat("##");
    NumberFormat moneyFormatter = NumberFormat("##,###,###.##");

    // values
    double total = double.parse(payment.total!);

    double security = (total * 0.06).round() * 1.0;
    double insurance = (total * 0.08).round() * 1.0;
    double legal = (total * 0.03).round() * 1.0;
    double admin = (total * 0.12).round() * 1.0;
    double vat = (total * 0.12).round() * 1.0;
    double others = (total * 0.1).round() * 1.0;
    double totalFees = security + insurance + legal + admin + vat + others;
    double rent = total - totalFees;

    Vehicle currentVehicle = context.watch<VehicleTracked>().currentVehicle;

    // values
    // balance
    DateTime now = DateTime.now();
    DateTime checkInDate = DateTime.parse(currentVehicle.createdAt!);
    int numberOfDays = daysBetween(checkInDate, now);

    double? paid = currentVehicle.paid;
    double? dailyRate = currentVehicle.dailyRate;
    double? balance = (dailyRate! * numberOfDays) - paid!;

    String formatDigits(double number) {
      final NumberFormat formatter = NumberFormat('₱ #,##0.00');
      return formatter.format(number);
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment #id${payment.id}'),
            Text(
              'Submitted on ${months[date.month - 1]} ${date.day}, ${date.year} ${date.hour}:${minutesFormatter.format(date.minute)}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 35),
          child: payment.validated == true && payment.error == false
              ? Container(
                  height: 35,
                  width: double.infinity,
                  color: Colors.green.shade600,
                  child: const Center(
                    child: Text(
                      'PAYMENT SUCCESS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : payment.validated == true && payment.error == true
                  ? Container(
                      height: 35,
                      width: double.infinity,
                      color: Colors.red.shade600,
                      child: const Center(
                        child: Text(
                          'ERROR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 35,
                      width: double.infinity,
                      color: Colors.amber.shade600,
                      child: const Center(
                        child: Text(
                          'NOT DONE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PAYMENT INFO',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Date Requested',
                    data:
                        '${months[date.month - 1]} ${date.day}, ${date.year} ${date.hour}:${minutesFormatter.format(date.minute)}',
                  ),
                  // DetailRow(
                  //   title: 'Verified on',
                  //   data: payment.verifiedDate != null
                  //       ? '${months[verifiedDate!.month - 1]} ${verifiedDate.day}, ${verifiedDate.year} ${verifiedDate.hour}:${minutesFormatter.format(verifiedDate.minute)}'
                  //       : '-',
                  // ),
                  DetailRow(
                    title: 'Verified on',
                    data: verifiedDate != null
                        ? '${months[verifiedDate.month - 1]} ${verifiedDate.day}, ${verifiedDate.year} ${verifiedDate.hour}:${minutesFormatter.format(verifiedDate.minute)}'
                        : '-',
                  ),

                  DetailRow(
                      title: 'Daily Fee',
                      //data: '₱ $dailyRate',
                      data: formatDigits(dailyRate)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),
            // payment breakdown
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PAYMENT BREAKDOWN',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  DetailRow(
                    title: 'Rental Fee',
                    //data: '₱ $rent',
                    data: formatDigits(rent),
                  ),
                  DetailRow(
                    title: 'Security Fees',
                    //data: '₱ $security',
                    data: formatDigits(security),
                  ),
                  DetailRow(
                    title: 'Insurance',
                    //data: '₱ $insurance',
                    data: formatDigits(insurance),
                  ),
                  DetailRow(
                    title: 'Legal Fees',
                    //data: '₱ $legal',
                    data: formatDigits(legal),
                  ),
                  DetailRow(
                    title: 'Administration Fees',
                    //data: '₱ $admin',
                    data: formatDigits(admin),
                  ),
                  DetailRow(
                    title: 'VAT (12%)',
                    //data: '₱ $vat',
                    data: formatDigits(vat),
                  ),
                  DetailRow(
                    title: 'Other Taxes',
                    //data: '₱ $others',
                    data: formatDigits(others),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        const Text(
                          'TOTAL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          // '₱ ${payment.total}',
                          formatDigits(total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(
                height: 1.5,
                color: Colors.grey.shade300,
              ),
            ),
            // paid with
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PAID WITH',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(8)),
                  Row(
                    children: [
                      // method image
                      Container(
                        height: 50,
                        width: 50,
                        margin: const EdgeInsets.only(right: 12),
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage(paymentMethodImage()),
                        ),
                      ),
                      Text(
                        paymentMethod(),
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        //'₱ ${payment.total}0',
                        formatDigits(total),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.all(28)),
          ],
        ),
      ),
    );
  }
}
