import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Pageofproject extends StatelessWidget {
  const Pageofproject({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Project"),
      ),
     body:  SafeArea(
       child: SingleChildScrollView(
          child: Row(
            children: [
              Container(
              height: 100,
              width: 100,
              color: Colors.orange,
             ),
            ],
          ),
        ),
     ),
    );
  }
}