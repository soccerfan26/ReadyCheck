import 'package:flutter_test/flutter_test.dart';
import 'package:ready_check/models/user_profile.dart';
import 'package:ready_check/models/equipment_inspection.dart';
import 'package:ready_check/models/setup_models.dart';

void main() {
  group('UserProfile Tests', () {
    test('UserProfile can be created and serialized', () {
      final now = DateTime.now();
      final profile = UserProfile(
        id: 'test-id',
        firstName: 'John',
        lastName: 'Doe',
        location: 'Test Location',
        homeLocalNumber: '123',
        workId: 'WORK123',
        createdAt: now,
        updatedAt: now,
      );

      expect(profile.firstName, 'John');
      expect(profile.lastName, 'Doe');
      
      final map = profile.toMap();
      expect(map['firstName'], 'John');
      expect(map['lastName'], 'Doe');
      
      final fromMap = UserProfile.fromMap(map);
      expect(fromMap.firstName, profile.firstName);
      expect(fromMap.lastName, profile.lastName);
    });
  });

  group('EquipmentInspection Tests', () {
    test('EquipmentInspection can be created and serialized', () {
      final now = DateTime.now();
      final inspection = EquipmentInspection(
        id: 'test-inspection-id',
        locationId: 'location-1',
        locationTypeId: 'type-1',
        employerId: 'employer-1',
        equipmentTypeId: 'equipment-1',
        equipmentNumber: 'EQ001',
        preShiftNotes: 'All checks passed',
        inspectorId: 'inspector-1',
        inspectionDate: now,
        createdAt: now,
      );

      expect(inspection.equipmentNumber, 'EQ001');
      expect(inspection.preShiftNotes, 'All checks passed');
      
      final map = inspection.toMap();
      expect(map['equipmentNumber'], 'EQ001');
      
      final fromMap = EquipmentInspection.fromMap(map);
      expect(fromMap.equipmentNumber, inspection.equipmentNumber);
    });
  });

  group('Setup Models Tests', () {
    test('Location can be created and serialized', () {
      final now = DateTime.now();
      final location = Location(
        id: 'location-1',
        name: 'Main Office',
        description: 'Primary office location',
        createdAt: now,
      );

      expect(location.name, 'Main Office');
      
      final map = location.toMap();
      expect(map['name'], 'Main Office');
      
      final fromMap = Location.fromMap(map);
      expect(fromMap.name, location.name);
    });

    test('Employer can be created and serialized', () {
      final now = DateTime.now();
      final employer = Employer(
        id: 'employer-1',
        name: 'Test Company',
        description: 'A test company',
        createdAt: now,
      );

      expect(employer.name, 'Test Company');
      
      final map = employer.toMap();
      expect(map['name'], 'Test Company');
      
      final fromMap = Employer.fromMap(map);
      expect(fromMap.name, employer.name);
    });
  });
}