import 'package:flutter/material.dart';
import 'package:hello_world/results2.dart';

// ignore: must_be_immutable
class Result extends StatelessWidget {
  int length1;
  var decoded1;
  Result(this.decoded1, this.length1, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Personality Detection')),body: Resultblog(decoded1, length1));
  }
}

// ignore: must_be_immutable
class Resultblog extends StatefulWidget {
  int length1;
  var decoded1;
  Resultblog(this.decoded1, this.length1, {super.key});
  @override
  _ResultblogState createState() => _ResultblogState();
}

class _ResultblogState extends State<Resultblog> {

  List<String> emails = [];
  @override
  void initState(){
    super.initState();
    for(var i=0;i<widget.length1;i++){
      if(emails.contains(widget.decoded1["Output"][i.toString()]["email"])){
          print("present");
        }
      else{
          emails.add(widget.decoded1["Output"][i.toString()]["email"]);
      }
    }
    print(emails.length);
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: emails.length,
      itemBuilder: (context,index){
        return Card(
          child:ListTile(
            title: Text(emails[index],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            leading:const Icon(Icons.email),
            trailing:IconButton(
              icon:const Icon(Icons.arrow_forward),
              onPressed:()=> Navigator.push(context,
                MaterialPageRoute(builder: (context)=>Result1(widget.decoded1,widget.length1,emails[index]))),
              ),
          ),
        );
      }
    );
  }
}