import 'dart:io';
import 'package:flutter/material.dart';

class ImageWithTextOverlay extends StatelessWidget {
  final File imageFile;

  const ImageWithTextOverlay({required this.imageFile, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.file(imageFile),
        Positioned(
          left: 20,
          top: 20,
          child: Text(
            'Hello, Flutter!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.red,
              backgroundColor: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
