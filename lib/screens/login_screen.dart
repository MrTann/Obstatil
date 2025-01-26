import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  bool _isLoading = false;
  bool _isRegistering = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;
      context.go('/health-form');
    } catch (e) {
      _logger.e('Email Sign-In error: $e');
      if (!mounted) return;

      String errorMessage = 'Email ile giriş yapılırken bir hata oluştu';

      if (e.toString().contains('user-not-found')) {
        errorMessage =
            'Bu email adresi ile kayıtlı kullanıcı bulunamadı. Lütfen önce kayıt olun.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Hatalı şifre girdiniz. Lütfen şifrenizi kontrol edin.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage =
            'Geçersiz email adresi. Lütfen geçerli bir email adresi girin.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage =
            'Çok fazla başarısız giriş denemesi. Lütfen bir süre bekleyin.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage =
            'İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Tamam',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userDetails = await AuthService.instance.signUpWithEmail(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      _logger.d('Email Registration successful: ${userDetails.toMap()}');

      if (!mounted) return;
      context.go('/health-form');
    } catch (e) {
      _logger.e('Email Registration error: $e');
      if (!mounted) return;

      String errorMessage = 'Kayıt olurken bir hata oluştu: ${e.toString()}';
      if (e.toString().contains('email-already-in-use')) {
        errorMessage =
            'Bu email adresi zaten kullanılıyor. Lütfen giriş yapmayı deneyin.';
      } else if (e.toString().contains('weak-password')) {
        errorMessage =
            'Şifre çok zayıf. Lütfen en az 6 karakterli bir şifre seçin.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage =
            'Geçersiz email adresi. Lütfen geçerli bir email adresi girin.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage =
            'İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Tamam',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/girisanimasyon.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 48),

                // Email form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_isRegistering) ...[
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Ad Soyad',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen adınızı ve soyadınızı girin';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-posta',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen e-posta adresinizi girin';
                          }
                          if (!value.contains('@')) {
                            return 'Geçerli bir e-posta adresi girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Şifre',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Lütfen şifrenizi girin';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : (_isRegistering
                                ? _signUpWithEmail
                                : _signInWithEmail),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isRegistering ? 'Kayıt Ol' : 'Giriş Yap',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _isRegistering = !_isRegistering;
                                });
                              },
                        child: Text(
                          _isRegistering
                              ? 'Zaten hesabınız var mı? Giriş yapın'
                              : 'Hesabınız yok mu? Kayıt olun',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
