import 'package:flutter/material.dart';
import '../dashboard_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF0), // matches splash/login bg
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                _buildUsernameField(),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 20),
                _buildConfirmPasswordField(),
                const SizedBox(height: 40),
                _buildSignupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter username' : null,
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter email';
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) return 'Enter valid email';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter password' : null,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_confirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () =>
              setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Confirm your password';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSignup,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _handleSignup() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Here you can add your signup logic, e.g., API call

    // For now, navigate to dashboard directly
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardView()),
    );
  }
}
