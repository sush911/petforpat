import 'package:flutter/material.dart';
import '../dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _showError = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              _buildHeader(),
              const SizedBox(height: 40),
              _buildUsernameField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              _buildErrorMessage(),
              const SizedBox(height: 30),
              _buildLoginButton(),
              const SizedBox(height: 30),
              const CustomDivider(text: 'Or'),
              const SizedBox(height: 30),
              _buildSocialLoginButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Welcome Back',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
      validator: (value) => value == null || value.isEmpty ? 'Enter username' : null,
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
          icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
    );
  }

  Widget _buildErrorMessage() {
    if (!_showError) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        'Incorrect username or password',
        style: TextStyle(color: Colors.red.shade700),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleLogin,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text('Login', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialButton(
          icon: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF1877F2), // Facebook blue
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'f',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          text: 'Sign up with Facebook',
          onPressed: () {
            // Add your Facebook signup logic here
          },
        ),
        const SizedBox(height: 15),
        SocialButton(
          icon: const Icon(Icons.g_mobiledata, color: Colors.red),
          text: 'Sign up with Google',
          onPressed: () {
            // Add your Google signup logic here
          },
        ),
      ],
    );
  }

  void _handleLogin() {
    final isValid = _formKey.currentState?.validate() ?? true;
    if (!isValid) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == 'admin' && password == 'admin123') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardView()),
      );
    } else {
      setState(() => _showError = true);
    }
  }
}

class SocialButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final String text;
  const CustomDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
