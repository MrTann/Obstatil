import 'dart:io';
import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  late Stream<List<Complaint>> _complaintsStream;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final email = await AuthService.instance.getStoredEmail();
    if (email != null) {
      setState(() {
        _userId = email;
        _complaintsStream = FirestoreService.instance.getUserComplaints(email);
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  Future<void> _deleteComplaint(String complaintId, String imagePath) async {
    try {
      // Firestore'dan şikayeti sil
      await FirestoreService.instance.deleteComplaint(complaintId);

      // Yerel depolamadan fotoğrafı sil
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şikayet silindi')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Şikayet silinirken bir hata oluştu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eski Şikayetlerim'),
      ),
      body: StreamBuilder<List<Complaint>>(
        stream: _complaintsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Bir hata oluştu: ${snapshot.error}'),
            );
          }

          final complaints = snapshot.data ?? [];
          if (complaints.isEmpty) {
            return const Center(
              child: Text('Henüz şikayet bulunmuyor'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.file(
                      File(complaint.imagePath),
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.broken_image,
                            size: 64,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tarih: ${_formatDate(complaint.timestamp)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text('Konum: ${complaint.address}'),
                          if (complaint.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text('Açıklama: ${complaint.description}'),
                          ],
                          const SizedBox(height: 8),
                          Text('Durum: ${complaint.status}'),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _deleteComplaint(
                                  complaint.id.toString(),
                                  complaint.imagePath,
                                ),
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                label: const Text(
                                  'Sil',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
