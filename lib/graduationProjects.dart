import 'package:flutter/material.dart';

import 'package:salwa_app/dashboard.dart';

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Graduationprojects> {
  List projectsName = [
    {
      'project Name': 'Volunteer',
      'student name': 'Ahmed',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Library',
      'student name': 'Asma',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Game',
      'student name': 'Mona',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Cars',
      'student name': 'Sameer',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Volunteer',
      'student name': 'Ahmed',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Library',
      'student name': 'Asma',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Game',
      'student name': 'Mona',
      'image': 'assets/mylogo.png'
    },
    {
      'project Name': 'Cars',
      'student name': 'Sameer',
      'image': 'assets/mylogo.png'
    }
  ];
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
              title: Text('Graduation Projects'),
              actions: [
                PopupMenuButton(
                    elevation: 10,
                    onSelected: (val) {
                      print(val);
                    },
                    itemBuilder: (cotext) => [
                          PopupMenuItem(
                            child: Text('filter'),
                            value: 'filter',
                          ),
                          PopupMenuItem(child: Text('search'), value: 'search'),
                        ]),
                IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: CustomeSearch());
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            body: ListView.separated(
              itemCount: projectsName.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                      //padding: EdgeInsets.all(8),
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26, width: 3),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 6,
                            )
                          ]),
                      child: Column(children: [
                        ListTile(
                          title: Text(projectsName[index]['project Name']),
                          subtitle: Text(projectsName[index]['student name']),
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                              ),
                              width: 57,
                              height: 57,
                              child: Image.asset(projectsName[index]['image'],
                                  fit: BoxFit.cover)),
                        ),
                      ])),
                );
              },
              separatorBuilder: (context, i) {
                return Divider(
                  color: Colors.white,
                  height: 4,
                );
              },
            )));
  }
}

class CustomeSearch extends SearchDelegate {
  List Projects = ['Volunteer', 'Library', 'Game', 'Cars'];
  List? filterList; // another list

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = ""; // when tap on it it will close
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(

        // it appears before the search
        onPressed: () {
          close(context, null); // return null to return back
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(''); // when we tap on the searched content this is will apear
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      // apear all data
      return ListView.builder(
          itemCount: Projects.length,
          itemBuilder: (context, i) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  "${Projects[i]}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          });
    } else {
      // if user entered some data to be searched
      filterList = Projects.where((element) => element.startsWith(query))
          .toList(); // it will check if element in projects list has the same letters of query var then assign it to filterList
      return ListView.builder(
          itemCount: filterList!.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () {
                //showResults(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    "${filterList![i]}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            );
          });
    }
  }
}
