import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/setup_models.dart';

class SetupService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<Location> _locations = [];
  List<LocationType> _locationTypes = [];
  List<Employer> _employers = [];
  List<EquipmentType> _equipmentTypes = [];

  List<Location> get locations => _locations;
  List<LocationType> get locationTypes => _locationTypes;
  List<Employer> get employers => _employers;
  List<EquipmentType> get equipmentTypes => _equipmentTypes;

  Future<void> loadAllData() async {
    await Future.wait([
      loadLocations(),
      loadLocationTypes(),
      loadEmployers(),
      loadEquipmentTypes(),
    ]);
  }

  // Locations
  Future<void> loadLocations() async {
    try {
      final snapshot = await _firestore.collection('locations').get();
      _locations = snapshot.docs
          .map((doc) => Location.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading locations: $e');
    }
  }

  Future<void> addLocation(String name, String description) async {
    try {
      final location = Location(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('locations').doc(location.id).set(location.toMap());
      _locations.add(location);
      notifyListeners();
    } catch (e) {
      print('Error adding location: $e');
      throw e;
    }
  }

  Future<void> deleteLocation(String id) async {
    try {
      await _firestore.collection('locations').doc(id).delete();
      _locations.removeWhere((location) => location.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting location: $e');
      throw e;
    }
  }

  // Location Types
  Future<void> loadLocationTypes() async {
    try {
      final snapshot = await _firestore.collection('locationTypes').get();
      _locationTypes = snapshot.docs
          .map((doc) => LocationType.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading location types: $e');
    }
  }

  Future<void> addLocationType(String name, String description) async {
    try {
      final locationType = LocationType(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('locationTypes').doc(locationType.id).set(locationType.toMap());
      _locationTypes.add(locationType);
      notifyListeners();
    } catch (e) {
      print('Error adding location type: $e');
      throw e;
    }
  }

  Future<void> deleteLocationType(String id) async {
    try {
      await _firestore.collection('locationTypes').doc(id).delete();
      _locationTypes.removeWhere((locationType) => locationType.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting location type: $e');
      throw e;
    }
  }

  // Employers
  Future<void> loadEmployers() async {
    try {
      final snapshot = await _firestore.collection('employers').get();
      _employers = snapshot.docs
          .map((doc) => Employer.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading employers: $e');
    }
  }

  Future<void> addEmployer(String name, String description) async {
    try {
      final employer = Employer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('employers').doc(employer.id).set(employer.toMap());
      _employers.add(employer);
      notifyListeners();
    } catch (e) {
      print('Error adding employer: $e');
      throw e;
    }
  }

  Future<void> deleteEmployer(String id) async {
    try {
      await _firestore.collection('employers').doc(id).delete();
      _employers.removeWhere((employer) => employer.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting employer: $e');
      throw e;
    }
  }

  // Equipment Types
  Future<void> loadEquipmentTypes() async {
    try {
      final snapshot = await _firestore.collection('equipmentTypes').get();
      _equipmentTypes = snapshot.docs
          .map((doc) => EquipmentType.fromMap(doc.data()))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error loading equipment types: $e');
    }
  }

  Future<void> addEquipmentType(String name, String description) async {
    try {
      final equipmentType = EquipmentType(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      
      await _firestore.collection('equipmentTypes').doc(equipmentType.id).set(equipmentType.toMap());
      _equipmentTypes.add(equipmentType);
      notifyListeners();
    } catch (e) {
      print('Error adding equipment type: $e');
      throw e;
    }
  }

  Future<void> deleteEquipmentType(String id) async {
    try {
      await _firestore.collection('equipmentTypes').doc(id).delete();
      _equipmentTypes.removeWhere((equipmentType) => equipmentType.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting equipment type: $e');
      throw e;
    }
  }

  // Initialize with sample data
  Future<void> initializeSampleData() async {
    if (_locations.isEmpty) {
      await addLocation('Main Office', 'Primary office location');
      await addLocation('Warehouse A', 'Main storage facility');
      await addLocation('Field Site 1', 'Remote field location');
    }

    if (_locationTypes.isEmpty) {
      await addLocationType('Office', 'Office building');
      await addLocationType('Warehouse', 'Storage facility');
      await addLocationType('Field', 'Outdoor work site');
    }

    if (_employers.isEmpty) {
      await addEmployer('Company A', 'Primary contractor');
      await addEmployer('Company B', 'Secondary contractor');
      await addEmployer('Internal', 'Internal company operations');
    }

    if (_equipmentTypes.isEmpty) {
      await addEquipmentType('Forklift', 'Material handling equipment');
      await addEquipmentType('Crane', 'Heavy lifting equipment');
      await addEquipmentType('Generator', 'Power generation equipment');
      await addEquipmentType('Vehicle', 'Transportation equipment');
    }
  }
}