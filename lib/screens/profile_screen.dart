import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/health_form.dart';
import '../services/health_form_service.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _disabilityTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  bool _isLoading = false;
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _loadHealthInfo();
  }

  @override
  void dispose() {
    _disabilityTypeController.dispose();
    _descriptionController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadHealthInfo() async {
    setState(() => _isLoading = true);
    try {
      final userId = await AuthService.instance.getCurrentUserId();
      if (userId == null) {
        if (!mounted) return;
        context.go('/login');
        return;
      }

      final healthForm = await HealthFormService.instance.getHealthForm(userId);
      if (healthForm != null) {
        _disabilityTypeController.text = healthForm.formData['disabilityType'] ?? '';
        _descriptionController.text = healthForm.formData['description'] ?? '';
        _additionalNotesController.text = healthForm.formData['additionalNotes'] ?? '';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilgiler yüklenirken bir hata oluştu')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateHealthInfo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userId = await AuthService.instance.getCurrentUserId();
      if (userId == null) {
        if (!mounted) return;
        context.go('/login');
        return;
      }

      final healthForm = await HealthFormService.instance.getHealthForm(userId);
      if (healthForm != null) {
        final updatedForm = HealthForm(
          userId: userId,
          formData: {
            'disabilityType': _disabilityTypeController.text.trim(),
            'description': _descriptionController.text.trim(),
            'additionalNotes': _additionalNotesController.text.trim(),
          },
          createdAt: healthForm.createdAt,
        );
        await HealthFormService.instance.saveHealthForm(updatedForm);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bilgiler güncellendi')),
      );
      setState(() => _isEditing = false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bilgiler güncellenirken bir hata oluştu')),
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
        title: const Text('Profilim'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _disabilityTypeController,
                      decoration: const InputDecoration(
                        labelText: 'Engel Türü',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lütfen engel türünü girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      enabled: _isEditing,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Lütfen açıklama girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _additionalNotesController,
                      decoration: const InputDecoration(
                        labelText: 'Ek Notlar (İsteğe bağlı)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      enabled: _isEditing,
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() => _isEditing = false);
                                _loadHealthInfo();
                              },
                              child: const Text('İptal'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _updateHealthInfo,
                              child: const Text('Kaydet'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
