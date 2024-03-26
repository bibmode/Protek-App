import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    DateTime date = DateTime.parse(payment.date!);
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
                  child: const Image(
                    fit: BoxFit.cover,
                    image: AssetImage('lib/images/gcash.png'),
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
                            '₱ ${payment.total}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                          const Spacer(),
                          if (payment.validated! == false &&
                              payment.error == false)
                            Text(
                              'Verification Pending',
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
                        'Submitted on ${months[date.month - 1]} ${date.day}, ${date.year} at ${date.hour}:${date.minute}',
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
                onPressed: () =>
                    context.push('/tracker/payment-details', extra: payment),
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                child: const Text('See Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
