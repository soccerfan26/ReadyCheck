import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/equipment_service.dart';
import '../services/setup_service.dart';
import '../models/equipment_inspection.dart';
import '../models/setup_models.dart';

class LookupScreen extends StatefulWidget {
  const LookupScreen({super.key});

  @override
  State<LookupScreen> createState() => _LookupScreenState();
}

class _LookupScreenState extends State<LookupScreen> {
  final _equipmentNumberController = TextEditingController();
  
  String? _selectedEmployerId;
  String? _selectedEquipmentTypeId;
  List<EquipmentInspection> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _searchInspections() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      final equipmentService = Provider.of<EquipmentService>(context, listen: false);
      
      final results = await equipmentService.searchInspections(
        employerId: _selectedEmployerId,
        equipmentType: _selectedEquipmentTypeId,
        equipmentNumber: _equipmentNumberController.text.trim().isNotEmpty 
            ? _equipmentNumberController.text.trim() 
            : null,
      );

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching inspections: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _selectedEmployerId = null;
      _selectedEquipmentTypeId = null;
      _equipmentNumberController.clear();
      _searchResults = [];
      _hasSearched = false;
    });
  }

  String _getDisplayName(String id, List<dynamic> items) {
    try {
      final item = items.firstWhere((item) => item.id == id);
      return item.name;
    } catch (e) {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipment Lookup'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
          ),
        ],
      ),
      body: Consumer2<EquipmentService, SetupService>(
        builder: (context, equipmentService, setupService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search Form
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Search Criteria',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        
                        // Employer Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedEmployerId,
                          decoration: const InputDecoration(
                            labelText: 'Employer (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Employers'),
                            ),
                            ...setupService.employers.map((Employer employer) {
                              return DropdownMenuItem<String>(
                                value: employer.id,
                                child: Text(employer.name),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedEmployerId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Equipment Type Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedEquipmentTypeId,
                          decoration: const InputDecoration(
                            labelText: 'Equipment Type (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('All Equipment Types'),
                            ),
                            ...setupService.equipmentTypes.map((EquipmentType equipmentType) {
                              return DropdownMenuItem<String>(
                                value: equipmentType.id,
                                child: Text(equipmentType.name),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? value) {
                            setState(() {
                              _selectedEquipmentTypeId = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Equipment Number
                        TextFormField(
                          controller: _equipmentNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Equipment Number (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Search Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _searchInspections,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Search Inspections'),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Results
                Expanded(
                  child: _buildResultsSection(setupService),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsSection(SetupService setupService) {
    if (!_hasSearched) {
      return const Center(
        child: Text(
          'Enter search criteria and tap "Search Inspections" to find equipment inspection records.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'No inspections found matching the search criteria.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Found ${_searchResults.length} inspection(s)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final inspection = _searchResults[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Equipment #${inspection.equipmentNumber}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            DateFormat('MMM dd, yyyy').format(inspection.inspectionDate),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildDetailRow(
                        'Location',
                        _getDisplayName(inspection.locationId, setupService.locations),
                      ),
                      _buildDetailRow(
                        'Location Type',
                        _getDisplayName(inspection.locationTypeId, setupService.locationTypes),
                      ),
                      _buildDetailRow(
                        'Employer',
                        _getDisplayName(inspection.employerId, setupService.employers),
                      ),
                      _buildDetailRow(
                        'Equipment Type',
                        _getDisplayName(inspection.equipmentTypeId, setupService.equipmentTypes),
                      ),
                      if (inspection.preShiftNotes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Notes:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(inspection.preShiftNotes),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _equipmentNumberController.dispose();
    super.dispose();
  }
}