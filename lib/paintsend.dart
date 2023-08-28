import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:math';

class Paintsend extends StatelessWidget {
  final ByteData imgBytes;
  final User user;

  const Paintsend(this.imgBytes, this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personality Detection')),
      body: Paintsend1(imgBytes: imgBytes, user: user),
    );
  }
}

class Paintsend1 extends StatefulWidget {
  final ByteData imgBytes;
  final User user;

  const Paintsend1({Key? key, required this.imgBytes, required this.user})
      : super(key: key);

  @override
  _Paintsend1State createState() => _Paintsend1State();
}

class _Paintsend1State extends State<Paintsend1> {
  String valueapi = "";
  String fileName = "";
  String datetime1 = "";
  String ID = "";
  bool bool1 = false;
  bool screen = true;
  var decodedurls;
  var decoded1;
  late String calledurl;
  String com = "0";

  void urlget(String cd) async {
    final response = await http.get(Uri.parse(
        'https://flutter-graphology.herokuapp.com/upload/$cd'));
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      com = "75";
    });

    final response1 = await http.get(Uri.parse(
        '${'https://flutter-graphology.herokuapp.com/predict/' +
            decoded["output"]["see"]}/$ID'));
    decodedurls = response1.body;
    setState(() {
      com = "100";
      bool1 = true;
    });
  }

  void viewer(String s) async {
    valueapi = s;

    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'remotemysql.com',
        port: 3306,
        user: 'RIcvQcz1ZB',
        password: '98U4LQX9u7',
        db: 'RIcvQcz1ZB'));

    calledurl = fileName;
    var result = await conn.query('insert into upload (email, name ,time, image) values (?,?,?,?)',
        [widget.user.email, fileName, datetime1, valueapi]);

    ID = '${result.insertId}';
    urlget("$calledurl/$ID");
    setState(() {
      com = "50";
    });
  }

  Future<void> uploadImageToFirebase(BuildContext context) async {
    final randomNumber = Random().nextInt(100);
    final time = DateTime.now();
    final formatter = DateFormat('dd/MM/yyyy kk:mm:ss');
    final formatter1 = DateFormat('dd_MM_yyyy_kk_mm_ss');
    datetime1 = formatter.format(time);

    final buffer = widget.imgBytes.buffer;
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final path = appDocumentsDirectory.path;
    fileName = "inputfile$randomNumber$datetime1";
    final filepath = File("${path}inputfile$randomNumber$datetime1");

    await filepath.writeAsBytes(buffer.asUint8List(widget.imgBytes.offsetInBytes, widget.imgBytes.lengthInBytes));

    final email = widget.user.email;
    final firebaseStorageRef = FirebaseStorage.instance.ref().child('$email' '/$filepath');
    final uploadTask = firebaseStorageRef.putFile(filepath);
    final taskSnapshot = await uploadTask.whenComplete(() {});
    setState(() {
      com = "25";
    });
    final value = await taskSnapshot.ref.getDownloadURL();
    viewer(value);
  }

  @override
  Widget build(BuildContext context) {
    return bool1
        ? Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                          colors: [Colors.orange, Colors.yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          decoded1["Output"]["time"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      const Text(
                        "Input Image",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Image.network(decoded1["Output"]["inputimgurl"],
                          height: 250),
                      const Text(
                        "Predicted Image",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Image.network(decoded1["Output"]["outputimgurl2"],
                          height: 300),
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Personality Trait",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          decoded1["Output"]["info0"] +
                              decoded1["Output"]["info1"] +
                              decoded1["Output"]["info2"] +
                              decoded1["Output"]["info3"] +
                              decoded1["Output"]["info4"] +
                              decoded1["Output"]["info5"],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Container(
                child: Center(
                  child: Image.memory(
                    Uint8List.view(widget.imgBytes.buffer),
                    width: 700,
                    height: 500,
                  ),
                ),
              ),
              Text(
                "$com%",
                style: const TextStyle(color: Colors.black, fontSize: 25),
              ),
              ElevatedButton(
                onPressed: () => uploadImageToFirebase(context),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45)), backgroundColor: Colors.lightBlue,
                  elevation: 10,
                  splashFactory: InkRipple.splashFactory,
                ),
                child: const Text(
                  "Predict Now",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ],
          );
  }
}
