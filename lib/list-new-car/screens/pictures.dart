import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/tracker/widgets/image_container.dart';
import 'package:provider/provider.dart';

class Pictures extends StatefulWidget {
  const Pictures(
      {Key? key, required this.hideStepsController, required this.showSteps})
      : super(key: key);

  final ScrollController hideStepsController;
  final VoidCallback showSteps;

  @override
  _PicturesState createState() => _PicturesState();
}

class _PicturesState extends State<Pictures> {
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
    return SingleChildScrollView(
      controller: widget.hideStepsController,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // front
            const Text(
              'FRONT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ImageContainer(
                imageType: "front",
                initialImage: context.read<NewVehicle>().frontImage),

            // back
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'BACK',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ImageContainer(
                imageType: "back",
                initialImage: context.read<NewVehicle>().backImage),

            // left
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'LEFT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ImageContainer(
                imageType: "left",
                initialImage: context.read<NewVehicle>().leftImage),

            // right
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'RIGHT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ImageContainer(
                imageType: "right",
                initialImage: context.read<NewVehicle>().rightImage),

            // interior
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'INTERIOR',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            ImageContainer(
                imageType: "interior",
                initialImage: context.read<NewVehicle>().interiorImage),

            const Padding(padding: EdgeInsets.all(18)),
            OutlinedButton(
              onPressed: context.read<NewVehicle>().frontImage != null &&
                      context.read<NewVehicle>().backImage != null &&
                      context.read<NewVehicle>().leftImage != null &&
                      context.read<NewVehicle>().rightImage != null &&
                      context.read<NewVehicle>().interiorImage != null
                  ? () {
                      context.read<NewVehicle>().updatePageIndex(2);
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text('CONTINUE')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
