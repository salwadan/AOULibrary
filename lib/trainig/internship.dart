import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/trainig/companyInfo.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Defining a StatefulWidget named Internship
class Internship extends StatefulWidget {
  const Internship({super.key});

  @override
  State<Internship> createState() => _InternshipState();
}

class _InternshipState extends State<Internship> {
  List internshipData = []; // List to hold internship data fetched from Firestore
  List filteredInternshipData = []; // List to hold filtered internship data
  String selectedCity = "All"; // Default filter value
  bool isLoading = true; // Loading state indicator

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
                  'company_name': doc['company_name'], // Extracting company name
                  'city': doc['city'], // Extracting city
                  'contact_number': doc['contact_number'], // Extracting contact number
                  'email': doc['Email'], // Extracting email
                  'description': doc['description'], // Extracting description
                  'image_url': doc['image_url'], // Extracting image URL
                  'location': doc['location'], // Extracting location
                })
            .toList(); // Converting the list of documents to a list of maps
        filteredInternshipData = internshipData; // Initial data for filtered list
        isLoading = false; // Data has been loaded
      });
    } catch (e) {
      print("Failed to fetch internship data: $e");
      setState(() {
        isLoading = false; // Data fetching complete with error
      });
    }
  }

  // Function to filter internships by city
  void filterByCity(String city) {
    setState(() {
      if (city == "All") {
        filteredInternshipData = internshipData;
      } else {
        filteredInternshipData = internshipData
            .where((data) => data['city'] == city)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:  AutoSizeText(
          'Internship',
          presetFontSizes: [screenWiidth >= 700? 40 : 25], // Adjust text size dynamically.
        ),
        actions: [
          // Search icon in the AppBar.
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Show search functionality when pressed.
              showSearch(
                context: context,
                delegate: InternshipSearchDelegate(),
              );
            },
          ),
           // Filter button in the AppBar.
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedCity = value; // Update selected city.
                filterByCity(selectedCity); // Apply filter.
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "All", child: Text("All")),
              const PopupMenuItem(value: "Jeddah", child: Text("Jeddah")),
              const PopupMenuItem(value: "Riyadh", child: Text("Riyadh")),
              const PopupMenuItem(value: "Dammam", child: Text("Dammam")),
              const PopupMenuItem(value: "Madinah", child: Text("Madinah")),
            ],
            icon: const Icon(Icons.filter_list), // Icon for filtering.
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner
          : filteredInternshipData.isEmpty
              ? const Center(
                  child: Text(
                    "No internships found.", // Display message if no data is found.
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ) // Show message when no data is found
              : ListView.separated( // Display internship data in a list.
                  itemCount: filteredInternshipData.length, // Number of items.
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            // Navigate to detailed info page on tap.

                            builder: (context) => Companyinfo(
                              companyName: filteredInternshipData[index]['company_name'] ?? 'N/A',
                              city: filteredInternshipData[index]['city'] ?? 'N/A',
                              email: filteredInternshipData[index]['email'] ?? 'N/A',
                              phone: filteredInternshipData[index]['contact_number'] ?? 'N/A',
                              location: filteredInternshipData[index]['location'] ?? 'N/A',
                              about: filteredInternshipData[index]['description'] ?? 'No description available.',
                              imageUrl: filteredInternshipData[index]['image_url'] ?? '',
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
                              title: AutoSizeText(
                                filteredInternshipData[index]['company_name'], //display company name
                                presetFontSizes: [screenWiidth >= 700? 50 : 25],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                              subtitle: AutoSizeText(filteredInternshipData[index]['city'], // display city
                               presetFontSizes: [screenWiidth >= 700? 30 : 15],
                               style: TextStyle(color:  Color(0xFF2196F3),)
                               
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios), // Icon indicating navigation.
                              leading: Container( // decoration for the rectangule
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(10),
                                  border: Border.all(color: const Color.fromARGB(255, 250, 247, 247)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                    )
                                  ],
                                ),
                                child: Image.network(filteredInternshipData[index]['image_url']), // logo for the company
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const Divider(color: Colors.white, height: 4); // put dividor after each listTile
                  },
                ),
    );
  }
}

// SearchDelegate for Internship search
class InternshipSearchDelegate extends SearchDelegate {
   // Function to search internships in Firestore based on the query.
  Future<List<Map<String, dynamic>>> searchInternships(String query) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('internships')
          .get();

      // Filter internships case-insensitively
      return snapshot.docs
          .where((doc) => doc['company_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .map((doc) => {
                'company_name': doc['company_name'],
                'city': doc['city'],
                'contact_number': doc['contact_number'],
                'email': doc['Email'],
                'description': doc['description'],
                'image_url': doc['image_url'],
                'location': doc['location'],
              })
          .toList();
    } catch (e) {
      print("Failed to search internship data: $e");
      return [];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the query text.
          showSuggestions(context); // Trigger update when cleared
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search delegate.
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context); // Show results in suggestions as user types
  }

  @override
  Widget buildSuggestions(BuildContext context) { // to display suggestion when search
    return FutureBuilder(
      future: searchInternships(query),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No results found.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } 

        var results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            var internship = results[index];
            return ListTile(
              title: Text(internship['company_name']),
              subtitle: Text(internship['city']),
              leading: Container(
                width: 57,
                height: 57,
                child: Image.network(internship['image_url'], fit: BoxFit.cover),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Companyinfo(
                      companyName: internship['company_name'],
                      city: internship['city'],
                      email: internship['email'],
                      phone: internship['contact_number'],
                      location: internship['location'],
                      about: internship['description'],
                      imageUrl: internship['image_url'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
