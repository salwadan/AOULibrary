import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salwa_app/theAdmin/adminPage.dart';

class AddDataPage extends StatefulWidget {
  //The key ensures that widgets can be identified and updated correctly.
  const AddDataPage({Key? key}) : super(key: key);

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  // Separate FormKeys for each section
  //validating and managing form submissions independently.
  final _courseFormKey = GlobalKey<FormState>();
  final _projectFormKey = GlobalKey<FormState>();
  final _internshipFormKey = GlobalKey<FormState>();

  //Stores the dropdown value for the faculty.
  String selectedFaculty = 'Faculty_Of_Computer';
  // Controllers for Courses Section
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController lectureController = TextEditingController();
  final TextEditingController oldExamController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();

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

  //Stores success or error messages to display after submission.
  String? _message;

  Future<void> addSingleFieldToFirestore({
    required String field,
    required TextEditingController controller,
    required String collection,
    required String docId,
  }) async {
    if (controller.text.isNotEmpty) { //Ensures the input field is not empty
      final ref = FirebaseFirestore.instance
          .collection('courses')
          .doc(selectedFaculty)
          .collection(collection)
          .doc(docId);

      await ref.set({
        //Adds the input value to the array in Firestore 
        field: FieldValue.arrayUnion([controller.text]),
      }, SetOptions(merge: true)); // Ensures existing data in the document isn't overwritten

      setState(() {
        _message = "$field added successfully!";
      });

      controller.clear();
    } else {
      setState(() {
        _message = "Field cannot be empty!";
      });
    }
  }


  // Add Course Data
  Future<void> addCourse() async {
    if (_courseFormKey.currentState!.validate()) { // Ensures all required fields are filled
      final ref = FirebaseFirestore.instance
          .collection('courses')
          .doc(selectedFaculty)
          .collection('course_name')
          .doc(courseNameController.text);

      await ref.set({
        'overview': overviewController.text,
      }, SetOptions(merge: true));

      setState(() {
        _message = "Course added successfully!";
      });

      clearCourseFields();
    }
  }

  // Add Graduation Project Data
  Future<void> addGraduationProject() async {
    if (_projectFormKey.currentState!.validate()) { //validate the form
      final projectRef = FirebaseFirestore.instance
          .collection('graduation_projects') //accessing graduation_projects collection
          .doc(projectNameController.text);
      await projectRef.set({
        'description': projectDescriptionController.text,
        'image_url': projectImageUrlController.text,
        'programming_language': projectProgrammingLangController.text,
        'student_name': projectStudentNameController.text,
        'project_type': projectTypeController.text,
      });
      setState(() {
        _message = "Graduation project added successfully!";
      });
      clearProjectFields();
    }
  }

  // Add Internship Data
  Future<void> addInternship() async {
    if (_internshipFormKey.currentState!.validate()) {
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
      clearInternshipFields();
    }
  }

  // Clear fields for each section
  void clearCourseFields() {
    courseNameController.clear();
    lectureController.clear();
    oldExamController.clear();
    summaryController.clear();
    overviewController.clear();
  }

  void clearProjectFields() {
    projectNameController.clear();
    projectDescriptionController.clear();
    projectImageUrlController.clear();
    projectProgrammingLangController.clear();
    projectStudentNameController.clear();
    projectTypeController.clear();
  }

