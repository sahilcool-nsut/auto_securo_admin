import 'package:auto_securo_admin/screens/scanner_utils.dart';
import 'package:auto_securo_admin/services/database_services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:date_format/date_format.dart';

class CameraScreen2 extends StatefulWidget {
  @override
  _CameraScreen2State createState() => _CameraScreen2State();
}

class _CameraScreen2State extends State<CameraScreen2> {
  bool showConfirmation = false;
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
    RegExp regEx = RegExp("^[A-Z]{0,5}[0-9A-Z]{1,2}[A-Z]{2}[0-9]{4}\$",
        caseSensitive: true);
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        String temp = line.text.replaceAll(' ', '');
        print(line.text);
        print(temp);
        temp = temp.replaceAll("\n", '');
        print("OOOF");
        if (regEx.hasMatch(temp)) {
          print("accepted");
          mailAddress = temp;
        }
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
      appBar: AppBar(
        title: Text('Numberplate Scanner'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_camera == null) {
            _initializeCamera();
            mailAddress = '';
            setState(() {
              showConfirmation = false;
            });
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
                    Visibility(
                      visible: showConfirmation,
                      child: Text(
                        "Notification Sent!!",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        await DatabaseService().sendNotification(
                            'custom',
                            'custom',
                            mailAddress,
                            'custom',
                            formatDate(DateTime.now(), [
                              dd,
                              '/',
                              mm,
                              '/',
                              yyyy,
                              ', ',
                              HH,
                              ':',
                              nn,
                            ]).toString());
                        setState(() {
                          showConfirmation = true;
                        });
                      },
                      child: Text('Send notification'),
                    )
                  ],
                )
              : ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      child: CameraPreview(_camera),
                    ),
                    Text(
                      mailAddress,
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
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
