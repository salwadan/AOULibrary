import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Allows interaction with the Firestore database
import 'package:salwa_app/trainig/companyInfo.dart';

class Internship extends StatefulWidget {
  const Internship({super.key});

  @override
  State<Internship> createState() => _InternshipState();
}

class _InternshipState extends State<Internship> {
  List internshipData =
      []; //A list to store the fetched internship data from Firestore

  @override
  void initState() {
    super.initState();
    fetchInternshipData();
  }

  Future<void> fetchInternshipData() async {
    try {
      QuerySnapshot
          snapshot = //A snapshot of the documents in the Firestore collection named internships.
          await FirebaseFirestore.instance.collection('internships').get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      setState(() {
        //Updates the internshipData
        internshipData = docs //A list of documents fetched from the snapshot.
            .map((doc) => {
                  'company_name': doc['company_name'],
                  'city': doc['city'],
                  'contact_number': doc['contact_number'],
                  'description': doc['description'],
                  'image_url': doc['image_url'],
                  'location': doc['location']
                })
            .toList();
      });
    } catch (e) {
      print("Failed to fetch internship data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship'),
      ),
      body: internshipData.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : ListView.separated(
              //display the internship items.
              itemCount: internshipData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Companyinfo(
                          //Uses the ?? operator to provide default values in case the data is null.
                          companyName:
                              internshipData[index]['company_name'] ?? 'N/A',
                          city: internshipData[index]['city'] ?? 'N/A',
                          email:
                              internshipData[index]['contact_number'] ?? 'N/A',
                          phone:
                              internshipData[index]['contact_number'] ?? 'N/A',
                          location: internshipData[index]['location'] ?? 'N/A',
                          about: internshipData[index]['description'] ??
                              'No description available.',
                          imageUrl: internshipData[index]['image_url'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 3),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          //display the name,city,and picture from outside
                          title: Text(internshipData[index]['company_name']),
                          subtitle: Text(internshipData[index]['city']),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 205, 202, 202)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                )
                              ],
                            ),
                            child: Image.network(
                                internshipData[index]['image_url']),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return const Divider(
                  color: Colors.white,
                  height: 4,
                );
              },
            ),
    );
  }
}
