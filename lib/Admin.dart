import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hello_world/results.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Personality Detection')),
        body: const Adminblog());
  }
}

class Adminblog extends StatefulWidget {
  const Adminblog({super.key});

  @override
  _AdminblogState createState() => _AdminblogState();
}

class _AdminblogState extends State<Adminblog> {
  var decoded1;
  late int length1;
  bool showing = true;
  String emailvalue = "";
  String detect = "";
  void show() async {
    // ignore: await_only_futures
    print(emailvalue);
    if (emailvalue == "") {
      emailvalue = "999";
      detect = "Fetching All Users data";
    }
    final response = await http.get(Uri.parse(
        'https://flutter-graphology.herokuapp.com/show/$emailvalue'));
    print(response.body);
    decoded1 = json.decode(response.body) as Map<String, dynamic>;
    print(
        "decoded1-----------------------------------------------------------------------");
    print(decoded1);
    print(decoded1["Output"]["0"]);
    length1 = decoded1["Output"].length;
    print(length1);
    if (length1 == 0) {
      setState(() {
        detect = "There is no  data in database";
      });
    }
    print(emailvalue);
    if (length1 != 0) {
      setState(() {
        // showing=false;
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Result(decoded1, length1)));
        print("navigation");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Column(
          children: [
            Text('Admin Blog',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
            "If you want to see all users Data then Click Submit Button without Filling User's Email",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            decoration: const InputDecoration(
              labelText: "User's Email",
              labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
              hintText: 'Enter Users Email',
            ),
            autofocus: false,
            onChanged: (value) => emailvalue = value,
          ),
        ),
        ElevatedButton(
          onPressed: () => show(),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)), backgroundColor: Colors.lightBlueAccent,
            elevation: 8,
            splashFactory: InkRipple.splashFactory,
            padding: const EdgeInsets.all(20),
          ),
          child: const Text('Submit'),
        ),
        Text(
          detect,
          style: const TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
        )
      ],
    ));
  }
}
