import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  DetailRow({
    super.key,
    required this.title,
    required this.data,
  });

  final String title;
  String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
              fontSize: 16,
            ),
          ),
          Spacer(),
          Text(
            data,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
