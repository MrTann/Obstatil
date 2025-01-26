import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/health_form_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndHealthForm();
  }

  Future<void> _checkAuthAndHealthForm() async {
    try {
      final userId = await AuthService.instance.getCurrentUserId();

      if (userId == null) {
        if (!mounted) return;
        context.go('/login');
        return;
      }

      final hasHealthForm =
          await HealthFormService.instance.hasHealthForm(userId);

      if (!mounted) return;

      if (hasHealthForm) {
        context.go('/home');
      } else {
        context.go('/health-form');
      }
    } catch (e) {
      if (!mounted) return;
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
