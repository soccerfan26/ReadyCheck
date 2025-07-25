class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String location;
  final String homeLocalNumber;
  final String workId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.homeLocalNumber,
    required this.workId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'location': location,
      'homeLocalNumber': homeLocalNumber,
      'workId': workId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      location: map['location'] ?? '',
      homeLocalNumber: map['homeLocalNumber'] ?? '',
      workId: map['workId'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserProfile copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? location,
    String? homeLocalNumber,
    String? workId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      location: location ?? this.location,
      homeLocalNumber: homeLocalNumber ?? this.homeLocalNumber,
      workId: workId ?? this.workId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}