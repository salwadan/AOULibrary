import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/theAdmin/adminPage.dart';

class DeletePage extends StatelessWidget {
  const DeletePage({Key? key}) : super(key: key);

  // Method to delete an entire document
  Future<void> deleteDocument(DocumentReference reference) async {
    await reference.delete();
  }

  // Method to delete a specific field from a document
  Future<void> deleteField(DocumentReference reference, String field) async {
    await reference.update({field: FieldValue.delete()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a title and a back button
      appBar: AppBar(
        title: const Text("Delete Data"),
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

      // Body contains a list of sections to delete data
      body: ListView(
        children: [
          _buildSection(
            title: "Courses",
            collectionName: 'courses',
            subCollectionName: 'course_name',
            fields: ['lecture', 'old_exam', 'summary', 'overview'],
          ),
          _buildSection(
            title: "Graduation Projects",
            collectionName: 'graduation_projects',
            fields: ['description', 'image_url', 'programming_language', 'student_name', 'project_type'],
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
// Builds a section for each data category (Courses, Graduation Projects, Internships)
  Widget _buildSection({
    required String title,
    required String collectionName,
    String? subCollectionName,
    required List<String> fields,
  }) {
    return ExpansionTile(// when clicking the title, the children appear
      title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      children: [
        // Fetches real-time updates from Firestore
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

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Document: $documentId"),
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              _showDeleteDocumentConfirmationDialog(context, reference);
            },
            child: const Text("Delete Entire Document"),
          ),
          ...fields.map((field) {
            return ListTile(
              title: Text(field),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteFieldConfirmationDialog(context, reference, field);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showDeleteDocumentConfirmationDialog(
      BuildContext context, DocumentReference reference) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this document?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteDocument(reference);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Document deleted successfully")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFieldConfirmationDialog(
      BuildContext context, DocumentReference reference, String field) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Are you sure you want to delete the field '$field'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteField(reference, field);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Field deleted successfully")),
                );
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
