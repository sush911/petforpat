import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:petforpat/features/auth/domain/entities/user_entity.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_event.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController usernameController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  File? _profileImage;
  bool _controllersInitialized = false;

  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    // Fetch profile
    context.read<AuthBloc>().add(FetchProfileEvent());

    // Start shake detection
    _accelSubscription = accelerometerEvents.listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      // Typical shake threshold ~15, adjust as needed
      if (acceleration > 15) {
        final now = DateTime.now();
        if (now.difference(_lastShakeTime).inMilliseconds > 1000) {
          _lastShakeTime = now;
          _logout();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("👋 Logged out via shake!")),
          );
        }
      }
    });
  }

  void _initializeControllers(UserEntity user) {
    if (!_controllersInitialized) {
      usernameController.text = user.username;
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phoneNumber;
      addressController.text = user.address;
      _controllersInitialized = true;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    final data = {
      'username': usernameController.text,
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'phoneNumber': phoneController.text,
      'address': addressController.text,
    };
    context.read<AuthBloc>().add(UpdateProfileEvent(data: data, image: _profileImage));
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current is AuthInitial,
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE6F0FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'My Profile',
            style: TextStyle(
              fontFamily: 'RobotoSemiBold',
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.black87),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            )
          ],
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthUpdatingProfile) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthProfileUpdated) {
              final user = state.user;
              _initializeControllers(user);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _showImageSourceOptions,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (user.profileImage != null
                            ? NetworkImage(user.profileImage!)
                            : const AssetImage('assets/images/default_profile.jpg'))
                        as ImageProvider,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: const Icon(Icons.edit, size: 20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField('Username', usernameController),
                    const SizedBox(height: 20),
                    _buildTextField('First Name', firstNameController),
                    const SizedBox(height: 20),
                    _buildTextField('Last Name', lastNameController),
                    const SizedBox(height: 20),
                    _buildTextField('Phone Number', phoneController),
                    const SizedBox(height: 20),
                    _buildTextField('Address', addressController),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: const Color(0xFF3B82F6),
                            ),
                            onPressed: _saveProfile,
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'RobotoSemiBold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is AuthError) {
              return Center(
                child: Text(
                  '❌ ${state.message}',
                  style: const TextStyle(fontFamily: 'RobotoSemiBold'),
                ),
              );
            }

            return const Center(
              child: Text(
                "Loading profile...",
                style: TextStyle(fontFamily: 'RobotoSemiBold'),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontFamily: 'RobotoSemiBold', fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    _accelSubscription?.cancel();
    super.dispose();
  }
}
