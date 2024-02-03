import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:toning_example/toning.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadDefaultDecorationImage();
  runApp(const MyApp());
}

late ui.Image decorationImageThumbnail;

Future<void> loadDefaultDecorationImage() async {
  final ByteData imageByteData = await rootBundle.load('assets/example.png');
  final Uint8List imageBytes = imageByteData.buffer
      .asUint8List(imageByteData.offsetInBytes, imageByteData.lengthInBytes);
  final rawImage = await decodeImageFromList(imageBytes);
  decorationImageThumbnail = rawImage;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ToningExample(),
    );
  }
}

class ToningExample extends StatelessWidget {
  const ToningExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShaderBuilder(
        (context, shader, child) {
          return ToningWidget(
            builder: (BuildContext context, ui.Image paletteMap, Widget child) {
              return AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setImageSampler(0, image)
                    ..setImageSampler(1, paletteMap)
                    ..setFloat(0, size.width)
                    ..setFloat(1, size.height)
                    ..setFloat(2, 0.7); // value

                  canvas.drawRect(
                    Rect.fromLTWH(0, 0, size.width, size.height),
                    Paint()..shader = shader,
                  );
                },
                child: RawImage(image: decorationImageThumbnail),
              );
            },
          );
        },
        assetKey: 'shaders/toning.frag',
      ),
    );
  }
}
