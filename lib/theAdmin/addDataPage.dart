import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:salwa_app/theAdmin/adminPage.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for Courses Section
  String selectedFaculty = 'Faculty_Of_Computer';
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController lectureController = TextEditingController();
  final TextEditingController oldExamController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();

  // Controllers for Graduation Projects Section
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescriptionController = TextEditingController();
  final TextEditingController projectImageUrlController = TextEditingController();
  final TextEditingController projectProgrammingLangController = TextEditingController();
  final TextEditingController projectStudentNameController = TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();

  // Controllers for Internships Section
  final TextEditingController internshipCompanyNameController = TextEditingController();
  final TextEditingController internshipEmailController = TextEditingController();
  final TextEditingController internshipCityController = TextEditingController();
  final TextEditingController internshipContactController = TextEditingController();
  final TextEditingController internshipDescriptionController = TextEditingController();
  final TextEditingController internshipImageUrlController = TextEditingController();
  final TextEditingController internshipLocationController = TextEditingController();

  String? _message;

  // Add Course Data
  Future<void> addCourse() async {
    if (_formKey.currentState!.validate()) {
      final courseRef = FirebaseFirestore.instance
          .collection('courses')
          .doc(selectedFaculty)
          .collection('course_name')
          .doc(courseNameController.text);
      await courseRef.set({
        'lecture': FieldValue.arrayUnion([lectureController.text]),
        'old_exam': FieldValue.arrayUnion([oldExamController.text]),
        'summary': FieldValue.arrayUnion([summaryController.text]),
      }, SetOptions(merge: true));
      setState(() {
        _message = "Course added successfully!";
      });
      clearFields();
    }
  }

  // Add Graduation Project Data
  Future<void> addGraduationProject() async {
    if (_formKey.currentState!.validate()) {
      final projectRef = FirebaseFirestore.instance
          .collection('graduation_projects')
          .doc(projectNameController.text);
      await projectRef.set({
        'description': projectDescriptionController.text,
        'image_url': projectImageUrlController.text,
        'programming_language': projectProgrammingLangController.text,
        'student_name': projectStudentNameController.text,
        'project_type': projectTypeController.text, // Added field
      });
      setState(() {
        _message = "Graduation project added successfully!";
      });
      clearFields();
    }
  }

  // Add Internship Data
  Future<void> addInternship() async {
    if (_formKey.currentState!.validate()) {
      final internshipRef = FirebaseFirestore.instance
          .collection('internships')
          .doc(internshipCompanyNameController.text);
      await internshipRef.set({
        'Email': internshipEmailController.text,
        'city': internshipCityController.text,
        'company_name': internshipCompanyNameController.text,
        'contact_number': internshipContactController.text,
        'description': internshipDescriptionController.text,
        'image_url': internshipImageUrlController.text,
        'location': internshipLocationController.text,
      });
      setState(() {
        _message = "Internship added successfully!";
      });
      clearFields();
    }
  }

  // Clear input fields
  void clearFields() {
    courseNameController.clear();
    lectureController.clear();
    oldExamController.clear();
    summaryController.clear();
    projectNameController.clear();
    projectDescriptionController.clear();
    projectImageUrlController.clear();
    projectProgrammingLangController.clear();
    projectStudentNameController.clear();
    projectTypeController.clear(); // Added field
    internshipCompanyNameController.clear();
    internshipEmailController.clear();
    internshipCityController.clear();
    internshipContactController.clear();
    internshipDescriptionController.clear();
    internshipImageUrlController.clear();
    internshipLocationController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Add Course Data",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedFaculty,
                    items: const [
                      DropdownMenuItem(
                        value: 'Faculty_Of_Business',
                        child: Text("Faculty of Business"),
                      ),
                      DropdownMenuItem(
                        value: 'Faculty_Of_Computer',
                        child: Text("Faculty of Computer"),
                      ),
                      DropdownMenuItem(
                        value: 'Faculty_Of_Language',
                        child: Text("Faculty of Language"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFaculty = value!;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Select Faculty"),
                  ),
                  TextFormField(
                    controller: courseNameController,
                    decoration: const InputDecoration(labelText: "Course Name"),
                  ),
                  TextFormField(
                    controller: lectureController,
                    decoration: const InputDecoration(labelText: "Lecture"),
                  ),
                  TextFormField(
                    controller: oldExamController,
                    decoration: const InputDecoration(labelText: "Old Exam"),
                  ),
                  TextFormField(
                    controller: summaryController,
                    decoration: const InputDecoration(labelText: "Summary"),
                  ),
                  ElevatedButton(
                    onPressed: addCourse,
                    child: const Text("Add Course"),
                  ),
                  const Divider(),
                  const Text(
                    "Add Graduation Project",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: projectNameController,
                    decoration: const InputDecoration(labelText: "Project Name"),
                  ),
                  TextFormField(
                    controller: projectDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  TextFormField(
                    controller: projectImageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                  ),
                  TextFormField(
                    controller: projectProgrammingLangController,
                    decoration: const InputDecoration(labelText: "Programming Language"),
                  ),
                  TextFormField(
                    controller: projectStudentNameController,
                    decoration: const InputDecoration(labelText: "Student Name"),
                  ),
                  TextFormField(
                    controller: projectTypeController,
                    decoration: const InputDecoration(labelText: "Project Type"),
                  ),
                  ElevatedButton(
                    onPressed: addGraduationProject,
                    child: const Text("Add Graduation Project"),
                  ),
                  const Divider(),
                  const Text(
                    "Add Internship",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    controller: internshipCompanyNameController,
                    decoration: const InputDecoration(labelText: "Company Name"),
                  ),
                  TextFormField(
                    controller: internshipEmailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextFormField(
                    controller: internshipCityController,
                    decoration: const InputDecoration(labelText: "City"),
                  ),
                  TextFormField(
                    controller: internshipContactController,
                    decoration: const InputDecoration(labelText: "Contact Number"),
                  ),
                  TextFormField(
                    controller: internshipDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),
                  TextFormField(
                    controller: internshipImageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                  ),
                  TextFormField(
                    controller: internshipLocationController,
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                  ElevatedButton(
                    onPressed: addInternship,
                    child: const Text("Add Internship"),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      _message!,
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
