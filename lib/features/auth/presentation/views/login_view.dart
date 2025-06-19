import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/theme/theme_data.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/widgets/custom_divider.dart';
import 'package:petforpat/features/auth/presentation/widgets/social_button.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/dashboard/presentation/views/dashboard_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardView()),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(31), blurRadius: 12, offset: const Offset(0, 6))],
                      border: Border.all(color: Colors.grey.shade300, width: 1.5),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Center(child: Text('Welcome Back', style: TextStyle(fontFamily: 'Roboto', fontSize: 28))),
                          const SizedBox(height: 40),
                          _buildUsernameField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 30),
                          _buildLoginButton(state),
                          const SizedBox(height: 12),
                          _buildSignUpOption(),
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

  Widget _buildUsernameField() => Theme(
    data: getApplicationTheme(),
    child: TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
      validator: (v) => v == null || v.isEmpty ? 'Enter username' : null,
    ),
  );

  Widget _buildPasswordField() => Theme(
    data: getApplicationTheme(),
    child: TextFormField(
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
      validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
    ),
  );

  Widget _buildLoginButton(AuthState state) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: state is AuthLoading ? null : _onLoginPressed,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.blue.withOpacity(0.9)),
      child: state is AuthLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login', style: TextStyle(color: Colors.white, fontFamily: 'Roboto')),
    ),
  );

  Widget _buildSignUpOption() => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ", style: TextStyle(fontFamily: 'Robotoo')),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpView())),
          child: const Text('Sign Up', style: TextStyle(fontFamily: 'Robotoo', color: Colors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
        ),
      ],
    ),
  );

  Widget _buildSocialLoginButtons() => Column(
    children: [
      SocialButton(
        icon: Image.asset('assets/logo/fb.png', width: 28, height: 28),
        text: 'Sign up with Facebook',
        onPressed: () {/* TODO: */},
      ),
      const SizedBox(height: 15),
      SocialButton(
        icon: Image.asset('assets/logo/g.png', width: 28, height: 28),
        text: 'Sign up with Google',
        onPressed: () {/* TODO: */},
      ),
    ],
  );

  void _onLoginPressed() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(LoginRequested(_usernameController.text.trim(), _passwordController.text.trim()));
  }
}
