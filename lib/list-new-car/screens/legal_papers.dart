import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:protek_tracker/tracker/widgets/image_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:scribble/scribble.dart';
import 'package:path_provider/path_provider.dart';

class LegalPapers extends StatefulWidget {
  const LegalPapers(
      {Key? key, required this.hideStepsController, required this.showSteps})
      : super(key: key);

  final ScrollController hideStepsController;
  final VoidCallback showSteps;

  @override
  _LegalPapersState createState() => _LegalPapersState();
}

class _LegalPapersState extends State<LegalPapers> {
  late ScribbleNotifier notifier;
  bool loading = false;

  @override
  void initState() {
    notifier = ScribbleNotifier(widths: [3]);
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.showSteps();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String affidavit =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

    return SingleChildScrollView(
      controller: widget.hideStepsController,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // affidavit
            const Text(
              'AFFIDAVIT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    affidavit,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(affidavit),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              insetPadding: const EdgeInsets.all(20),
                              actionsAlignment: MainAxisAlignment.end,
                              actionsPadding:
                                  const EdgeInsets.only(bottom: 20, right: 20),
                              scrollable: true,
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.close),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Text('CLOSE'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            // ImageContainer(
            //     imageType: "affidavit",
            //     initialImage: context.read<NewVehicle>().affidavitImage),

            // MEMORANDUM OF AGREEMENT
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'MEMORANDUM OF AGREEMENT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    affidavit,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(affidavit),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              insetPadding: const EdgeInsets.all(20),
                              actionsAlignment: MainAxisAlignment.end,
                              actionsPadding:
                                  const EdgeInsets.only(bottom: 20, right: 20),
                              scrollable: true,
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.close),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Text('CLOSE'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            // ImageContainer(
            //     imageType: "memorandumOfAgreement",
            //     initialImage:
            //         context.read<NewVehicle>().memorandumOfAgreementImage),

            // ACKNOWLEGEMENT
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'ACKNOWLEGEMENT',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    affidavit,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(padding: EdgeInsets.all(5)),
                  OutlinedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text(affidavit),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              insetPadding: const EdgeInsets.all(20),
                              actionsAlignment: MainAxisAlignment.end,
                              actionsPadding:
                                  const EdgeInsets.only(bottom: 20, right: 20),
                              scrollable: true,
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.close),
                                      Padding(padding: EdgeInsets.all(4)),
                                      Text('CLOSE'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            // ImageContainer(
            //     imageType: "acknowledgement",
            //     initialImage: context.read<NewVehicle>().acknowledgementImage),

            // OWNER'S SIGNATURE
            const Padding(padding: EdgeInsets.all(15)),
            const Text(
              'OWNER\'S SIGNATURE',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),

            const Padding(padding: EdgeInsets.all(10)),
            ClipRect(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Scribble(
                        notifier: notifier,
                        drawPen: true,
                      ),
                      Positioned(
                        right: 0,
                        child: _buildColorToolbar(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              'NOTE: By putting your signature, you agree with the terms & conditions of the legal papers above.',
              softWrap: true,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const Padding(padding: EdgeInsets.all(18)),
            OutlinedButton(
              onPressed: !loading
                  ? () {
                      _saveImage(context);
                    }
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text('CONTINUE'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      print('sketch lines: ${notifier.currentSketch.lines.isEmpty}');
      List<SketchLine> signatureLines = notifier.currentSketch.lines;

      if (signatureLines.isNotEmpty) {
        //  create file image
        final data = await notifier.renderImage();
        final buffer = data.buffer;
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        var filePath =
            '$tempPath/${context.read<NewVehicle>().newVehicle!.plateNo}.png';
        File imageFile = await File(filePath).writeAsBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

        // update from provider
        context.read<NewVehicle>().updateImage(imageFile, "signature");

        // go to next page
        context.read<NewVehicle>().updatePageIndex(3);
      } else {
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Must input owner\'s signature. Try again!'),
          action: SnackBarAction(
            label: 'Okay',
            onPressed: () {},
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('file error: $e');
    }
    setState(() {
      loading = false;
    });
  }

  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier as StateNotifier<ScribbleState>,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in notifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => notifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: state.map(
                  drawing: (s) => Color(s.selectedColor),
                  erasing: (_) => Colors.transparent,
                ),
                border: state.map(
                  drawing: (_) => null,
                  erasing: (_) => Border.all(width: 1),
                ),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier as StateNotifier<ScribbleState>,
      builder: (context, state, _) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUndoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildRedoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 20.0,
          ),
          _buildPointerModeSwitcher(context,
              penMode:
                  state.allowedPointersMode == ScribblePointerMode.penOnly),
          const Divider(
            height: 20.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
        ],
      ),
    );
  }

  Widget _buildPointerModeSwitcher(BuildContext context,
      {required bool penMode}) {
    return FloatingActionButton.small(
      onPressed: () => notifier.setAllowedPointersMode(
        penMode ? ScribblePointerMode.all : ScribblePointerMode.penOnly,
      ),
      tooltip:
          "Switch drawing mode to " + (penMode ? "all pointers" : "pen only"),
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: !penMode
            ? const Icon(
                Icons.touch_app,
                key: ValueKey(true),
              )
            : const Icon(
                Icons.do_not_touch,
                key: ValueKey(false),
              ),
      ),
    );
  }

  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: notifier.setEraser,
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleState state,
  }) {
    final isSelected = state is Drawing && state.selectedColor == color.value;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildUndoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Undo",
      onPressed: notifier.canUndo ? notifier.undo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canUndo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.undo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRedoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Redo",
      onPressed: notifier.canRedo ? notifier.redo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canRedo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.redo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: "Clear",
      onPressed: notifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.clear),
    );
  }
}
