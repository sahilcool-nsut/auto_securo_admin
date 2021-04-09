import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  bool controllerPaused = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
      controllerPaused = true;
    } else if (Platform.isIOS) {
      controller.resumeCamera();
      controllerPaused = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:24.0,vertical:36.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: _buildQrView(context)
                    ),
                  SizedBox(height:10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Visibility(
                      visible: controllerPaused,
                      child: InkWell(
                          child: Container(padding:EdgeInsets.all(12.0),color:Colors.red,child: Text("Scan Again",style: TextStyle(color: Colors.white),)),
                          onTap: (){
                            controller.resumeCamera();
                            setState(() {
                              controllerPaused = false;
                            });

                          }
                      ),
                    ),
                  ),
                  SizedBox(height:70),
                  result!=null?Column(
                    children: [
                      Text(result.code),
                      SizedBox(height:20),
                      InkWell(
                        onTap: _sendNotification,
                        child: Container(
                          padding:EdgeInsets.all(12.0),
                          color: Colors.red,
                          child: Text("Send Notification"),
                        ),
                      )
                    ],
                  ):Text("Scan the QR"),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
      if(result.code.contains("Scanned by AutoSecure"))
        {
          controller.pauseCamera();
          setState(() {
            controllerPaused = true;
          });

        }
    });
  }
  void _sendNotification(){
    String str = result.code;
    //use str here.
  }

}
