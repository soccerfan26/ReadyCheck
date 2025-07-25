import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/setup_service.dart';
import '../models/setup_models.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup & Configuration'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Locations'),
            Tab(text: 'Types'),
            Tab(text: 'Employers'),
            Tab(text: 'Equipment'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _LocationsTab(),
          _LocationTypesTab(),
          _EmployersTab(),
          _EquipmentTypesTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _LocationsTab extends StatelessWidget {
  const _LocationsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupService>(
      builder: (context, setupService, child) {
        return _SetupTabView<Location>(
          title: 'Locations',
          items: setupService.locations,
          onAdd: (name, description) => setupService.addLocation(name, description),
          onDelete: (id) => setupService.deleteLocation(id),
        );
      },
    );
  }
}

class _LocationTypesTab extends StatelessWidget {
  const _LocationTypesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupService>(
      builder: (context, setupService, child) {
        return _SetupTabView<LocationType>(
          title: 'Location Types',
          items: setupService.locationTypes,
          onAdd: (name, description) => setupService.addLocationType(name, description),
          onDelete: (id) => setupService.deleteLocationType(id),
        );
      },
    );
  }
}

class _EmployersTab extends StatelessWidget {
  const _EmployersTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupService>(
      builder: (context, setupService, child) {
        return _SetupTabView<Employer>(
          title: 'Employers',
          items: setupService.employers,
          onAdd: (name, description) => setupService.addEmployer(name, description),
          onDelete: (id) => setupService.deleteEmployer(id),
        );
      },
    );
  }
}

class _EquipmentTypesTab extends StatelessWidget {
  const _EquipmentTypesTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<SetupService>(
      builder: (context, setupService, child) {
        return _SetupTabView<EquipmentType>(
          title: 'Equipment Types',
          items: setupService.equipmentTypes,
          onAdd: (name, description) => setupService.addEquipmentType(name, description),
          onDelete: (id) => setupService.deleteEquipmentType(id),
        );
      },
    );
  }
}

class _SetupTabView<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Future<void> Function(String name, String description) onAdd;
  final Future<void> Function(String id) onDelete;

  const _SetupTabView({
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  State<_SetupTabView<T>> createState() => _SetupTabViewState<T>();
}

class _SetupTabViewState<T> extends State<_SetupTabView<T>> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _showAddDialog() async {
    _nameController.clear();
    _descriptionController.clear();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add ${widget.title.substring(0, widget.title.length - 1)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.trim().isNotEmpty) {
                  try {
                    await widget.onAdd(_nameController.text.trim(), _descriptionController.text.trim());
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.title.substring(0, widget.title.length - 1)} added successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding item: $e')),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(String id, String name) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$name"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await widget.onDelete(id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item deleted successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting item: $e')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (widget.items.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No items found. Tap "Add" to create your first item.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index] as dynamic;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(item.name),
                      subtitle: item.description.isNotEmpty ? Text(item.description) : null,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(item.id, item.name),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}