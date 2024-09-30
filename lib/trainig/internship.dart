import 'package:flutter/material.dart'; // Importing Flutter's material design package
import 'package:cloud_firestore/cloud_firestore.dart'; // Importing Firestore package for database operations
import 'package:salwa_app/trainig/companyInfo.dart'; // Custom file that shows detailed information about a company

// Defining a StatefulWidget named Internship
class Internship extends StatefulWidget {
  const Internship({super.key}); // Constructor for the Internship widget

  @override
  State<Internship> createState() =>
      _InternshipState(); // Creating the state for the Internship widget
}

// State class for the Internship widget
class _InternshipState extends State<Internship> {
  List internshipData =
      []; // List to hold internship data fetched from Firestore

  @override
  void initState() {
    super.initState();
    fetchInternshipData(); // Fetching internship data when the widget is initialized
  }

  // Function to fetch internship data from Firestore
  Future<void> fetchInternshipData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('internships')
          .get(); // Fetching data from 'internships' collection

      List<QueryDocumentSnapshot> docs =
          snapshot.docs; // Getting the list of documents from the snapshot

      setState(() {
        internshipData = docs
            .map((doc) => {
                  'company_name':
                      doc['company_name'], // Extracting company name
                  'city': doc['city'], // Extracting city
                  'contact_number':
                      doc['contact_number'], // Extracting contact number
                  'email':
                      doc['Email'], // Extracting email (note the key 'Email')
                  'description': doc['description'], // Extracting description
                  'image_url': doc['image_url'], // Extracting image URL
                  'location': doc['location'], // Extracting location
                })
            .toList(); // Converting the list of documents to a list of maps
      });
    } catch (e) {
      print(
          "Failed to fetch internship data: $e"); // Printing error message if fetching fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internship'), // Setting the title of the app bar
      ),
      body: internshipData.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(), // Showing a loading indicator if data is not yet fetched
            )
          : ListView.separated(
              itemCount: internshipData.length, // Number of items in the list
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Companyinfo(
                          companyName: internshipData[index]['company_name'] ??
                              'N/A', // Passing company name to Companyinfo widget
                          city: internshipData[index]['city'] ??
                              'N/A', // Passing city to Companyinfo widget
                          email: internshipData[index]['email'] ??
                              'N/A', // Passing email to Companyinfo widget
                          phone: internshipData[index]['contact_number'] ??
                              'N/A', // Passing contact number to Companyinfo widget
                          location: internshipData[index]['location'] ??
                              'N/A', // Passing location to Companyinfo widget
                          about: internshipData[index]['description'] ??
                              'No description available.', // Passing description to Companyinfo widget
                          imageUrl: internshipData[index]['image_url'] ??
                              '', // Passing image URL to Companyinfo widget
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.all(8), // Padding inside the container
                    margin: const EdgeInsets.only(
                        top: 5), // Margin at the top of the container
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black26, width: 3), // Border styling
                      color: Colors.white, // Background color
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Shadow color
                          spreadRadius: 1, // Spread radius of the shadow
                          blurRadius: 6, // Blur radius of the shadow
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(internshipData[index]
                              ['company_name']), // Displaying company name
                          subtitle: Text(
                              internshipData[index]['city']), // Displaying city
                          trailing: const Icon(Icons
                              .arrow_forward_ios), // Icon indicating navigation
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(
                                  10), // Rounded corners for the leading container
                              border: Border.all(
                                  color: const Color.fromARGB(255, 205, 202,
                                      202)), // Setting the border color using ARGB values
                              color: Colors
                                  .white, // Setting the background color to white
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26, // Shadow color
                                  spreadRadius:
                                      1, // Spread radius of the shadow
                                  blurRadius: 3, // Blur radius of the shadow
                                )
                              ],
                            ),
                            child: Image.network(internshipData[index][
                                'image_url']), // Displaying the company image from the URL
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return const Divider(
                  color: Colors.white, // Setting the color of the divider
                  height: 4, // Setting the height of the divider
                );
              },
            ),
    );
  }
}
