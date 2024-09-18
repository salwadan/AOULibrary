import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/courses.dart';
import 'graduationProjects.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List img = [
    "assets/courses.png",
    "assets/graduation project.png",
    "assets/internship.png",
    "assets/chat.png"
  ];
  List titles = ["Courses", "Graduation Projects", "Internship", "Chat"];
List<Widget> classes = [
    Courses(),
    Graduationprojects(),
    Courses(),
    Graduationprojects(),
  ];

  @override
  Widget build(BuildContext context) {
     var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("login", (route) => false);
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 25,
                childAspectRatio: 1,
                
              ),
             
              itemCount: img.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index, ) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => classes[index]));
                  },
                  child: Container(
                    height: screenHeight,
                    width: screenWiidth,
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusDirectional.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 6,
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          width: 300,
                          child: Image.asset(
                            img[index],
                            height: 130,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                         width: screenWiidth,
                          alignment: Alignment.center,
                          color: const Color.fromARGB(255, 204, 231, 253),
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),);
  }
}
