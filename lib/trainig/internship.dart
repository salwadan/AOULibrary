import 'package:flutter/material.dart';
import 'package:salwa_app/trainig/companyInfo.dart';

class Internship extends StatefulWidget {
  const Internship({super.key});

  @override
  State<Internship> createState() => _InternshipState();
}

class _InternshipState extends State<Internship> {
  List internshipData = [
    {"Company Name": "Google", "city": "Jeddah", "image": "assets/google.png"}
  ];
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(
          title: Text('Internship'),
        ),
        body: ListView.separated(
          itemCount: internshipData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Companyinfo()));
              },
              child: Container(
                
                  padding: EdgeInsets.all(8),
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
                      title: Text(internshipData[index]['Company Name']),
                      subtitle: Text(internshipData[index]['city']),
                      trailing: Icon(Icons.arrow_forward_ios),
                      leading: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(10),
                          border: Border.all(color: const Color.fromARGB(255, 205, 202, 202)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              spreadRadius: 1,
                              blurRadius: 3,
                          )]
                        ),
                        child: Image.asset(internshipData[index]['image'])),
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
        ));
  }
}
