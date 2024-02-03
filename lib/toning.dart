import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ToningWidget extends StatelessWidget {
  final Widget Function(BuildContext, ui.Image, Widget child) builder;
  final Widget? child;
  const ToningWidget({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // pass lightColor and darkColor
      future: loadToningImage(Colors.white, Colors.black),
      builder: (context, AsyncSnapshot<ui.Image> snapshot) {
        print(snapshot.hasData);
        if (snapshot.hasData) {
          return builder(context, snapshot.data!, child ?? const SizedBox());
        } else {
          return const Text("Loading...");
        }
      },
    );
  }
}

Future<ui.Image> loadToningImage(Color lightColor, Color darkColor) async {
  final imageBytes = Uint8List(1024);
  final paletteMap = fillPaletteMap(lightColor, darkColor, imageBytes);

  // something is wrong here
  // says Imagedata is not valid.
  final rawImage = await decodeImageFromList(paletteMap);

  return rawImage;
}

Uint8List fillPaletteMap(
  Color lightColor,
  Color darkColor,
  Uint8List image,
) {
  for (int s = 0; s < 256; ++s) {
    double i = s / 255;
    image[4 * s] = (lightColor.red * i + darkColor.red * (1 - i)).round();
    image[4 * s + 1] =
        (lightColor.green * i + darkColor.green * (1 - i)).round();
    image[4 * s + 2] = (lightColor.blue * i + darkColor.blue * (1 - i)).round();
  }

  return image;
}
