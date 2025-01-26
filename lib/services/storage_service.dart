import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:logger/logger.dart';

class StorageService {
  static final StorageService instance = StorageService._init();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  StorageService._init();

  Future<String?> uploadFile(String filePath, String folder) async {
    try {
      final File file = File(filePath);
      final String fileName = path.basename(filePath);
      final String storagePath = '$folder/$fileName';

      final Reference ref = _storage.ref().child(storagePath);
      final UploadTask uploadTask = ref.putFile(file);

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      
      return downloadUrl;
    } catch (e) {
      _logger.e('Upload file error: $e');
      return null;
    }
  }

  Future<bool> deleteFile(String downloadUrl) async {
    try {
      final Reference ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      return true;
    } catch (e) {
      _logger.e('Delete file error: $e');
      return false;
    }
  }
} 