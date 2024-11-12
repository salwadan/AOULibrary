import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/GraduationP/pageOfProject.dart';

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Graduationprojects> {
  List projectData = [];

  @override
  void initState() {
    super.initState();
    fetchProjectData();
  }

  Future<void> fetchProjectData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('graduation_projects')
          .get();

      List<QueryDocumentSnapshot> docs = snapshot.docs;

      setState(() {
        projectData = docs.map((doc) => {
              'project_name': doc['project_name'],
              'student_name': doc['student_name'],
              'image_url': doc['image_url'],
              'description': doc['description'],
              'programming_language': doc['programming_language'],
            }).toList();
      });
    } catch (e) {
      print("Failed to fetch project data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graduation Projects'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProjectSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: projectData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: projectData.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Pageofproject(
                          projectName: projectData[index]['project_name'],
                          studentName: projectData[index]['student_name'],
                          description: projectData[index]['description'],
                          imageUrl: projectData[index]['image_url'],
                          programmingLanguage: projectData[index]
                              ['programming_language'],
                        ),
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
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(projectData[index]['project_name']),
                          subtitle: Text(projectData[index]['student_name']),
                          trailing: Icon(Icons.arrow_forward_ios),
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                            ),
                            width: 57,
                            height: 57,
                            child: Image.network(
                              projectData[index]['image_url'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, i) => Divider(
                color: Colors.white,
                height: 4,
              ),
            ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate {
  Future<List<Map<String, dynamic>>> searchProjects(String query) async {
    try {
      // Adjust the query for case-insensitive search
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('graduation_projects')
          .get();

      // Filter results locally by comparing lowercase query to lowercase project name
      return snapshot.docs
          .where((doc) => doc['project_name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .map((doc) => {
                'project_name': doc['project_name'],
                'student_name': doc['student_name'],
                'image_url': doc['image_url'],
                'description': doc['description'],
                'programming_language': doc['programming_language'],
              })
          .toList();
    } catch (e) {
      print("Failed to search project data: $e");
      return [];
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context); // Trigger update when cleared
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Results are continuously shown in suggestions as user types
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchProjects(query),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No results found"));
        }

        var results = snapshot.data!;

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            var project = results[index];
            return ListTile(
              title: Text(project['project_name']),
              subtitle: Text(project['student_name']),
              leading: Container(
                width: 57,
                height: 57,
                child: Image.network(
                  project['image_url'],
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Pageofproject(
                      projectName: project['project_name'],
                      studentName: project['student_name'],
                      description: project['description'],
                      imageUrl: project['image_url'],
                      programmingLanguage: project['programming_language'],
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
