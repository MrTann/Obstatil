class Complaint {
  final int? id;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String address;
  final DateTime timestamp;
  final String description;
  final String status;

  Complaint({
    this.id,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.timestamp,
    this.description = '',
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
      'status': status,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id'],
      imagePath: map['imagePath'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      timestamp: DateTime.parse(map['timestamp']),
      description: map['description'],
      status: map['status'],
    );
  }
} 