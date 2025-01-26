class HealthForm {
  final String userId;
  final Map<String, dynamic> formData;
  final DateTime createdAt;

  HealthForm({
    required this.userId,
    required this.formData,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'formData': formData,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HealthForm.fromMap(Map<String, dynamic> map) {
    return HealthForm(
      userId: map['userId'] as String? ?? '',
      formData: (map['formData'] as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {},
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt'] as String) : DateTime.now(),
    );
  }
}
