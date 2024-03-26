import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:protek_tracker/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LegalPaperButton extends StatefulWidget {
  const LegalPaperButton({
    super.key,
    required this.imageLink,
    required this.paperTitle,
  });

  final String imageLink;
  final String paperTitle;

  @override
  State<LegalPaperButton> createState() => _LegalPaperButtonState();
}

class _LegalPaperButtonState extends State<LegalPaperButton> {
  bool _downloadLoader = false;

  void openDownloadResult(String message) {
    // open snackbar
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void closeLoader() {
    setState(() {
      _downloadLoader = false;
    });

    openDownloadResult('Download finished!');
  }

  // download Image
  Future<void> downloadImage() async {
    setState(() {
      _downloadLoader = true;
    });

    // index of /legal
    int indexStart = widget.imageLink.indexOf('/papers');
    // get originalImageUrl
    String imageName = widget.imageLink.substring(indexStart + 8);

    print('download string: $imageName');

    try {
      final response = await supabase.storage.from('papers').download(imageName,
          transform: const TransformOptions(format: RequestImageFormat.origin));

      // try this download method
      if (response.isNotEmpty) {
        String path =
            "/storage/emulated/0/Download/${widget.paperTitle}-$imageName";
        File file = File(path);
        File completeDownload = await file.writeAsBytes(response, flush: true);
      }

      Timer(const Duration(seconds: 3), closeLoader);
    } catch (e) {
      openDownloadResult('Download failed! Try again!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: TextButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Image.network(widget.imageLink),
                    contentPadding: const EdgeInsets.all(0),
                    insetPadding: const EdgeInsets.all(0),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: const EdgeInsets.only(top: 10),
                    backgroundColor: Colors.transparent,
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          downloadImage();
                        },
                        child: const Text('DOWNLOAD'),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('CLOSE'),
                      ),
                    ],
                  );
                });
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black12),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(widget.imageLink),
                  ),
                  const Spacer(),
                  Text(
                    widget.paperTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              _downloadLoader
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: LinearProgressIndicator(
                        color: Colors.yellow.shade700,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          )),
    );
  }
}
