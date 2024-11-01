import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToFirebase(File image) async {
    try {
      // Tasodifiy fayl nomi yaratamiz
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Rasmni yuklaymiz
      Reference ref = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(image);

      // Yuklash jarayonini kutamiz
      TaskSnapshot snapshot = await uploadTask;

      // Yuklangan rasm URL sini olamiz
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Rasm yuklangan URL
    } catch (e) {
      print("Error occurred while uploading image: $e");
      throw e; // Xatolik yuz bersa, uni qaytaramiz
    }
  }
}
