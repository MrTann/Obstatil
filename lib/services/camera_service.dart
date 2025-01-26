import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:logger/logger.dart';

class CameraService {
  static final CameraService instance = CameraService._init();
  final ImagePicker _picker = ImagePicker();
  final Logger _logger = Logger();

  CameraService._init();

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.camera.request();
    return result.isGranted;
  }

  Future<String?> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (photo == null) return null;

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = 'complaint_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = path.join(appDir.path, fileName);

      await File(photo.path).copy(filePath);
      return filePath;
    } catch (e) {
      _logger.e('Error taking photo: $e');
      return null;
    }
  }

  Future<void> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      _logger.e('Error deleting photo: $e');
    }
  }
}