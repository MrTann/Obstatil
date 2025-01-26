import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/complaint.dart';
import 'package:logger/logger.dart';

class EmailService {
  static final EmailService instance = EmailService._init();
  static const String _targetEmail =
      'complaints@example.com'; // Hedef e-posta adresi
  static final Logger _logger = Logger();

  EmailService._init();

  Future<void> sendComplaintEmail({
    required String senderEmail,
    required String senderName,
    required Complaint complaint,
  }) async {
    try {
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
      final formattedDate = dateFormat.format(complaint.timestamp);

      final subject =
          Uri.encodeComponent('Park İhlali Şikayeti - $formattedDate');
      final body = Uri.encodeComponent('''
Şikayet Eden: $senderName
E-posta: $senderEmail
Tarih: $formattedDate
Konum: ${complaint.address}
Koordinatlar: ${complaint.latitude}, ${complaint.longitude}

${complaint.description.isNotEmpty ? 'Açıklama: ${complaint.description}\n' : ''}

Bu şikayet Obstatil uygulaması üzerinden gönderilmiştir.
''');

      // E-posta uygulamasını aç
      final url = 'mailto:$_targetEmail?subject=$subject&body=$body';
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('E-posta uygulaması açılamadı');
      }
    } catch (e) {
      _logger.e('Send email error: $e');
      rethrow;
    }
  }
}
