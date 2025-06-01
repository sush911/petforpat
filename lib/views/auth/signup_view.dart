import 'package:flutter/material.dart';
import 'package:petforpat/Widgets/custom_divider.dart';
import 'package:petforpat/Widgets/social_button.dart';
import 'package:petforpat/views/auth/login_view.dart';
import 'package:petforpat/theme/theme_data.dart';  // Import your theme

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = getApplicationTheme(); // Get your theme here

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xF2FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x1F000000),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                              _buildUsernameField(theme),
                              const SizedBox(height: 20),
                              _buildEmailField(theme),
                              const SizedBox(height: 20),
                              _buildPasswordField(theme),
                              const SizedBox(height: 30),
                              _buildSignUpButton(),
                              const SizedBox(height: 12),
                              _buildLoginOption(),
                              const SizedBox(height: 30),
                              const CustomDivider(text: 'Or'),
                              const SizedBox(height: 30),
                              _buildSocialLoginButtons(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField(ThemeData theme) {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Username',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 3),
        ),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? 'Enter username' : null,
    );
  }

  Widget _buildEmailField(ThemeData theme) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 3),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter email';
        }
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(ThemeData theme) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.primaryColor, width: 3),
        ),
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

  Widget _buildSignUpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSignUp,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildLoginOption() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an account? ",
            style: TextStyle(fontFamily: 'Robotoo'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return Column(
      children: [
        SocialButton(
          icon: Image.asset(
            'assets/logo/fb.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          text: 'Sign up with Facebook',
          onPressed: () {
            // Add logic
          },
        ),
        const SizedBox(height: 15),
        SocialButton(
          icon: Image.asset(
            'assets/logo/g.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          text: 'Sign up with Google',
          onPressed: () {
            // Add logic
          },
        ),
      ],
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signing up...')),
      );
      // Add sign-up API logic here
    }
  }
}
