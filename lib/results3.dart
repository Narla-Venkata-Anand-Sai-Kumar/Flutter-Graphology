
import 'package:flutter/material.dart';

class Result2 extends StatelessWidget {
  int length1;
  var decoded1;
  String email;
  String date;
  Result2(this.decoded1, this.length1,this.email,this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Personality Detection')),body: Resultblog2(decoded1, length1,email,date));
  }
}

// ignore: must_be_immutable
class Resultblog2 extends StatefulWidget {
  int length1;
  var decoded1;
  String email;
  String date;
  Resultblog2(this.decoded1, this.length1,this.email,this.date, {super.key});
  @override
  _Resultblog2State createState() => _Resultblog2State();
}

class _Resultblog2State extends State<Resultblog2> {
  var decodedone;
  List<String> temp=[] ;
  @override
  void initState(){
    super.initState();
    for(var i=0;i<widget.length1;i++){
      if(widget.email==widget.decoded1["Output"][i.toString()]["email"] && widget.date==widget.decoded1["Output"][i.toString()]["time"]){
        decodedone=widget.decoded1["Output"][i.toString()];
        temp.add("1");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return 
        ListView.builder(
          itemCount: temp.length,
          itemBuilder: (context,index){
            return Card(
              child:Column(children: <Widget>[
                    const SizedBox(height: 13,),
                    const Divider(color:Colors.black),
                    // Text('$index',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                    // Text("User's Email :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Align(alignment: Alignment.bottomCenter,child: Text(decodedone["email"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    const Divider(color:Colors.black),
                    const SizedBox(height: 13,),
                    // Text("Time :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Align(alignment: Alignment.bottomCenter,child: Text(decodedone["time"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    const SizedBox(height: 13,),
                    const Text("Input Image ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    Image.network(decodedone["input"],height: 200,),
                    // Text("Output Image1 :",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    // Image.network(decodedone["output1"],height: 300,width: 400,),                
                    const Text("Predicted Image",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),                
                    Image.network(decodedone["output2"],height: 300),                
                    const Align(alignment: Alignment.bottomCenter,child: Text("Personality Traits",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),),                
                    Align(alignment: Alignment.bottomRight,child: Text(decodedone["info0"]+decodedone["info1"]+decodedone["info2"]+decodedone["info3"]+decodedone["info4"]+decodedone["info5"],style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),
                    
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info0"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info1"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info2"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info3"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info4"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),                
                    // new Align(alignment: Alignment.bottomLeft,child: new  Text(decodedone["info5"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),),
                ],),
            );
          }
        );
  }
}