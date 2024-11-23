import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Uploading {
  // Pick an image file
  Future<String?> pickImageFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom, // Use custom file type to specify extensions
    allowedExtensions: ['png', 'jpg', 'jpeg'], // Restrict to image files
  );

  if (result != null && result.files.single.path != null) {
    return result.files.single.path; // Return the selected file path
  }
  return null; // Return null if no file is selected
}


  // Upload an image to Firebase Storage
  Future<String> uploadImageToStorage(String filePath, String fileName) async {
    try {
      // Get the Firebase Storage instance
      FirebaseStorage storage = FirebaseStorage.instanceFor(
          app: Firebase.app(),
          bucket: 'gs://fir-test-834c2.firebasestorage.app');
      storage.setMaxUploadRetryTime(const Duration(seconds: 30));

      // Check if the file exists
      File file = File(filePath);
      if (!await file.exists()) {
        throw Exception("File does not exist at the specified path.");
      }

      // Log file information
      print('Uploading Image File: $file');

      // Upload the image to Firebase Storage
      var uploadTask = await storage
          .ref('images/$fileName') // Save under the "images" folder
          .putFile(file);

      // Get the downloadable URL
      var downloadURL = await uploadTask.ref.getDownloadURL();
      print('Image Downloadable Link: $downloadURL');
      return downloadURL;
    } catch (e) {
      print("Error during image upload: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  // Pick a PDF file
  Future<String?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path; // Return the selected file path
    }
    return null; // Return null if no file is selected
  }

  // Upload a PDF file to Firebase Storage
  Future<String> uploadFileToStorage(String filePath, String fileName) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
          app: Firebase.app(),
          bucket: 'gs://fir-test-834c2.firebasestorage.app');
      storage.setMaxUploadRetryTime(const Duration(seconds: 30));

      File file = File(filePath);
      if (!await file.exists()) {
        throw Exception("File does not exist at the specified path.");
      }

      // Log file information
      print('Uploading File: $file');

      // Upload the file to Firebase Storage
      var uploadTask = await storage
          .ref('pdfFiles/$fileName') // Save under the "pdfFiles" folder
          .putFile(file);

      // Get the downloadable URL
      var downloadURL = await uploadTask.ref.getDownloadURL();
      print('File Downloadable Link: $downloadURL');
      return downloadURL;
    } catch (e) {
      print("Error during file upload: $e");
      throw Exception("Failed to upload file: $e");
    }
  }
}
