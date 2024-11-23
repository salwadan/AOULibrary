import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:salwa_app/theAdmin/additionField.dart';
import 'dart:io';
import 'package:salwa_app/theAdmin/adminPage.dart';
import 'package:salwa_app/theAdmin/uploading.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({Key? key}) : super(key: key);

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> oldExamFilePaths = []; // List to store multiple file paths
  List<String> summaryFilePaths = []; // List to store multiple summary file paths
  final Uploading uploader = Uploading(); // Instance of the Uploading class to handle file uploads.
  final AdditionField additionField = AdditionField(); // Initialize the helper class

  // ***Controllers for Courses Section***
  String selectedFaculty = 'Faculty_Of_Computer';
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController lectureController = TextEditingController();
  final TextEditingController oldExamController = TextEditingController();
  final TextEditingController summaryController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();

  // ***Controllers for Graduation Projects Section***
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController projectDescriptionController = TextEditingController();
  final TextEditingController projectImageUrlController = TextEditingController();
  final TextEditingController projectProgrammingLangController = TextEditingController();
  final TextEditingController projectStudentNameController = TextEditingController();
  final TextEditingController projectTypeController = TextEditingController();

  // ***Controllers for Internships Section***
  final TextEditingController internshipCompanyNameController = TextEditingController();
  final TextEditingController internshipEmailController = TextEditingController();
  final TextEditingController internshipCityController = TextEditingController();
  final TextEditingController internshipContactController = TextEditingController();
  final TextEditingController internshipDescriptionController = TextEditingController();
  final TextEditingController internshipImageUrlController = TextEditingController();
  final TextEditingController internshipLocationController = TextEditingController();

  // Variables to temporarily hold file paths
  String? oldExamFilePath;
  String? summaryFilePath;
  // Variables to store the file path for the images
  String? imageFileP;//for project
  String? imageFileI;//for internship
  // String to store status messages or error messages
  String? _message;

  // Add Course Data
  Future<void> addCourse() async {
    // Validate the form inputs
    if (_formKey.currentState!.validate()) {
      try {
        // Firestore Reference
        final courseRef = FirebaseFirestore.instance
            .collection('courses')
            .doc(selectedFaculty)
            .collection('course_name')
            .doc(courseNameController.text);

        // *** Upload and append Old Exam PDFs ***
        List<String> oldExamUrls = [];
        for (String filePath in oldExamFilePaths) {
          String fileName =
              '${courseNameController.text}_old_exam_${oldExamFilePaths.indexOf(filePath) + 1}.pdf';
          // Upload the file to Firebase Storage and retrieve the URL
          String uploadedUrl =
              await uploader.uploadFileToStorage(filePath, fileName);
          oldExamUrls.add(uploadedUrl);
        }
        // Save Old Exam URLs to Firestore if the list is not empty
        if (oldExamUrls.isNotEmpty) {
          await courseRef.set({
            'old_exam': FieldValue.arrayUnion(oldExamUrls),
          }, SetOptions(merge: true));
        }

        // *** Upload and append Summary PDFs ***
        List<String> summaryUrls = [];
        for (String filePath in summaryFilePaths) {
          String fileName =
              '${courseNameController.text}_summary_${summaryFilePaths.indexOf(filePath) + 1}.pdf';
          String uploadedUrl =
              await uploader.uploadFileToStorage(filePath, fileName);
          summaryUrls.add(uploadedUrl);
        }
        // Save Summary URLs to Firestore if the list is not empty
        if (summaryUrls.isNotEmpty) {
          await courseRef.set({
            'summary': FieldValue.arrayUnion(summaryUrls),
          }, SetOptions(merge: true));
        }

        // ***Append lecture to Firestore array***
        if (lectureController.text.isNotEmpty) {
          // Add the lecture content to the Firestore 'lecture' array field
          await courseRef.set({
            'lecture': FieldValue.arrayUnion([lectureController.text]),
          }, SetOptions(merge: true));
        }

        // Add overview if not empty
        if (overviewController.text.isNotEmpty) {
          // Add the overview text to the Firestore document
          await courseRef.set({
            'overview': overviewController.text,
          }, SetOptions(merge: true));
        }

        // Success message
        setState(() {
          _message = "Course added successfully!";
        });

        // Clear input fields
        clearFields();
      } catch (e) {
        // Handle errors
        setState(() {
          _message = "Error adding course: $e";
        });
      }
    }
  }

  // Add Graduation Project Data
  Future<void> addGraduationProject() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Variable to store the URL of the uploaded image
        String? imageUrl;

        // Upload the image if it has been selected
        if (imageFileP != null) {
          // Upload the selected image to Firebase Storage and retrieve the URL
          imageUrl = await uploader.uploadImageToStorage(
            imageFileP!,
            '${projectNameController.text}_project_image.png',
          );
          projectImageUrlController.text =
              imageUrl; // Save the image URL in the controller
        }

        // Reference to the Firestore collection
        final projectRef = FirebaseFirestore.instance
            .collection('graduation_projects')
            .doc(projectNameController.text);

        // Save data to Firestore
        await projectRef.set({
          'description': projectDescriptionController.text,
          'image_url': projectImageUrlController.text, 
          'programming_language': projectProgrammingLangController.text,
          'student_name': projectStudentNameController.text,
          'project_type': projectTypeController.text,
          'project_name': projectNameController,
        });

        setState(() {
          _message = "Graduation project added successfully!";
        });

        clearFields(); // Clear the input fields
      } catch (e) {
        setState(() {
          _message = "Error adding graduation project: $e";
        });
      }
    }
  }

  // Add Internship Data
  Future<void> addInternship() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;

        // Upload the image if it has been selected
        if (imageFileI != null) {
          imageUrl = await uploader.uploadImageToStorage(
            imageFileI!,
            '${internshipCompanyNameController.text}_internship_image.png',
          );
          internshipImageUrlController.text =
              imageUrl; // Save the image URL in the controller
        }

        // Reference to the Firestore collection
        final internshipRef = FirebaseFirestore.instance
            .collection('internships')
            .doc(internshipCompanyNameController.text);

        // Save data to Firestore
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

        clearFields(); // Clear the input fields
      } catch (e) {
        setState(() {
          _message = "Error adding internship: $e";
        });
      }
    }
  }

  // Clear input fields
  void clearFields() {
    courseNameController.clear();
    lectureController.clear();
    oldExamController.clear();
    summaryController.clear();
    overviewController.clear();
    oldExamFilePath = null;
    summaryFilePath = null;
    projectNameController.clear();
    projectDescriptionController.clear();
    projectImageUrlController.clear();
    projectProgrammingLangController.clear();
    projectStudentNameController.clear();
    projectTypeController.clear();
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
                    decoration:
                        const InputDecoration(labelText: "Select Faculty"),
                  ),
                  TextFormField(
                    controller: courseNameController,
                    decoration: const InputDecoration(labelText: "Course Name"),
                  ),
                  TextFormField(
                    controller: overviewController,
                    decoration: const InputDecoration(labelText: "Overview"),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: lectureController,
                          decoration: const InputDecoration(
                              labelText: "Recorded lecture"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),// Add icon with green color
                        onPressed: () async {
                          try {
                            // Use AdditionField to add the lecture
                            await additionField.addSingleField(
                              field: 'lecture', // Firestore field name where the data will be stored
                              value: lectureController.text, // The lecture input value to add
                              collection: 'course_name', // Subcollection where the course data is stored
                              docId: courseNameController.text, // Document ID for the specific course
                              selectedFaculty: selectedFaculty, // Include the faculty context
                            );
                            setState(() {
                              _message = "Lecture added successfully!";
                            });
                            lectureController
                                .clear(); // Clear the input after adding
                          } catch (e) {
                            setState(() {
                              _message = e.toString(); // Display error if any
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Open file picker to select a PDF file
                          final filePath = await uploader.pickPdfFile(); // Pick a new file
                          if (filePath != null) {
                            setState(() {
                              oldExamFilePaths.add(filePath); // Add the file to the list
                            });
                            print('------ File picked with path= $filePath');
                          }
                        },
                        child: const Text("Select Old Exam PDF"),
                      ),
                      const SizedBox(height: 10),
                      if (oldExamFilePaths.isNotEmpty) ...[
                        // Display a heading if there are selected files
                        const Text("Selected Files:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: oldExamFilePaths.length,
                          itemBuilder: (context, index) {
                            final fileName =
                                oldExamFilePaths[index].split('/').last;
                            return ListTile(
                              title: Text(fileName),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    oldExamFilePaths.removeAt(
                                        index); // Remove the file from the list
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final filePath =
                              await uploader.pickPdfFile(); // Pick a new file
                          if (filePath != null) {
                            setState(() {
                              summaryFilePaths
                                  .add(filePath); // Add the file to the list
                            });
                            print('------ File picked with path= $filePath');
                          }
                        },
                        child: const Text("Select Summary PDF"),
                      ),
                      const SizedBox(height: 10),
                      if (summaryFilePaths.isNotEmpty) ...[
                        const Text("Selected Summary Files:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: summaryFilePaths.length,
                          itemBuilder: (context, index) {
                            final fileName =
                                summaryFilePaths[index].split('/').last;
                            return ListTile(
                              title: Text(fileName),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    summaryFilePaths.removeAt(
                                        index); // Remove the file from the list
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                    ),
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
                    decoration:
                        const InputDecoration(labelText: "Project Name"),
                  ),
                  TextFormField(
                    controller: projectDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),

                  TextFormField(
                    controller: projectProgrammingLangController,
                    decoration: const InputDecoration(
                        labelText: "Programming Language"),
                  ),
                  TextFormField(
                    controller: projectStudentNameController,
                    decoration:
                        const InputDecoration(labelText: "Student Name"),
                  ),
                  TextFormField(
                    controller: projectTypeController,
                    decoration:
                        const InputDecoration(labelText: "Project Type"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      imageFileP = await uploader
                          .pickImageFile(); // Using the `pickImageFile` method from the `uploading` class
                      setState(
                          () {}); // Refresh the UI to display the selected image
                    },
                    child: const Text("Select Image"), // Button text
                  ),
                  if (imageFileP != null)
                    Text(
                        "Selected: ${imageFileP!.split('/').last}"), // Display the name of the selected image file
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                    ),
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
                    decoration:
                        const InputDecoration(labelText: "Company Name"),
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
                    decoration:
                        const InputDecoration(labelText: "Contact Number"),
                  ),
                  TextFormField(
                    controller: internshipDescriptionController,
                    decoration: const InputDecoration(labelText: "Description"),
                  ),

                  TextFormField(
                    controller: internshipLocationController,
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      imageFileI = await uploader
                          .pickImageFile(); // Using the `pickImageFile` method from the `uploading` class
                      setState(
                          () {}); // Refresh the UI to display the selected image
                    },
                    child: const Text("Select Image"), // Button text
                  ),
                  if (imageFileI != null)
                    Text(
                        "Selected: ${imageFileI!.split('/').last}"), // Display the name of the selected image file
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Set the background color
                      foregroundColor: Colors.white, // Set the text color
                    ),
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
