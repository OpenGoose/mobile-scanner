import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// ignore: must_be_immutable
class ScannerScreen extends HookWidget {
  ScannerScreen({super.key});

  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final barcodesState = useState<List<Barcode>>([]);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
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
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.grey,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
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
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          for (final barcode in capture.barcodes) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${barcode.rawValue}'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Copy',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '${barcode.rawValue}'));
                },
              ),
            ));
          }

          bool differ = false;
          if (capture.barcodes.length == barcodesState.value.length) {
            for (int i = 0; i < barcodesState.value.length; i++) {
              if (barcodesState.value[i].rawValue !=
                  capture.barcodes[i].rawValue) {
                differ = true;
                break;
              }
            }
          } else {
            differ = true;
          }
          if (differ) {
            barcodesState.value = capture.barcodes;
          }
        },
      ),
    );
  }
}
