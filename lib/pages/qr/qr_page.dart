// qr_page.dart
import 'dart:io';
import 'package:caodaion/components/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quét Mã QR'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData.code;
        final SnackBar snackBar = SnackBar(content: Text("$result"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
