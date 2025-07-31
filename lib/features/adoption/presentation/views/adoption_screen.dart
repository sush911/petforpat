import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // Ensure google_fonts is in pubspec.yaml
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

  final _fullNameController = TextEditingController();
  final _citizenshipNumberController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _homeAddressController = TextEditingController();
  final _reasonController = TextEditingController();

  bool _acceptTerms = false;
  bool _infoCorrect = false;

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
    if (!_acceptTerms || !_infoCorrect) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms and confirm information is correct'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

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

      context.read<AdoptionBloc>().add(SubmitAdoptionEvent(request));
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[300]),
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      filled: true,
      fillColor: const Color(0xFF2A3A4A),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.lightBlue.shade400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2B3A), // Vibrant blue-gray background
      appBar: AppBar(
        title: Text(
          'Adopt ${widget.petName}',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF253746),
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<AdoptionBloc, AdoptionState>(
        listener: (context, state) {
          if (state is AdoptionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Adoption request submitted successfully!'),
                backgroundColor: Colors.green.shade600,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AdoptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red.shade600,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdoptionLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(_fullNameController, 'Full Name', Icons.person),
                    const SizedBox(height: 18),
                    _buildTextField(_citizenshipNumberController, 'Citizenship Number', Icons.badge),
                    const SizedBox(height: 18),
                    _buildTextField(_phoneNumberController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                    const SizedBox(height: 18),
                    _buildTextField(_emailController, 'Email', Icons.email, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 18),
                    _buildTextField(_homeAddressController, 'Home Address', Icons.home),
                    const SizedBox(height: 18),
                    _buildTextField(_reasonController, 'Reason for Adoption', Icons.info_outline, maxLines: 4),
                    const SizedBox(height: 20),

                    _buildCheckbox(
                      value: _acceptTerms,
                      onChanged: (val) {
                        setState(() {
                          _acceptTerms = val ?? false;
                        });
                      },
                      text: 'I accept the terms and conditions',
                    ),
                    _buildCheckbox(
                      value: _infoCorrect,
                      onChanged: (val) {
                        setState(() {
                          _infoCorrect = val ?? false;
                        });
                      },
                      text: 'Information is correct',
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: state is AdoptionLoading ? null : _submitAdoptionForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 5,
                          shadowColor: Colors.lightBlueAccent.withOpacity(0.4),
                        ),
                        child: Text(
                          'Submit Adoption Request',
                          style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: GoogleFonts.roboto(fontSize: 16, color: Colors.white70),
      decoration: _inputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label'.toLowerCase();
        }
        return null;
      },
    );
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Colors.lightBlue.shade600,
      checkColor: Colors.white,
      value: value,
      onChanged: onChanged,
      title: Text(
        text,
        style: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
