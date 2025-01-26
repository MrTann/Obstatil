import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint.dart';
import 'package:logger/logger.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._init();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  FirestoreService._init();

  // Şikayet kaydetme
  Future<void> saveComplaint({
    required String userId,
    required Complaint complaint,
  }) async {
    try {
      await _firestore.collection('complaints').add({
        'userId': userId,
        'imagePath': complaint.imagePath,
        'latitude': complaint.latitude,
        'longitude': complaint.longitude,
        'address': complaint.address,
        'timestamp': complaint.timestamp.toIso8601String(),
        'description': complaint.description,
        'status': complaint.status,
      });
    } catch (e) {
      _logger.e('Save complaint error: $e');
      rethrow;
    }
  }

  // Kullanıcının şikayetlerini getirme
  Stream<List<Complaint>> getUserComplaints(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Complaint(
          id: int.tryParse(doc.id) ?? 0,
          imagePath: data['imagePath'],
          latitude: data['latitude'],
          longitude: data['longitude'],
          address: data['address'],
          timestamp: DateTime.parse(data['timestamp']),
          description: data['description'],
          status: data['status'],
        );
      }).toList();
    });
  }

  // Şikayet silme
  Future<void> deleteComplaint(String complaintId) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).delete();
    } catch (e) {
      _logger.e('Delete complaint error: $e');
      rethrow;
    }
  }
} 