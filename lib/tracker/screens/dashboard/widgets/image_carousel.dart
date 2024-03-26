import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
    required this.carImages,
  });

  final List<String?> carImages;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: FlutterCarousel(
        options: CarouselOptions(
          height: 400.0,
          viewportFraction: 1,
          showIndicator: true,
          slideIndicator: const CircularSlideIndicator(),
        ),
        items: carImages.map((image) {
          return Builder(
            builder: (BuildContext context) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image(image: NetworkImage(image!)),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
