import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petforpat/features/splash/presentation/view_models/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    print('SplashScreen: initState called');

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Call the cubit check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkLoginStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateOnce(String routeName) async {
    if (_hasNavigated) {
      print('SplashScreen: already navigated, ignoring.');
      return;
    }
    _hasNavigated = true;

    print('SplashScreen: navigating to $routeName');
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(routeName);
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
              listener: (context, state) {
                print('SplashScreen: SplashCubit state changed to $state');
                if (state is SplashAuthenticated) {
                  _navigateOnce('/dashboard');
                } else if (state is SplashUnauthenticated) {
                  _navigateOnce('/login');
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
                    child: Image.asset(
                      'assets/logo/pet.jpg',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading splash image: $error');
                        return const Icon(Icons.error, size: 80, color: Colors.red);
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
