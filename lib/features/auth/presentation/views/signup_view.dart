import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/auth/domain/entities/user.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/widgets/custom_divider.dart';
import 'package:petforpat/features/auth/presentation/widgets/social_button.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful')));
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/1.png'), fit: BoxFit.cover),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: const Color(0x1F000000), blurRadius: 12, offset: const Offset(0, 6))],
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Center(child: Text('Create Account', style: TextStyle(fontFamily: 'Roboto', fontSize: 28))),
                          const SizedBox(height: 40),
                          _buildUsernameField(),
                          const SizedBox(height: 20),
                          _buildEmailField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 30),
                          _buildSignUpButton(state),
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
    );
  }

  Widget _buildUsernameField() => TextFormField(
    controller: _usernameController,
    decoration: InputDecoration(labelText: 'Username', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    validator: (v) => v == null || v.isEmpty ? 'Enter username' : null,
  );

  Widget _buildEmailField() => TextFormField(
    controller: _emailController,
    decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
    validator: (v) {
      if (v == null || v.isEmpty) return 'Enter email';
      final emailRegex = RegExp(r'^[\w-\.]+@[\w-]+\.[\w-]{2,4}$');
      return emailRegex.hasMatch(v) ? null : 'Enter valid email';
    },
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: !_passwordVisible,
    decoration: InputDecoration(
      labelText: 'Password',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      suffixIcon: IconButton(
        icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
      ),
    ),
    validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
  );

  Widget _buildSignUpButton(AuthState state) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: state is AuthLoading ? null : _onSignUpPressed,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue.withOpacity(0.9)),
      child: state is AuthLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up', style: TextStyle(color: Colors.white)),
    ),
  );

  Widget _buildLoginOption() => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? ', style: TextStyle(fontFamily: 'Robotoo')),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text('Login', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        )
      ],
    ),
  );

  Widget _buildSocialLoginButtons() => Column(
    children: [
      SocialButton(
        icon: Image.asset('assets/logo/fb.png', width: 28, height: 28),
        text: 'Sign up with Facebook',
        onPressed: () {/* TODO */},
      ),
      const SizedBox(height: 15),
      SocialButton(
        icon: Image.asset('assets/logo/g.png', width: 28, height: 28),
        text: 'Sign up with Google',
        onPressed: () {/* TODO */},
      ),
    ],
  );

  void _onSignUpPressed() {
    if (!_formKey.currentState!.validate()) return;
    final user = User(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    context.read<AuthBloc>().add(RegisterRequested(user));
  }
}
