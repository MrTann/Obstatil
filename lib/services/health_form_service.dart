import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_form.dart';
import 'package:logger/logger.dart';

class HealthFormService {
  static final HealthFormService instance = HealthFormService._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  HealthFormService._init();

  Future<bool> hasHealthForm(String userId) async {
    try {
      final doc = await _firestore
          .collection('healthForms')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      return doc.docs.isNotEmpty;
    } catch (e) {
      _logger.e('Error checking health form: $e');
      return false;
    }
  }

  Future<HealthForm?> getHealthForm(String userId) async {
    try {
      final doc = await _firestore
          .collection('healthForms')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return null;

      final data = doc.docs.first.data();
      if (data == null) return null;

      // Ensure formData is properly initialized
      if (!data.containsKey('formData') || data['formData'] == null) {
        data['formData'] = {};
      }

      return HealthForm.fromMap(data);
    } catch (e) {
      _logger.e('Error getting health form: $e');
      return null;
    }
  }

  Future<bool> saveHealthForm(HealthForm form) async {
    try {
      final existingDoc = await _firestore
          .collection('healthForms')
          .where('userId', isEqualTo: form.userId)
          .limit(1)
          .get();

      if (existingDoc.docs.isNotEmpty) {
        // Update existing form
        await _firestore
            .collection('healthForms')
            .doc(existingDoc.docs.first.id)
            .update(form.toMap());
      } else {
        // Create new form
        await _firestore.collection('healthForms').add(form.toMap());
      }
      return true;
    } catch (e) {
      _logger.e('Error saving health form: $e');
      return false;
    }
  }
}
