import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase'i başlat
    await Firebase.initializeApp(
        name: "obstatil-c5203",
        options: DefaultFirebaseOptions.currentPlatform);

    // Ekran yönünü dikey olarak sabitle
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    runApp(const App());
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');

    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Uygulama başlatılırken bir hata oluştu.\nLütfen uygulamayı yeniden başlatın.',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (e.toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    e.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
