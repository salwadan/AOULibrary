import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salwa_app/GraduationP/projectPage.dart';

class Graduationprojects extends StatefulWidget {
  const Graduationprojects({super.key});

  @override
  State<Graduationprojects> createState() => _GraduationprojectsState();
}

class _GraduationprojectsState extends State<Graduationprojects> {
  // List to store project data fetched from Firestore
  List<Map<String, dynamic>> projectData = [];
  List<Map<String, dynamic>> filteredData = []; // Filtered project data
  String selectedCategory = 'All'; // Selected category for filtering

  @override
  void initState() {
    super.initState();
    fetchProjectData(); // Fetch data when the widget is initialized
  }

  // Function to fetch project data from Firestore
  Future<void> fetchProjectData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('graduation_projects')
          .get();

      setState(() {
        projectData = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'id': doc.id,
            'project_name': data['project_name'] ?? 'N/A',
            'student_name': data['student_name'] ?? 'N/A',
            'image_url': data['image_url'] ?? '',
            'description': data['description'] ?? 'No description available.',
            'programming_language':
                data['programming_language'] ?? 'Not specified',
            'project_type': data['project_type'] ?? 'Unknown Type',
          };
        }).toList();
        filteredData = projectData; // Initialize filtered data
      });
    } catch (e) {
      print("Failed to fetch project data: $e");
    }
  }

  // Function to filter project data by category, ignoring case sensitivity
  void filterProjects(String category) {
    setState(() {
      if (category == 'All') {
        filteredData = projectData;
      } else {
        filteredData = projectData
            .where((project) =>
                project['project_type'].toString().toLowerCase() ==
                category.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graduation Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProjectSearchDelegate(projectData),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Dropdown menu for filtering
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              items: ['All', 'Application', 'Website', 'AI', 'Robot', 'Hardware']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                  filterProjects(value);
                }
              },
            ),
          ),
          // Display filtered projects or a message when no data is available
          Expanded(
            child: filteredData.isEmpty
                ? const Center(
                    child: Text(
                      "No projects available for the selected category.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredData.length,
                    itemBuilder: (context, index) {
                      final project = filteredData[index];

                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Projectpage(
                                projectId: project['id'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26, width: 3),
                            color: Colors.white,
                            boxShadow: const [
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
                                title: Text(project['project_name'],style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("By: ${project['student_name']}",style: TextStyle(color:Colors.blue),),
                                    Text("Type: ${project['project_type']}"),
                                  ],
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                  ),
                                  width: 57,
                                  height: 57,
                                  child: Image.network(
                                    project['image_url'],
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, i) => const Divider(
                      color: Colors.white,
                      height: 4,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> projectData;

  ProjectSearchDelegate(this.projectData);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = projectData
        .where((project) =>
            project['project_name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();

    return results.isEmpty
        ? const Center(
            child: Text("No projects found matching your search."),
          )
        : ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final project = results[index];
              return ListTile(
                title: Text(project['project_name']),
                subtitle: Text("By: ${project['student_name']}"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Projectpage(
                        projectId: project['id'],
                      ),
                    ),
                  );
                },
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
