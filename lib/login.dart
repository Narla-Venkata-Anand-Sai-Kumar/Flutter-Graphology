import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/myHomePage.dart';
import 'auth.dart';
import 'chose.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Personality Detection')), body: const Body());
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User? user;

  @override
  void initState() {
    super.initState();
    signOutGoogle();
  }

void click() async {
  User? userCredential = await signInWithGoogle();
  
  if (userCredential != null) {
    setState(() {
      user = userCredential;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage1(user!)));
  }

  print("login-----------------------------------------");
  print(user);
}

  void admin(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Choose()));
  }

  Widget googleLoginButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 220,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0)),
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.yellow, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
        ),
        const SizedBox(height: 10,),
        const Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("User Login",style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10,),
        ElevatedButton.icon(
          onPressed: click,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          icon: Image.asset('assets/google-logo.jpg', height: 35),
          label: const Text('Sign in with Google', style: TextStyle(color: Colors.grey, fontSize: 25)),
        ),
        const SizedBox(height: 15,),
        ElevatedButton(
          onPressed: admin,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text("Admin Login", style: TextStyle(fontSize: 25)),
        ),
        const SizedBox(height: 10,),
        Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0)),
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.yellow, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.center, child: googleLoginButton());
  }
}
