import 'package:flutter/material.dart';
import 'package:petforpat/views/auth/login_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      }
    });

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

    // Limit sizes to keep things proportionate
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🐾 Logo with max width constraint
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: logoSize,
                  ),
                  child: Image.asset(
                    'assets/logo/pet.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),

                // 📝 App title
                Text(
                  'Pet Adoption',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: const [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black45,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // ⏳ Spinner
                const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
