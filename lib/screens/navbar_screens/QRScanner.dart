import 'dart:io';

import 'package:auto_securo_admin/services/database_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../globals.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  bool controllerPaused = false;
  bool showConfirmation = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      // controller.pauseCamera();
      // controllerPaused = true;
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
        appBar: AppBar(
          title: Text('Scan QR'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: _buildQrView(context)),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Visibility(
                      visible: controllerPaused,
                      child: InkWell(
                          child: Container(
                              padding: EdgeInsets.all(12.0),
                              color: Colors.red,
                              child: Text(
                                "Scan Again",
                                style: TextStyle(color: Colors.white),
                              )),
                          onTap: () {
                            controller.resumeCamera();
                            setState(() {
                              controllerPaused = false;
                            });
                          }),
                    ),
                  ),
                  SizedBox(height: 20),
                  result != null
                      ? Column(
                          children: [
                            Text(result.code),
                            SizedBox(height: 30),
                            Visibility(
                              visible: showConfirmation,
                              child: Text(
                                "Notification Sent!!",
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            SizedBox(height: 10),
                            result.code.contains("Scanned by Auto Securo")
                                ? InkWell(
                                    onTap: _sendNotification,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      color: Colors.red,
                                      child: Text(
                                        "Send Notification",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        )
                      : Text("Scan the QR"),
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
      if (result.code.contains("Scanned by Auto Securo")) {
        controller.pauseCamera();
        setState(() {
          controllerPaused = true;
        });
      }
    });
  }

  void _sendNotification() async {
    String str = result.code;
    print(str);
    str = str.substring("Scanned by Auto Securo.".length);
    String userName = str.substring(0, str.indexOf("contact"));
    userName = userName.trim();

    print(userName);

    str = str
        .substring(str.indexOf("contact number:") + "contact number:".length);
    String phoneNumber = str.substring(0, str.indexOf("took"));
    phoneNumber = phoneNumber.trim();

    print(phoneNumber);

    str = str.substring(
        str.indexOf("took the vehicle:") + "took the vehicle:".length);
    String vehicleName = str.substring(0, str.indexOf("numberplate"));
    vehicleName = vehicleName.trim();

    print(vehicleName);

    str = str.substring(str.indexOf("numberplate:") + "numberplate:".length);
    String numberPlate = str.substring(0, str.indexOf("on"));
    numberPlate = numberPlate.trim();

    print(numberPlate);

    str = str.substring(str.indexOf("time:") + "time:".length);
    String timeStamp = str.substring(0);
    timeStamp = timeStamp.trim();

    print(timeStamp);

    await DatabaseService().sendNotification(
        userName, vehicleName, numberPlate, phoneNumber, timeStamp);
    print("sent");
    setState(() {
      showConfirmation = true;
    });
  }
}
