import 'package:flutter/material.dart';
import 'home_screen.dart'; // HomeScreen dosyasını import ediyoruz

class HealthFormScreen extends StatefulWidget {
  @override
  _HealthFormScreenState createState() => _HealthFormScreenState();
}

class _HealthFormScreenState extends State<HealthFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _tcNo, _kanGrubu, _isim, _soyisim, _engelTuru;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Form'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // Logo
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: Image.asset(
                          'assets/images/sign.png', // Logo dosyasının doğru path'ini buraya girin
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                    // Form Alanları
                    _buildTextField(
                      label: 'İsim',
                      hint: 'Adınızı giriniz',
                      onSaved: (value) => _isim = value,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: 'Soyisim',
                      hint: 'Soyadınızı giriniz',
                      onSaved: (value) => _soyisim = value,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      label: 'TC No',
                      hint: 'TC No giriniz',
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _tcNo = value,
                    ),
                    SizedBox(height: 20),
                    _buildDropdown(
                      label: 'Kan Grubu',
                      hint: 'Kan Grubu seçiniz',
                      items: ['A-', 'A+', 'B-', 'B+', 'AB-', 'AB+', 'O-', '0+'],
                      onChanged: (value) => setState(() => _kanGrubu = value),
                    ),
                    SizedBox(height: 20),
                    _buildDropdown(
                      label: 'Disability Type',
                      hint: 'Select your disability type',
                      items: ['None', 'Physical', 'Mental', 'Visual', 'Other'],
                      onChanged: (value) => setState(() => _engelTuru = value),
                    ),
                    SizedBox(height: 40),
                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Processing Data')));
                            // HomeScreen'e yönlendirme
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()),
                            );
                          }
                        },
                        child: Text('Submit', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Üye olmadan devam et yazısı
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                // HomeScreen'e yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen()), // HomeScreen yönlendirme
                );
              },
              child: Text(
                'Üye olmadan devam et',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TextFormField widget'ı
  Widget _buildTextField({
    required String label,
    required String hint,
    required FormFieldSetter<String> onSaved,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter $label' : null,
      onSaved: onSaved,
    );
  }

  // DropdownButtonFormField widget'ı
  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }
}
