import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const Color yellow = Color(0xfffbc31b);
const Color orange = Color(0xfffb6900);

class Uploading1 extends StatelessWidget {
  final User user;
  const Uploading1(this.user, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Personality Detection')),
        body: UploadingImageToFirebaseStorage(user));
  }
}

class UploadingImageToFirebaseStorage extends StatefulWidget {
  final User user1;

  const UploadingImageToFirebaseStorage(this.user1, {super.key});

  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  late File _imageFile;
  var calledurl;
  String valueapi = "";
  late String fileName;
  late String datetime1;
  late String datetime12;
  late String ID;
  @override
  late BuildContext context;
  bool bool1 = false;
  bool screen = true;
  var decodedurls;
  var decoded1;
  String per = "0%";

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    try {
      setState(() {
        _imageFile = File(pickedFile!.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void urlget(String cd) async {
    // ignore: await_only_futures
    setState(() {
      per = "25%";
    });
    final response = await http.get(
        Uri.parse('https://flutter-graphology.herokuapp.com/upload/$cd'));
    print(response.body);
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    print(decoded["output"]["see"]);
    setState(() {
      per = "50%";
    });
    final response1 = await http.get(Uri.parse(
        '${'https://flutter-graphology.herokuapp.com/predict/' +
            decoded["output"]["see"]}/$ID'));
    decodedurls = response1.body;
    print(response1.body);
    decoded1 = json.decode(response1.body) as Map<String, dynamic>;
    setState(() {
      per = "100%";
    });
    print("decoded1-----------------------------------");
    print(decoded1["Output"]);
    setState(() {
      screen = false;
    });
  }

  void viewer(String s) async {
    valueapi = s;
    print(valueapi);
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'remotemysql.com',
        port: 3306,
        user: 'RIcvQcz1ZB',
        password: '98U4LQX9u7',
        db: 'RIcvQcz1ZB'));
    calledurl = fileName;
    // print(widget.user1.email+"\n"+fileName+"\n"+datetime1+"\n"+valueapi);
    print("${widget.user1.email!}\n$fileName\n\n$valueapi");
    var result = await conn.query(
        'insert into upload (email, name ,time, image) values (?,?,?,?)',
        [widget.user1.email, fileName, datetime12, valueapi]);
    print('Inserted row id=${result.insertId}');
    ID = '${result.insertId}';
    print(ID);
    print(calledurl + "/" + ID);
    setState(() {
      bool1 = true;
      print(bool1);
    });
  }

  Future<void> uploadImageToFirebase(BuildContext context) async {
    final time = DateTime.now();
    final formatter1 = DateFormat('dd/MM/yyyy kk:mm:ss');
    final String datetime12 = formatter1.format(time);
    this.datetime12 = datetime12;

    fileName = basename(_imageFile.path);
    print(fileName);

    String? email = widget.user1.email;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref('$email/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    viewer(downloadUrl);
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [yellow, orange],
                ),
                borderRadius: BorderRadius.circular(30.0)),
            child: ElevatedButton(
              onPressed: () => uploadImageToFirebase(context),
              child: const Text(
                "Upload Image",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return screen
        ? Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: 360,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0)),
                      gradient: LinearGradient(
                          colors: [orange, yellow],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Upload Image to Find the Predictions",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: double.infinity,
                              margin: const EdgeInsets.only(
                                  left: 30.0, right: 30.0, top: 10.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: _imageFile != null
                                      ? Image.file(_imageFile)
                                      : ElevatedButton.icon(
                                          icon:
                                              const Icon(Icons.add_a_photo, size: 50),
                                          onPressed: pickImage,
                                          label: const Text("Add a Photo"),
                                        )),
                            ),
                          ],
                        ),
                      ),
                      uploadImageButton(context),
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 16.0),
                          margin: const EdgeInsets.only(
                              top: 30, left: 20.0, right: 20.0, bottom: 20.0),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: bool1
                                    ? [Colors.lightGreen, Colors.green]
                                    : [yellow, orange],
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: ElevatedButton(
                            onPressed: () => urlget('$calledurl/$ID'),
                            child: Text(
                              '$per predict',
                              style: const TextStyle(fontSize: 20),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            body: Stack(children: <Widget>[
              Container(
                height: 400,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    gradient: LinearGradient(
                        colors: [orange, yellow],
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
                      "Input Image ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      decoded1["Output"]["inputimgurl"],
                      height: 100,
                    ),
                    const Text(
                      "Predicted Image ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Image.network(
                      decoded1["Output"]["outputimgurl2"],
                      height: 300,
                      width: 400,
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Personality Trait ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
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
            ]),
          );
  }
}
