import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

class Confirm extends StatefulWidget {
  const Confirm({Key? key, required this.showSteps}) : super(key: key);

  final VoidCallback showSteps;

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  void initState() {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.showSteps();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'CAR SUCCESSFULLY LISTED!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Icon(
                  Icons.verified,
                  size: 170,
                  color: Colors.yellow.shade700,
                ),
                const Padding(padding: EdgeInsets.all(4)),
                const Text(
                  'A new car has been successfully added to the\ninventory of the Butuan (Main) Branch!',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              context.go('/');
            },
            child: Text('DONE'),
          ),
        )
      ],
    );
  }
}
