import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/equipment_service.dart';
import '../services/setup_service.dart';
import '../services/user_service.dart';
import '../models/setup_models.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _equipmentNumberController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedLocationId;
  String? _selectedLocationTypeId;
  String? _selectedEmployerId;
  String? _selectedEquipmentTypeId;
  bool _isLoading = false;

  Future<void> _createInspection() async {
    if (!_formKey.currentState!.validate()) return;

    final userService = Provider.of<UserService>(context, listen: false);
    if (userService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please create a user profile first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final equipmentService = Provider.of<EquipmentService>(context, listen: false);
      
      await equipmentService.createNewInspection(
        locationId: _selectedLocationId!,
        locationTypeId: _selectedLocationTypeId!,
        employerId: _selectedEmployerId!,
        equipmentTypeId: _selectedEquipmentTypeId!,
        equipmentNumber: _equipmentNumberController.text.trim(),
        preShiftNotes: _notesController.text.trim(),
        inspectorId: userService.currentUser!.id,
      );

      // Clear form
      _equipmentNumberController.clear();
      _notesController.clear();
      setState(() {
        _selectedLocationId = null;
        _selectedLocationTypeId = null;
        _selectedEmployerId = null;
        _selectedEquipmentTypeId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inspection created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating inspection: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Inspection'),
      ),
      body: Consumer<SetupService>(
        builder: (context, setupService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Location Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedLocationId,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              border: OutlineInputBorder(),
                            ),
                            items: setupService.locations.map((Location location) {
                              return DropdownMenuItem<String>(
                                value: location.id,
                                child: Text(location.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedLocationId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a location';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Location Type Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedLocationTypeId,
                            decoration: const InputDecoration(
                              labelText: 'Location Type',
                              border: OutlineInputBorder(),
                            ),
                            items: setupService.locationTypes.map((LocationType locationType) {
                              return DropdownMenuItem<String>(
                                value: locationType.id,
                                child: Text(locationType.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedLocationTypeId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a location type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Employer Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedEmployerId,
                            decoration: const InputDecoration(
                              labelText: 'Employer',
                              border: OutlineInputBorder(),
                            ),
                            items: setupService.employers.map((Employer employer) {
                              return DropdownMenuItem<String>(
                                value: employer.id,
                                child: Text(employer.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedEmployerId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an employer';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Equipment Type Dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedEquipmentTypeId,
                            decoration: const InputDecoration(
                              labelText: 'Equipment Type',
                              border: OutlineInputBorder(),
                            ),
                            items: setupService.equipmentTypes.map((EquipmentType equipmentType) {
                              return DropdownMenuItem<String>(
                                value: equipmentType.id,
                                child: Text(equipmentType.name),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedEquipmentTypeId = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select an equipment type';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Equipment Number
                          TextFormField(
                            controller: _equipmentNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Equipment Number',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Equipment number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Pre-Shift Inspection Notes
                          TextFormField(
                            controller: _notesController,
                            decoration: const InputDecoration(
                              labelText: 'Pre-Shift Inspection Notes',
                              border: OutlineInputBorder(),
                              alignLabelWithHint: true,
                            ),
                            maxLines: 4,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Inspection notes are required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createInspection,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Create Inspection'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _equipmentNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}