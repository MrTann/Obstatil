import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/camera_service.dart';
import '../services/location_service.dart';
import '../services/email_service.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/complaint.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'package:logger/logger.dart';
import '../widgets/bottom_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  String? _userEmail;
  String? _userName;
  final _logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      _userEmail = await AuthService.instance.getStoredEmail();
      _userName = await AuthService.instance.getStoredName();
      if (_userEmail == null) {
        if (!mounted) return;
        context.go('/login');
      }
    } catch (e) {
      _logger.e('Load user info error: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      await AuthService.instance.signOut();
      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Çıkış yapılırken bir hata oluştu')),
      );
    }
  }

  Future<void> _reportComplaint() async {
    if (_userEmail == null || _userName == null) {
      context.go('/login');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Kamera izni kontrolü
      final hasCameraPermission =
          await CameraService.instance.checkCameraPermission();
      if (!hasCameraPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamera izni gerekli')),
        );
        return;
      }

      // Konum izni kontrolü
      final hasLocationPermission =
          await LocationService.instance.checkLocationPermission();
      if (!hasLocationPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konum izni gerekli')),
        );
        return;
      }

      // Fotoğraf çek
      final imagePath = await CameraService.instance.takePhoto();
      if (imagePath == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotoğraf çekilemedi')),
        );
        return;
      }

      // Konum al
      final position = await LocationService.instance.getCurrentLocation();
      final address = await LocationService.instance.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Şikayeti oluştur
      final complaint = Complaint(
        imagePath: imagePath,
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        timestamp: DateTime.now(),
      );

      // Şikayeti Firestore'a kaydet
      await FirestoreService.instance.saveComplaint(
        userId: _userEmail!,
        complaint: complaint,
      );

      // E-posta gönder
      await EmailService.instance.sendComplaintEmail(
        senderEmail: _userEmail!,
        senderName: _userName!,
        complaint: complaint,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Şikayet kaydedildi ve e-posta hazırlandı')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obstatil'),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) => IconButton(
              icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () => themeProvider.toggleTheme(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.go('/profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_userName != null) ...[
              Text(
                'Hoş geldin, $_userName!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _reportComplaint,
              icon: const Icon(Icons.camera_alt),
              label: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Şikayet Et'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => context.go('/complaints'),
              icon: const Icon(Icons.history),
              label: const Text('Eski Şikayetlerim'),
            ),
          ],
        ),
      ),
    );
  }
}
