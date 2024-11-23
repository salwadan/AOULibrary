import 'package:cloud_firestore/cloud_firestore.dart';

class AdditionField {
  // Function to add a single field value to Firestore
  Future<void> addSingleField({
    required String field,
    required String value,
    required String collection,
    required String docId,
    required String selectedFaculty, // Include faculty context
  }) async {
    if (value.isNotEmpty) {
      try {
        final ref = FirebaseFirestore.instance
            .collection('courses')
            .doc(selectedFaculty)
            .collection(collection)
            .doc(docId);

        await ref.set({
          field: FieldValue.arrayUnion([value]), // Append value to the array
        }, SetOptions(merge: true));
      } catch (e) {
        throw Exception("Error adding $field: $e");
      }
    } else {
      throw Exception("Field cannot be empty!");
    }
  }
}
