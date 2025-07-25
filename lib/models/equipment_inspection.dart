class EquipmentInspection {
  final String id;
  final String locationId;
  final String locationTypeId;
  final String employerId;
  final String equipmentTypeId;
  final String equipmentNumber;
  final String preShiftNotes;
  final String inspectorId;
  final DateTime inspectionDate;
  final DateTime createdAt;

  EquipmentInspection({
    required this.id,
    required this.locationId,
    required this.locationTypeId,
    required this.employerId,
    required this.equipmentTypeId,
    required this.equipmentNumber,
    required this.preShiftNotes,
    required this.inspectorId,
    required this.inspectionDate,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'locationId': locationId,
      'locationTypeId': locationTypeId,
      'employerId': employerId,
      'equipmentTypeId': equipmentTypeId,
      'equipmentNumber': equipmentNumber,
      'preShiftNotes': preShiftNotes,
      'inspectorId': inspectorId,
      'inspectionDate': inspectionDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory EquipmentInspection.fromMap(Map<String, dynamic> map) {
    return EquipmentInspection(
      id: map['id'] ?? '',
      locationId: map['locationId'] ?? '',
      locationTypeId: map['locationTypeId'] ?? '',
      employerId: map['employerId'] ?? '',
      equipmentTypeId: map['equipmentTypeId'] ?? '',
      equipmentNumber: map['equipmentNumber'] ?? '',
      preShiftNotes: map['preShiftNotes'] ?? '',
      inspectorId: map['inspectorId'] ?? '',
      inspectionDate: DateTime.parse(map['inspectionDate'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  EquipmentInspection copyWith({
    String? id,
    String? locationId,
    String? locationTypeId,
    String? employerId,
    String? equipmentTypeId,
    String? equipmentNumber,
    String? preShiftNotes,
    String? inspectorId,
    DateTime? inspectionDate,
    DateTime? createdAt,
  }) {
    return EquipmentInspection(
      id: id ?? this.id,
      locationId: locationId ?? this.locationId,
      locationTypeId: locationTypeId ?? this.locationTypeId,
      employerId: employerId ?? this.employerId,
      equipmentTypeId: equipmentTypeId ?? this.equipmentTypeId,
      equipmentNumber: equipmentNumber ?? this.equipmentNumber,
      preShiftNotes: preShiftNotes ?? this.preShiftNotes,
      inspectorId: inspectorId ?? this.inspectorId,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}