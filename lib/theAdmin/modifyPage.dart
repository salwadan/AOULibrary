import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/theAdmin/adminPage.dart';

class ModifyPage extends StatelessWidget {
  const ModifyPage({Key? key}) : super(key: key);

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
            arrayFields: ['lecture', 'old_exam', 'summary'],
            otherFields: ['overview'],
          ),
          _buildSection(
            title: "Graduation Projects",
            collectionName: 'graduation_projects',
            arrayFields: [],
            otherFields: [
              'description',
              'image_url',
              'programming_language',
              'student_name',
              'project_type'
            ],
          ),
          _buildSection(
            title: "Internships",
            collectionName: 'internships',
            arrayFields: [],
            otherFields: [
              'Email',
              'city',
              'contact_number',
              'description',
              'image_url',
              'location',
              'company_name'
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String collectionName,
    String? subCollectionName,
    required List<String> arrayFields,
    required List<String> otherFields,
  }) {
    return ExpansionTile(
      title: Text(title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: subCollectionName == null
              ? FirebaseFirestore.instance
                  .collection(collectionName)
                  .snapshots()
              : FirebaseFirestore.instance
                  .collectionGroup(subCollectionName)
                  .snapshots(),
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
                  arrayFields: arrayFields,
                  otherFields: otherFields,
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
    required List<String> arrayFields,
    required List<String> otherFields,
  }) {
    final documentId = document.id;
    final reference = document.reference;

    // Controllers for non-array fields
    final Map<String, dynamic> modifiedData = {
      for (var field in otherFields) field: document[field]?.toString() ?? '',
      for (var field in arrayFields)
        field: List<String>.from(document[field] ?? []),
    };

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text("Document: $documentId"),
        children: [
          ...otherFields.map(
            (field) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: modifiedData[field],
                  decoration: InputDecoration(labelText: field),
                  onChanged: (value) {
                    modifiedData[field] = value;
                  },
                ),
              );
            },
          ).toList(),
          ...arrayFields.map((field) {
            final List<dynamic> fieldValues = modifiedData[field] ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    field,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: fieldValues.length,
                  itemBuilder: (context, index) {
                    final controller = TextEditingController(
                        text: fieldValues[index]?.toString());
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: "$field #${index + 1}",
                        ),
                        onChanged: (newValue) {
                          fieldValues[index] = newValue;
                        },
                      ),
                    );
                  },
                ),
              ],
            );
          }).toList(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              // Gather updated data from controllers
              await reference.update(modifiedData);

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
