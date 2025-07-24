import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is AuthProfileUpdated) {
      _initializeControllers(state.user);
    } else {
      // You might want to load user from repository/local here if needed
    }
  }

  void _initializeControllers(UserEntity user) {
    usernameController = TextEditingController(text: user.username);
    firstNameController = TextEditingController(text: user.firstName);
    lastNameController = TextEditingController(text: user.lastName);
    phoneController = TextEditingController(text: user.phoneNumber);
    addressController = TextEditingController(text: user.address);
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = File(picked.path);
      });
    }
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
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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

            if (usernameController.text.isEmpty) {
              _initializeControllers(user);
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : (user.profileImage != null
                          ? NetworkImage(user.profileImage!)
                          : const AssetImage('assets/images/default_profile.png')) as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.edit, size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Username', usernameController),
                  _buildTextField('First Name', firstNameController),
                  _buildTextField('Last Name', lastNameController),
                  _buildTextField('Phone Number', phoneController),
                  _buildTextField('Address', addressController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text("Loading profile..."));
        },
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
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
    super.dispose();
  }
}
