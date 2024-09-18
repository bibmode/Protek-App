import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/models/payment.dart';

class PaymentItem extends StatelessWidget {
  const PaymentItem({
    super.key,
    required this.payment,
  });

  final Payment payment;

  @override
  Widget build(BuildContext context) {
    // format date submitted

    String? method = payment.method;

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

    DateTime date = DateTime.parse(payment.date.toString());
    // List<String> months = [
    //   'Jan',
    //   'Feb',
    //   'Mar',
    //   'Apr',
    //   'May',
    //   'Jun',
    //   'Jul',
    //   'Aug',
    //   'Sep',
    //   'Oct',
    //   'Nov',
    //   'Dec'
    // ];

    String formatDateTime(DateTime date) {
      print("Inside date: $date");

      // Convert UTC to local time
      final localDate = date.toLocal();

      // List of abbreviated month names
      final List<String> abbreviatedMonths = [
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

      // Format the date with custom logic
      final String monthName = abbreviatedMonths[localDate.month - 1];
      final DateFormat timeFormatter = DateFormat('h:mm a');

      return 'Submitted on $monthName ${localDate.day}, ${localDate.year} at ${timeFormatter.format(localDate)}';
    }

    double total = double.parse(payment.total!);

    String formatDigits() {
      final NumberFormat formatter = NumberFormat('₱ #,##0.00');
      return formatter.format(total);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 21, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // method image
                Container(
                  height: 50,
                  width: 50,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Image(
                    fit: BoxFit.cover,
                    image: AssetImage(paymentMethodImage()),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                // details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            //'₱ ${payment.total}',
                            formatDigits(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          const Spacer(),
                          if (payment.validated! == false &&
                              payment.error == false)
                            Text(
                              'Not Done',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.yellow.shade800),
                            )
                          else if (payment.validated! == true)
                            const Text(
                              'Confirmed',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green),
                            )
                          else if (payment.validated! == true &&
                              payment.error == true)
                            const Text(
                              'Error Payment',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red),
                            ),
                        ],
                      ),
                      Text(
                        //'Submitted on ${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour}:${date.minute}',
                        formatDateTime(date),
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: () {
                  // if (payment.validated == false && payment.error == false) {
                  // Show Snackbar with a message
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Center(
                  //       child: Text(
                  //         'Payment is not yet done. Please complete it.',
                  //         style: TextStyle(color: Colors.black),
                  //       ),
                  //     ),
                  //     backgroundColor: Color.fromARGB(
                  //         255, 229, 194, 16), // Set background color here
                  //     duration: Duration(seconds: 2),
                  //   ),
                  // );
                  //   context.push('/tracker/payment-details', extra: payment);
                  // } else {
                  // Navigate to the payment details page
                  context.push('/tracker/payment-details', extra: payment);
                  // }
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('See Details'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
