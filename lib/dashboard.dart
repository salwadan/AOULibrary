import 'package:flutter/material.dart';
import 'package:salwa_app/homepage.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int index = 0;

  
  @override
  Widget build(BuildContext context) {
    

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              onTap: (val) {
                setState(() {
                  index = val;
                });
              },
              currentIndex: index,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ]),
          appBar: AppBar(
            title: Text(
              'Home',
              style: TextStyle(
                color: const Color.fromARGB(255, 8, 65, 149),
              ),
            ),
          ),
          drawer: Drawer(
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 15),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/mylogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text('AOU Library'),
                        ),
                      )
                    ],
                  ),
                  ListTile(
                    title: Text('Home'),
                    leading: Icon(Icons.home),
                    onTap: () {},
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: Text('Acount'),
                    leading: Icon(Icons.person),
                    onTap: () {},
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                  ListTile(
                    title: Text('chat'),
                    leading: Icon(Icons.chat),
                    onTap: () {},
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          body: Homepage(),
        ));
  }
}
