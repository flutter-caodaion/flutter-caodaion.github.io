// qr_page.dart
import 'dart:io';
import 'package:caodaion/constants/constants.dart';
import 'package:caodaion/widgets/responsive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:developer';
// Add this import for PlatformException

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? result;
  QRViewController? _qrcontroller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrcontroller!.pauseCamera();
    } else if (Platform.isIOS) {
      _qrcontroller!.resumeCamera();
    }
  }

  bool? _qrFlashStatus;

  _onClickMore() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      color: Colors.black,
                      onPressed: () async {
                        bool? status = await _qrcontroller!.getFlashStatus();
                        setState(() {
                          _qrFlashStatus = status;
                          _qrcontroller?.toggleFlash().then((_) {
                            Navigator.of(context).pop();
                          });
                        });
                      },
                      icon: Icon(
                        _qrFlashStatus == false
                            ? Icons.flashlight_off_rounded
                            : Icons.flashlight_on_rounded,
                      ),
                    ),
                  ),
                  Text(
                    "${_qrFlashStatus == false ? "Tắt" : "Mở"} Đèn pin",
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            context.go('/apps');
          },
        ),
        title: Row(
          children: [
            Icon(
              Icons.qr_code_scanner_outlined,
              color: ColorConstants.qrColor,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("Quét QR"),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                Positioned(
                  top: 0,
                  child: result != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Quét thấy: ${result.toString()}",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Positioned(
                  bottom: 24,
                  right: 16,
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                              color: Colors.white,
                            ),
                            child: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                _onClickMore();
                              },
                              icon: const Icon(
                                Icons.more_vert_rounded,
                              ),
                            ),
                          ),
                          const Text(
                            "Nâng Cao",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      // Column(
                      //   children: [
                      //     Container(
                      //       decoration: const BoxDecoration(
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(100),
                      //         ),
                      //         color: Colors.white,
                      //       ),
                      //       child: IconButton(
                      //         color: Colors.black,
                      //         onPressed: () {},
                      //         icon: const Icon(
                      //           Icons.add_photo_alternate_outlined,
                      //         ),
                      //       ),
                      //     ),
                      //     const Text(
                      //       "Chọn ảnh QR",
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //       ),
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrcontroller = controller;
      controller.scannedDataStream.listen((scanData) {
        result = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    _qrcontroller?.dispose();
    super.dispose();
  }
}
