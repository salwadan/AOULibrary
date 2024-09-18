import 'package:flutter/material.dart';


class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
      child: Scaffold(
          appBar: AppBar(
        title: Text(
          'Courses',
          style: TextStyle(color: Colors.blue),
        ),
        bottom: TabBar(tabs: [
          Tab(
            child: Text('Feedback', style: TextStyle(color: Colors.blue),),
            
          ),
          Tab(
            child: Text('material', style: TextStyle(color: Colors.blue),
            ),
          )
        ]),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: TabBarView(children: [
          Text("Comment"),
          Text('Course Material'),
        ]),
      ),
      ),

    );
  }
}
