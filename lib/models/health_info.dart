class HealthInfo {
  final int? id;
  final String disabilityType;
  final String description;
  final String additionalNotes;

  HealthInfo({
    this.id,
    required this.disabilityType,
    required this.description,
    this.additionalNotes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'disabilityType': disabilityType,
      'description': description,
      'additionalNotes': additionalNotes,
    };
  }

  factory HealthInfo.fromMap(Map<String, dynamic> map) {
    return HealthInfo(
      id: map['id'],
      disabilityType: map['disabilityType'],
      description: map['description'],
      additionalNotes: map['additionalNotes'],
    );
  }
} 