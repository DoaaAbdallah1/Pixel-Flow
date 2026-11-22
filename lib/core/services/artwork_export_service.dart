
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cross_file/cross_file.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:gal/gal.dart';
import 'package:share_plus/share_plus.dart';

class ArtworkExportService {
  Future<Uint8List> capture(GlobalKey repaintKey) async {
    final context = repaintKey.currentContext;

    if (context == null) {
      throw Exception('Artwork is not ready for capture.');
    }

    final renderObject = context.findRenderObject();

    if (renderObject is! RenderRepaintBoundary) {
      throw Exception('Invalid artwork boundary.');
    }

    final image = await renderObject.toImage(pixelRatio: 3);

    try {
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception('Could not convert artwork to PNG.');
      }

      return byteData.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  Future<void> save(Uint8List bytes) async {
    await Gal.putImageBytes(
      bytes,
      album: 'Pixel Flow',
      name: 'pixel_flow_art',
    );
  }

  Future<void> share(Uint8List bytes) async {
    await SharePlus.instance.share(
      ShareParams(
        title: 'My Pixel Flow Artwork',
        text: 'Created with Pixel Flow',
        files: [
          XFile.fromData(
            bytes,
            mimeType: 'image/png',
            name: 'pixel_flow_art.png',
          ),
        ],
        fileNameOverrides: ['pixel_flow_art.png'],
      ),
    );
  }
}
