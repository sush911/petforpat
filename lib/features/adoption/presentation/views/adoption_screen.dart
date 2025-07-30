import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/adoption/domain/entities/adoption_request.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_bloc.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_event.dart';
import 'package:petforpat/features/adoption/presentation/view_models/adoption_state.dart';

class AdoptionScreen extends StatefulWidget {
  final String petId;
  final String petName;
  final String petType;

  const AdoptionScreen({
    Key? key,
    required this.petId,
    required this.petName,
    required this.petType,
  }) : super(key: key);

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final _fullNameController = TextEditingController();
  final _citizenshipNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _citizenshipNumberController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _homeAddressController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submitAdoptionForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = AdoptionRequest(
        petId: widget.petId,
        petName: widget.petName,
        petType: widget.petType,
        fullName: _fullNameController.text.trim(),
        citizenshipNumber: _citizenshipNumberController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        email: _emailController.text.trim(),
        homeAddress: _homeAddressController.text.trim(),
        reason: _reasonController.text.trim(),
      );

      // Dispatch the SubmitAdoptionEvent with the request
      context.read<AdoptionBloc>().add(SubmitAdoptionEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adopt ${widget.petName}'),
      ),
      body: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) {
          if (state is AdoptionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Adoption request submitted successfully!')),
            );
            Navigator.of(context).pop();
          } else if (state is AdoptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AdoptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your full name' : null,
                  ),
                  TextFormField(
                    controller: _citizenshipNumberController,
                    decoration: const InputDecoration(labelText: 'Citizenship Number'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your citizenship number' : null,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your phone number' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your email' : null,
                  ),
                  TextFormField(
                    controller: _homeAddressController,
                    decoration: const InputDecoration(labelText: 'Home Address'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter your home address' : null,
                  ),
                  TextFormField(
                    controller: _reasonController,
                    decoration: const InputDecoration(labelText: 'Reason for Adoption'),
                    maxLines: 3,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'Please explain your reason for adoption' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: state is AdoptionLoading ? null : _submitAdoptionForm,
                    child: const Text('Submit Adoption Request'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