  void clearInternshipFields() {
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
              key: _courseFormKey,
              child: Column(
                children: [
                  // drop list for choosing faculty
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
                    decoration:
                        const InputDecoration(labelText: "Select Faculty"),
                  ),
                  TextFormField(
                    controller: courseNameController,
                    decoration: const InputDecoration(labelText: "Course Name"),
                    validator: (value) =>
                        value!.isEmpty ? 'Course Name is required' : null,
                  ),
                  TextFormField(
                    controller: overviewController,
                    decoration: const InputDecoration(labelText: "Overview"),
                    validator: (value) =>
                        value!.isEmpty ? 'overview is required' : null,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: lectureController,
                          decoration: const InputDecoration(labelText: "Lecture"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addSingleFieldToFirestore(
                            field: 'lecture', // Field name in Firestore
                            controller: lectureController, // Controller for user input
                            collection: 'course_name', // Firestore collection name
                            docId: courseNameController.text, // Document ID (Course Name)
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: oldExamController,
                          decoration: const InputDecoration(labelText: "Old Exam"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addSingleFieldToFirestore(
                            field: 'old_exam',
                            controller: oldExamController,
                            collection: 'course_name',
                            docId: courseNameController.text,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: summaryController,
                          decoration: const InputDecoration(labelText: "Summary"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          addSingleFieldToFirestore(
                            field: 'summary',
                            controller: summaryController,
                            collection: 'course_name',
                            docId: courseNameController.text,
                          );
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: addCourse,
                    child: const Text("Add Course"),
                  ),
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _message!,
                        style: const TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(),
            const Text(
              "Add Graduation Project",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _projectFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: projectNameController,
                    decoration: const InputDecoration(labelText: "Project Name"),
                    validator: (value) =>
                        value!.isEmpty ? 'Project Name is required' : null,
                  ),
                  TextFormField(
                    controller: projectDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) =>
                        value!.isEmpty ? 'Description is required' : null,
                  ),
                  TextFormField(
                    controller: projectImageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                    validator: (value) =>
                        value!.isEmpty ? 'Image url is required' : null,
                  ),
                  TextFormField(
                    controller: projectProgrammingLangController,
                    decoration: const InputDecoration(
                        labelText: "Programming Language"),
                        validator: (value) =>
                        value!.isEmpty ? 'programming language is required' : null,
                  ),
                  TextFormField(
                    controller: projectStudentNameController,
                    decoration:
                        const InputDecoration(labelText: "Student Name"),
                        validator: (value) =>
                        value!.isEmpty ? 'Student name is required' : null,
                  ),
                  TextFormField(
                    controller: projectTypeController,
                    decoration:
                        const InputDecoration(labelText: "Project Type"),
                        validator: (value) =>
                        value!.isEmpty ? 'Project type is required' : null,
                  ),
                  ElevatedButton(
                    onPressed: addGraduationProject,
                    child: const Text("Add Graduation Project"),
                  ),
                ],
              ),
            ),
            const Divider(),
            const Text(
              "Add Internship",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Form(
              key: _internshipFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: internshipCompanyNameController,
                    decoration:
                        const InputDecoration(labelText: "Company Name"),
                        validator: (value) =>
                        value!.isEmpty ? 'Company name is required' : null,
                  ),
                  TextFormField(
                    controller: internshipEmailController,
                    decoration: const InputDecoration(labelText: "Email"),
                    validator: (value) =>
                        value!.isEmpty ? 'Email is required' : null,
                  ),
                  TextFormField(
                    controller: internshipCityController,
                    decoration: const InputDecoration(labelText: "City"),
                    validator: (value) =>
                        value!.isEmpty ? 'City is required' : null,
                  ),
                  TextFormField(
                    controller: internshipContactController,
                    decoration:
                        const InputDecoration(labelText: "Contact Number"),
                        validator: (value) =>
                        value!.isEmpty ? 'Contact number is required' : null,
                  ),
                  TextFormField(
                    controller: internshipDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (value) =>
                        value!.isEmpty ? 'Description is required' : null,
                  ),
                  TextFormField(
                    controller: internshipImageUrlController,
                    decoration: const InputDecoration(labelText: "Image URL"),
                    validator: (value) =>
                        value!.isEmpty ? 'Image url is required' : null,
                  ),
                  TextFormField(
                    controller: internshipLocationController,
                    decoration: const InputDecoration(labelText: "Location"),
                    validator: (value) =>
                        value!.isEmpty ? 'Location is required' : null,
                  ),
                  ElevatedButton(
                    onPressed: addInternship,
                    child: const Text("Add Internship"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
