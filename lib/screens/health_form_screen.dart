import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/health_form.dart';
import '../services/health_form_service.dart';
import '../services/auth_service.dart';

class HealthFormScreen extends StatefulWidget {
  const HealthFormScreen({super.key});

  @override
  State<HealthFormScreen> createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _disabilityTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;
  HealthForm? _existingForm;

  @override
  void initState() {
    super.initState();
    _loadExistingHealthForm();
  }

  @override
  void dispose() {
    _disabilityTypeController.dispose();
    _descriptionController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingHealthForm() async {
    setState(() => _isLoading = true);
    try {
      final userId = await AuthService.instance.getCurrentUserId();
      if (userId == null) {
        if (!mounted) return;
        context.go('/login');
        return;
      }

      final form = await HealthFormService.instance.getHealthForm(userId);
      if (form != null && mounted) {
        setState(() {
          _existingForm = form;
          _disabilityTypeController.text = form.formData['disabilityType'] ?? '';
          _descriptionController.text = form.formData['description'] ?? '';
          _additionalNotesController.text = form.formData['additionalNotes'] ?? '';
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sağlık bilgileri yüklenirken bir hata oluştu')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveHealthForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userId = await AuthService.instance.getCurrentUserId();
      if (userId == null) {
        if (!mounted) return;
        context.go('/login');
        return;
      }

      final form = HealthForm(
        userId: userId,
        formData: {
          'disabilityType': _disabilityTypeController.text.trim(),
          'description': _descriptionController.text.trim(),
          'additionalNotes': _additionalNotesController.text.trim(),
        },
        createdAt: DateTime.now(),
      );

      final success = await HealthFormService.instance.saveHealthForm(form);

      if (!mounted) return;

      if (success) {
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form kaydedilirken bir hata oluştu')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bir hata oluştu')),
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
        title: Text(_existingForm == null ? 'Sağlık Bilgi Formu' : 'Sağlık Bilgileriniz'),
        automaticallyImplyLeading: false,
        actions: [
          if (_existingForm != null && !_isEditing)
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
                        labelText: 'Engellilik Türü',
                        border: OutlineInputBorder(),
                      ),
                      enabled: _existingForm == null || _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen engellilik türünü giriniz';
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
                      enabled: _existingForm == null || _isEditing,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen açıklama giriniz';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _additionalNotesController,
                      decoration: const InputDecoration(
                        labelText: 'Ek Notlar',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      enabled: _existingForm == null || _isEditing,
                    ),
                    const SizedBox(height: 24),
                    if (_existingForm == null || _isEditing)
                      ElevatedButton(
                        onPressed: _saveHealthForm,
                        child: Text(_existingForm == null ? 'Kaydet' : 'Güncelle'),
                      ),
                    if (_existingForm != null && _isEditing)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TextButton(
                          onPressed: () => setState(() => _isEditing = false),
                          child: const Text('İptal'),
                        ),
                      ),
                    if (_existingForm != null && !_isEditing)
                      ElevatedButton(
                        onPressed: () => context.go('/home'),
                        child: const Text('Ana Sayfaya Dön'),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
