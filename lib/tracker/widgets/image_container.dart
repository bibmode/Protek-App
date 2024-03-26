import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protek_tracker/providers/make_payment.dart';
import 'package:protek_tracker/providers/new_vehicle_provider.dart';
import 'package:provider/provider.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({
    super.key,
    this.imageType,
    required this.initialImage,
  });

  final String? imageType;
  final File? initialImage;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  @override
  Widget build(BuildContext context) {
    File? _image = widget.initialImage;
    final ImagePicker picker = ImagePicker();

    //Image Picker function to get image from gallery
    Future getImageFromCamera() async {
      try {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          // change image display
          setState(() {
            _image = File(pickedFile.path);
          });

          // this is not run on make a payment page
          if (widget.imageType != null) {
            // update image to provider
            context
                .read<NewVehicle>()
                .updateImage(File(pickedFile.path), widget.imageType!);
          } else {
            context
                .read<MakePayment>()
                .updateGCashReceipt(File(pickedFile.path));
          }
        }

        print('image success');
      } catch (e) {
        print('image error: $e');
      }
    }

    //Image Picker function to get image from gallery
    Future getImageFromGallery() async {
      try {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          // change image display
          setState(() {
            _image = File(pickedFile.path);
          });

          // this is not run on make a payment page
          if (widget.imageType != null) {
            // update image to provider
            context
                .read<NewVehicle>()
                .updateImage(File(pickedFile.path), widget.imageType!);
          } else {
            context
                .read<MakePayment>()
                .updateGCashReceipt(File(pickedFile.path));
          }
        }

        print('image success $_image');
      } catch (e) {
        print('image error: $e');
      }
    }

    return InkWell(
      onTap: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 5),
                const Text(
                  'Add Photo',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: const Text('Take a picture'),
                ),
                TextButton(
                  onPressed: () {
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: const Text('Choose Image from Gallery'),
                ),
              ],
            ),
          ),
        ),
      ),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 250,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _image != null
            ? Image.file(_image!)
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 70,
                    color: Colors.black26,
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Text(
                    'Click to Upload Image or Take Photo',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(2)),
                  Text(
                    'required size 1920 x 1080. max 10mb\neach. jpg, jped, png',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}
