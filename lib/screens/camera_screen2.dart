import 'package:auto_securo_admin/screens/scanner_utils.dart';
import 'package:auto_securo_admin/services/database_services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen2 extends StatefulWidget {
  @override
  _CameraScreen2State createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  String mailAddress = '';
  CameraController _camera;
  bool _isDetecting = false;
  VisionText _textScanResults;
  CameraLensDirection _direction = CameraLensDirection.back;
  final TextRecognizer _textRecognizer =
      FirebaseVision.instance.textRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  void _initializeCamera() async {
    final CameraDescription description =
        await ScannerUtils.getCamera(_direction);

    _camera = CameraController(
      description,
      ResolutionPreset.high,
    );

    await _camera.initialize();

    _camera.startImageStream((CameraImage image) {
      if (_isDetecting) return;

      setState(() {
        _isDetecting = true;
      });
      ScannerUtils.detect(
        image: image,
        detectInImage: _getDetectionMethod(),
        imageRotation: description.sensorOrientation,
      ).then(
        (results) {
          setState(() {
            if (results != null) {
              setState(() {
                _textScanResults = results;
              });
            }
          });
        },
      ).whenComplete(() => _isDetecting = false);
    });
  }

  Future<VisionText> Function(FirebaseVisionImage image) _getDetectionMethod() {
    return _textRecognizer.processImage;
  }

  void getWords(VisionText visionText) {
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        mailAddress = line.text + '\n';
        print(mailAddress);
      }
    }
  }

  Widget _buildResults(VisionText scanResults) {
    CustomPainter painter;
    if (scanResults != null) {
      final Size imageSize = Size(
        _camera.value.previewSize.height - 100,
        _camera.value.previewSize.width,
      );
      painter = TextDetectorPainter(imageSize, scanResults);
      getWords(scanResults);

      return CustomPaint(
        painter: painter,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_camera == null) {
            _initializeCamera();
          } else {
            print('pressed');
            _camera.stopImageStream();
            setState(() {
              _camera = null;
            });
          }
        },
        child: _camera != null ? Icon(Icons.camera) : Icon(Icons.refresh),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _camera == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Recognised number plate: $mailAddress'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('If inaccurate, refresh on the bottom right'),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        // await DatabaseService().sendNotification(userName, vehicleName, numberPlate, targetPhone, timeStamp)
                      },
                      child: Text('Send notification'),
                    )
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: CameraPreview(_camera),
                    ),
                    Text(mailAddress),
                  ],
                ),
          _camera != null ? _buildResults(_textScanResults) : Container(),
        ],
      ),
    );
  }
}

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.visionText);

  final Size absoluteImageSize;
  final VisionText visionText;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    Rect scaleRect(TextContainer container) {
      return Rect.fromLTRB(
        container.boundingBox.left * scaleX,
        container.boundingBox.top * scaleY,
        container.boundingBox.right * scaleX,
        container.boundingBox.bottom * scaleY,
      );
    }

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        paint.color = Colors.yellow;
        canvas.drawRect(scaleRect(line), paint);
      }

      paint.color = Colors.red;
      canvas.drawRect(scaleRect(block), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.visionText != visionText;
  }
}
