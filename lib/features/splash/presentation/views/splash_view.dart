import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  bool _hasNavigated = false;  // To prevent multiple navigation

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    context.read<SplashCubit>().checkLoginStatus();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isTablet = screen.width >= 600;
    final logoSize = screen.width.clamp(150.0, 350.0);
    final fontSize = isTablet ? 36.0 : 28.0;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF7043), Color(0xFFFFCC80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeIn,
            child: BlocListener<SplashCubit, SplashState>(
              listener: (context, state) async {
                if (_hasNavigated) return;

                if (state is SplashAuthenticated) {
                  _hasNavigated = true;
                  await Future.delayed(const Duration(seconds: 1));
                  if (!mounted) return;
                  Navigator.of(context).pushReplacementNamed('/dashboardHome');
                } else if (state is SplashUnauthenticated) {
                  _hasNavigated = true;
                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PetForPat',
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: const [
                        Shadow(
                          blurRadius: 10,
                          color: Colors.black45,
                          offset: Offset(3, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: logoSize),
                    child: Image.asset('assets/logo/pet.jpg', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
