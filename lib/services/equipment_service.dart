import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/equipment_inspection.dart';

class EquipmentService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<EquipmentInspection> _inspections = [];

  List<EquipmentInspection> get inspections => _inspections;

  Future<void> loadInspections() async {
    try {
      final snapshot = await _firestore
          .collection('inspections')
          .orderBy('inspectionDate', descending: true)
          .get();
      
      _inspections = snapshot.docs
          .map((doc) => EquipmentInspection.fromMap(doc.data()))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('Error loading inspections: $e');
    }
  }

  Future<void> createInspection(EquipmentInspection inspection) async {
    try {
      await _firestore
          .collection('inspections')
          .doc(inspection.id)
          .set(inspection.toMap());
      
      _inspections.insert(0, inspection);
      notifyListeners();
    } catch (e) {
      print('Error creating inspection: $e');
      throw e;
    }
  }

  Future<List<EquipmentInspection>> searchInspections({
    String? employerId,
    String? equipmentType,
    String? equipmentNumber,
  }) async {
    try {
      Query query = _firestore.collection('inspections');
      
      if (employerId != null && employerId.isNotEmpty) {
        query = query.where('employerId', isEqualTo: employerId);
      }
      
      if (equipmentType != null && equipmentType.isNotEmpty) {
        query = query.where('equipmentTypeId', isEqualTo: equipmentType);
      }
      
      if (equipmentNumber != null && equipmentNumber.isNotEmpty) {
        query = query.where('equipmentNumber', isEqualTo: equipmentNumber);
      }
      
      final snapshot = await query
          .orderBy('inspectionDate', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => EquipmentInspection.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error searching inspections: $e');
      return [];
    }
  }

  Future<EquipmentInspection> createNewInspection({
    required String locationId,
    required String locationTypeId,
    required String employerId,
    required String equipmentTypeId,
    required String equipmentNumber,
    required String preShiftNotes,
    required String inspectorId,
  }) async {
    final now = DateTime.now();
    final inspection = EquipmentInspection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: locationId,
      locationTypeId: locationTypeId,
      employerId: employerId,
      equipmentTypeId: equipmentTypeId,
      equipmentNumber: equipmentNumber,
      preShiftNotes: preShiftNotes,
      inspectorId: inspectorId,
      inspectionDate: now,
      createdAt: now,
    );

    await createInspection(inspection);
    return inspection;
  }
}