import 'package:flutter/material.dart';
import 'package:hello_world/upload2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_world/results.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hello_world/paintsig.dart';

class MyHomePage1 extends StatelessWidget {
  final User user1;
  const MyHomePage1(this.user1, {super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personality Detection')),
      body: MyHomePage(user1),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final User user;

  const MyHomePage(this.user, {super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> decoded1 = {};
  int length1 = 0;
  bool showing = true;
  String emailvalue = "";
  String detect = "";

  void predict({required User user1}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Uploading1(user1)),
    );
    print("predict----------------------------------------------");
  }

  void show() async {
    emailvalue = widget.user.email!;
    print(emailvalue);
    if (emailvalue == "") {
      emailvalue = "999";
      detect = "Fetching All Users data";
    }
    final response = await http.get(
      Uri.parse('https://flutter-graphology.herokuapp.com/show/$emailvalue'),
    );
    print(response.body);
    decoded1 = json.decode(response.body);
    print("decoded1-----------------------------------------------------------------------");
    print(decoded1);
    print(decoded1["Output"]["0"]);
    length1 = decoded1["Output"].length;
    print(length1);
    if (length1 == 0) {
      setState(() {
        detect = "There is no such user in the database";
      });
    }
    print(emailvalue);
    if (length1 != 0) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Result(decoded1, length1)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 220,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
              gradient: LinearGradient(
                colors: [Colors.redAccent, Colors.yellow, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Image.network(widget.user.photoURL!, height: 130, width: 400),
          Expanded(
            child: Text(
              " Welcome ${widget.user.displayName}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => predict(user1: widget.user),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ), backgroundColor: Colors.lightBlue,
                    elevation: 10,
                    splashFactory: InkRipple.splashFactory,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text(
                    "Image",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: show,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ), backgroundColor: Colors.lightBlue,
                    elevation: 10,
                    splashFactory: InkRipple.splashFactory,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text(
                    "History",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Paintsig(widget.user)),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ), backgroundColor: Colors.lightBlue,
                    elevation: 10,
                    splashFactory: InkRipple.splashFactory,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text(
                    "Digital Pen",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
