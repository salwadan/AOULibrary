import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/theAdmin/adminPage.dart';

class ModifyPage extends StatelessWidget {
  const ModifyPage({Key? key}) : super(key: key);

  Future<void> updateDocument(
      DocumentReference reference, Map<String, dynamic> updatedData) async {
    await reference.update(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modify Data"),
        backgroundColor: const Color.fromARGB(255, 155, 182, 229),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminPage()),
            );
          },
          tooltip: "Back to Admin Page",
        ),
      ),
      body: ListView(
        children: [
          _buildSection(
            title: "Courses",
            collectionName: 'courses',
            subCollectionName: 'course_name',
            fields: ['lecture', 'old_exam', 'summary'],
          ),
          _buildSection(
            title: "Graduation Projects",
            collectionName: 'graduation_projects',
            fields: ['description', 'image_url', 'programming_language', 'student_name','project_type'],
          ),
          _buildSection(
            title: "Internships",
            collectionName: 'internships',
            fields: ['Email', 'city', 'contact_number', 'description', 'image_url', 'location'],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String collectionName,
    String? subCollectionName,
    required List<String> fields,
  }) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: subCollectionName == null
              ? FirebaseFirestore.instance.collection(collectionName).snapshots()
              : FirebaseFirestore.instance.collectionGroup(subCollectionName).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return const Center(child: Text("No data available."));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return _buildDocumentTile(
                  context: context,
                  document: document,
                  fields: fields,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentTile({
    required BuildContext context,
    required QueryDocumentSnapshot document,
    required List<String> fields,
  }) {
    final documentId = document.id;
    final reference = document.reference;

    // Create a controller for each field
    final Map<String, TextEditingController> controllers = {
      for (var field in fields)
        field: TextEditingController(text: document[field]?.toString() ?? ''),
    };

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Document: $documentId"),
        children: [
          ...fields.map(
            (field) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: controllers[field],
                  decoration: InputDecoration(labelText: field),
                ),
              );
            },
          ).toList(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              // Gather updated data from controllers
              final updatedData = {
                for (var field in fields) field: controllers[field]!.text,
              };

              updateDocument(reference, updatedData);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Changes saved successfully")),
              );
            },
            child: const Text("Save Changes"),
          ),
        ],
      ),
    );
  }
}
