import 'package:flutter/material.dart';

class AppBarStep extends StatelessWidget {
  const AppBarStep({
    super.key,
    required this.number,
    required this.title,
    required this.done,
  });

  final String number;
  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: done ? Colors.grey.shade900 : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.all(2)),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            color: done ? Colors.black87 : Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
