import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:salwa_app/GraduationP/pageOfProject.dart';
import 'package:salwa_app/dashboard.dart'; // Adjust as needed

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Graduationprojects> {
  List projectData = []; // List to hold project data fetched from Firestore
  int index = 0;

  @override
  void initState() {
    super.initState();
    fetchProjectData(); // Fetch data when the widget is initialized
  }
  

  // Function to fetch project data from Firestore
  Future<void> fetchProjectData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('graduation_projects') // Get documents from Firestore
          .get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      // Map fetched documents to a list of project details
      setState(() {
        projectData = docs
            .map((doc) => {
                  'project Name': doc['project_name'], // Get project_name field
                  'student name': doc['student_name'], // Get student_name field
                  'image': doc[
                      'image_url'], // Assuming image_url field contains the image URL
                })
            .toList();
      });
    } catch (e) {
      print("Failed to fetch project data: $e"); // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height; // Get screen height
    var screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          onTap: (val) {
            setState(() {
              index = val; // Update current index
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
          ],
        ),
        appBar: AppBar(
          title: Text('Graduation Projects'),
          actions: [
            PopupMenuButton(
              elevation: 10,
              onSelected: (val) {
                print(val);
              },
              itemBuilder: (context) => [
                const PopupMenuItem(child: Text('filter'), value: 'filter'),
                const PopupMenuItem(child: Text('search'), value: 'search'),
              ],
            ),
            IconButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: CustomeSearch()); // Show search
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: projectData.isEmpty
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator if data is empty
            : ListView.separated(
                itemCount: projectData.length, // Use projectData length
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Pageofproject(
                            projectName: projectData[index]
                                ['project_name'], // Pass project name
                            studentName: projectData[index]
                                ['student_name'], // Pass student name
                            description: projectData[index]
                                ['description'], // Pass project description
                            imageUrl: projectData[index]
                                ['image_url'], // Pass image URL
                            programmingLanguage: projectData[index][
                                'programming_language'], // Pass programming language
                           // Placeholder for student email
                          ), // Navigate to project details page
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26, width: 3),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Column(children: [
                        ListTile(
                          title: Text(projectData[index][
                              'project Name']), // Use project name from Firestore
                          subtitle: Text(projectData[index][
                              'student name']), // Use student name from Firestore
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            width: 57,
                            height: 57,
                            child: Image.network(
                              projectData[index]
                                  ['image'], // Use Image.network for URLs
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ]),
                    ),
                  );
                },
                separatorBuilder: (context, i) {
                  return Divider(
                    color: Colors.white,
                    height: 4,
                  );
                },
              ),
      ),
    );
  }
}

class CustomeSearch extends SearchDelegate {
  List Projects = [
    'Volunteer',
    'Library',
    'Game',
    'Cars'
  ]; // Sample project names for search
  List? filterList; // List to hold filtered results

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ""; // Clear the search query
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null); // Close the search
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(''); // Placeholder for search results
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
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
        },
      );
    } else {
      // Filter the projects based on the search query
      filterList =
          Projects.where((element) => element.startsWith(query)).toList();
      return ListView.builder(
        itemCount: filterList!.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Dashboard())); // Navigate on tap
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
        },
      );
    }
  }
}
