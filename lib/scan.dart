import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner/details.dart';
import 'package:scanner/form.dart';
import 'package:scanner/sheet.dart';
import 'package:tuple/tuple.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.title, required this.username});

  final String title;
  final String username;

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late MobileScannerController _scannerController;
  late String username;
  late Spreadsheet ss;

  double _scale = 0.0;
  double _prevScale = 1.0;
  DateTime lastUpdated = DateTime.now();

  @override
  void initState() {
    super.initState();
    username = widget.username;
    _scannerController = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: false,
      returnImage: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var sp = SpreadsheetProvider.of(context);
    if (sp != null) {
      ss = sp;
    } else {
      throw Exception("Spreadsheet is null!");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => _scannerController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: _scannerController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => _scannerController.switchCamera(),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onScaleUpdate: (ScaleUpdateDetails details) {
              setState(() {
                if (details.scale > _prevScale) {
                  // Zooming in
                  _scale += 0.01;
                } else if (details.scale < 1) {
                  // Zooming out
                  _scale -= 0.025;
                }
                lastUpdated = DateTime.now();

                _scale = _scale.clamp(0, 1);

                _scannerController.setZoomScale(_scale);
                _prevScale = details.scale;
              });
            },
            child: MobileScanner(
              fit: BoxFit.contain,
              // scanWindow: scanWindow,
              controller: _scannerController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                final Uint8List? image = capture.image;
                if (barcodes.length > 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('More than one barcode detected!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (image != null &&
                    barcodes.length == 1 &&
                    (DateTime.now().difference(lastUpdated).inMilliseconds >
                        10)) {
                  final Barcode barcode = barcodes[0];
                  if (barcode.corners == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Corners unknown!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    _scale = 0;
                    return;
                  }
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  _scannerController.stop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('QR Code'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Email: ${barcode.rawValue}'),
                          const SizedBox(height: 40),
                          Flexible(
                            child: Transform.rotate(
                                angle: pi / 2, child: Image.memory(image)),
                          )
                        ],
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFFDD0000)),
                              ),
                              onPressed: () {
                                _scale = 0;
                                Navigator.pop(context);
                                _scannerController.start();
                              },
                            ),
                            TextButton(
                              child: const Text('Confirm'),
                              onPressed: () async {
                                Tuple2<Map<String, String>?, String> results =
                                await getParticipant(ss, barcode.rawValue, username);
                                _scale = 0;
                                if (mounted) {
                                  Navigator.pop(context);
                                  await showUserDetails(context, results);
                                }
                                _scannerController.start();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
