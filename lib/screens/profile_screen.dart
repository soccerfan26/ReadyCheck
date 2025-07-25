import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _homeLocalController = TextEditingController();
  final _workIdController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userService = Provider.of<UserService>(context, listen: false);
    await userService.loadUserProfile();
    
    if (userService.currentUser != null) {
      _populateFields(userService.currentUser!);
    } else {
      _isEditing = true;
    }
  }

  void _populateFields(UserProfile user) {
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _locationController.text = user.location;
    _homeLocalController.text = user.homeLocalNumber;
    _workIdController.text = user.workId;
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userService = Provider.of<UserService>(context, listen: false);
      
      if (userService.currentUser == null) {
        // Create new user
        await userService.createNewUser(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          location: _locationController.text.trim(),
          homeLocalNumber: _homeLocalController.text.trim(),
          workId: _workIdController.text.trim(),
        );
      } else {
        // Update existing user
        await userService.updateUserProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          location: _locationController.text.trim(),
          homeLocalNumber: _homeLocalController.text.trim(),
          workId: _workIdController.text.trim(),
        );
      }

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
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
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  if (userService.currentUser != null && !_isEditing)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${userService.currentUser!.firstName} ${userService.currentUser!.lastName}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const Divider(),
                            _buildInfoRow('Location', userService.currentUser!.location),
                            _buildInfoRow('Home Local #', userService.currentUser!.homeLocalNumber),
                            _buildInfoRow('Work ID', userService.currentUser!.workId),
                          ],
                        ),
                      ),
                    ),
                  
                  if (_isEditing) ...[
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Location is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _homeLocalController,
                      decoration: const InputDecoration(
                        labelText: 'Home Local #',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Home local number is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _workIdController,
                      decoration: const InputDecoration(
                        labelText: 'Work ID/Number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Work ID is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveProfile,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Save Profile'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (userService.currentUser != null)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = false;
                                  _populateFields(userService.currentUser!);
                                });
                              },
                              child: const Text('Cancel'),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _locationController.dispose();
    _homeLocalController.dispose();
    _workIdController.dispose();
    super.dispose();
  }
}