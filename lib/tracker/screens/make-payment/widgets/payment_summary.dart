import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/tracker/screens/dashboard/widgets/detail_row.dart';
import 'package:provider/provider.dart';

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({super.key});

  @override
  Widget build(BuildContext context) {
    var valueFormat = NumberFormat("###,###.0#", "en_US");

    double subtotal = context.read<MakePayment>().paymentSubTotal;
    double security = (subtotal * 0.06).round() * 1.0;
    double insurance = (subtotal * 0.08).round() * 1.0;
    double legal = (subtotal * 0.03).round() * 1.0;
    double admin = (subtotal * 0.12).round() * 1.0;
    double vat = (subtotal * 0.12).round() * 1.0;
    double others = (subtotal * 0.1).round() * 1.0;
    double rent =
        subtotal - security - insurance - legal - admin - others - vat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PAYMENT SUMMARY',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
        DetailRow(
          title: 'Rental Fee',
          data: '₱ $rent',
        ),
        DetailRow(
          title: 'Security Fees',
          data: '₱ $security',
        ),
        DetailRow(
          title: 'Insurance',
          data: '₱ $insurance',
        ),
        DetailRow(
          title: 'Legal Fees',
          data: '₱ $legal',
        ),
        DetailRow(
          title: 'Administration Fees',
          data: '₱ $admin',
        ),
        DetailRow(
          title: 'VAT (12%)',
          data: '₱ $vat',
        ),
        DetailRow(
          title: 'Other Taxes',
          data: '₱ $others',
        ),
      ],
    );
  }
}
