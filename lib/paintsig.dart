import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hello_world/paintsend.dart';

class Paintsig extends StatelessWidget {
  final User user;
  const Paintsig(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personality Detection')),
      body: Paintsignature(user),
    );
  }
}

class Paintsignature extends StatefulWidget {
  final User user;
  const Paintsignature(this.user, {super.key});

  @override
  _PaintsignatureState createState() => _PaintsignatureState();
}

class DrawingArea {
  Offset? point;
  Paint? areaPaint;
  DrawingArea({this.point, this.areaPaint});
}

class _PaintsignatureState extends State<Paintsignature> {
  final List<Paint> _points = <Paint>[];
  List<Offset> _points1 = <Offset>[];
  Color selectedColor = Colors.black;
  double strokeWidth = 2.0;
  ByteData? imgBytes;

  @override
  void initState() {
    super.initState();
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Color Chooser'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocumentsPath = appDocumentsDirectory.path;
    String filePath = '$appDocumentsPath/image.png';
    print(filePath);
    return filePath;
  }

  void rendered() async {
    final recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    for (int i = 0; i < _points1.length - 1; i++) {
      canvas.drawLine(_points1[i], _points1[i + 1], _points[i]);
              }

    final picture = recorder.endRecording();
    final img = await picture.toImage(500, 500);
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    print("oksighoiugh");
    setState(() {
      imgBytes = pngBytes;
      print(imgBytes);
      if (imgBytes != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Paintsend(imgBytes!, widget.user)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.deepOrangeAccent,
                  Color.fromRGBO(138, 35, 135, 1.0),
                  Color.fromRGBO(233, 64, 87, 1.0),
                  Color.fromRGBO(242, 113, 33, 1.0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: width * 0.95,
              height: height * 0.50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  setState(() {
                    RenderBox object = context.findRenderObject() as RenderBox;
                    Offset localPosition =
                        object.globalToLocal(details.globalPosition);
                    _points1 = List.from(_points1)..add(localPosition);
                    _points.add(Paint()
                      ..strokeCap = StrokeCap.round
                      ..isAntiAlias = true
                      ..color = selectedColor
                      ..strokeWidth = strokeWidth);
                  });
                },
                onPanEnd: (DragEndDetails details) {
                  if (_points.isNotEmpty) {
                    setState(() {
                      _points1.clear();
                      _points.clear();
                    });
                  }
                },
                child: SizedBox.expand(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    child: CustomPaint(
                      painter: Signature(points1: _points1, points: _points),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: width * 0.80,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () => rendered(),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45)), backgroundColor: Colors.lightBlueAccent,
                          elevation: 8,
                        ),
                        child: const Text('Submit'),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.color_lens,
                          color: selectedColor,
                        ),
                        onPressed: () {
                          selectColor();
                        },
                      ),
                      Expanded(
                        child: Slider(
                          min: 1.0,
                          max: 10.0,
                          label: "Stroke $strokeWidth",
                          activeColor: selectedColor,
                          value: strokeWidth,
                          onChanged: (double value) {
                            setState(() {
                              strokeWidth = value;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.layers_clear,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _points.clear();
                            _points1.clear();
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Signature extends CustomPainter {
  List<Paint?> points;
  List<Offset?> points1;

  Signature({required this.points1, required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points1.length - 1; i++) {
      if (points1[i] != null && points1[i + 1] != null && points[i] != null) {
        canvas.drawLine(points1[i]!, points1[i + 1]!, points[i]!);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points1 != points1;
}
