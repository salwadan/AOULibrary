import 'package:flutter/material.dart';

class Projectpage extends StatefulWidget {
  const Projectpage({super.key});

  @override
  State<Projectpage> createState() => _ProjectpageState();
}

class _ProjectpageState extends State<Projectpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Project"),

       ), 
       body:Container(
        height: 200,
        width: 200,
        color: Colors.red,
       ) 

    );
  }
}