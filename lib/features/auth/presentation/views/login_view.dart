import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/app/theme/theme_data.dart';
import 'package:petforpat/features/auth/presentation/views/signup_view.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_bloc.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_event.dart';
import 'package:petforpat/features/auth/presentation/view_models/auth_state.dart';
import 'package:petforpat/features/dashboard/presentation/views/dashboard_view.dart';
import 'package:petforpat/features/auth/presentation/widgets/custom_divider.dart';
import 'package:petforpat/features/auth/presentation/widgets/social_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _showError = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    context
        .read<AuthBloc>()
        .add(LoginRequested(username: username, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                margin:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                ),
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DashboardView()),
                      );
                    } else if (state is AuthError) {
                      setState(() {
                        _showError = true;
                      });
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          _buildUsernameField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          if (_showError)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                'Incorrect username or password',
                                style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                          state is AuthLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _buildLoginButton(),
                          const SizedBox(height: 12),
                          _buildSignUpOption(),
                          const SizedBox(height: 30),
                          const CustomDivider(text: 'or continue with'),
                          const SizedBox(height: 16),
                          SocialButton(
                            icon: Image.asset('assets/logo/g.png'),
                            text: 'Continue with Google',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Google login tapped')),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          SocialButton(
                            icon: Image.asset('assets/logo/fb.png'),
                            text: 'Continue with Facebook',
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Facebook login tapped')),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Theme(
      data: getApplicationTheme(),
      child: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: 'Username',
          border: const OutlineInputBorder(),
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Enter username' : null,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Theme(
      data: getApplicationTheme(),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_passwordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          fillColor: Colors.white.withOpacity(0.9),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () =>
                setState(() => _passwordVisible = !_passwordVisible),
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Enter password' : null,
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue.withOpacity(0.9),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(fontFamily: 'Roboto'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignupView()),
              );
            },
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontFamily: 'Roboto',
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
}

