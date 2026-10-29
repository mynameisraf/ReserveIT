import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Navy Blue & White Color Palette
  static const Color backgroundColor = Color(0xFF0B1736);
  static const Color primaryNavy = Color(0xFF1E3A8A);
  static const Color inputColor = Color(0xFFF1F5F9);
  static const Color textColor = Colors.white;
  static const Color secondaryTextColor = Color(0xFFBACDE8);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ReserveIT [R] Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/logo.png',
                    height: 180,
                    width: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 30),

                // ReserveIT Title
                Text(
                  'ReserveIT',
                  style: GoogleFonts.bebasNeue(
                    fontSize: 52,
                    color: textColor,
                    letterSpacing: 2.5,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Computer Cafe & Gaming PC Reservations',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: secondaryTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40),

                // Email Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF0B1736),
                        ),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.email_outlined, color: Color(0xFF1E3A8A)),
                          border: InputBorder.none,
                          hintText: 'Email address',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Password Input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF0B1736),
                        ),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock_outline, color: Color(0xFF1E3A8A)),
                          border: InputBorder.none,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Sign In Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0B1736),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        final messenger = ScaffoldMessenger.of(context);
                        try {
                          await signIn();

                          if (!mounted) return;
                          navigator.pushReplacementNamed('/home');
                        } catch (e) {
                          if (!mounted) return;
                          messenger.showSnackBar(
                            SnackBar(
                              backgroundColor: primaryNavy,
                              content: Text(
                                'Sign in failed: $e',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0B1736),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Register
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration feature coming soon!'),
                          ),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Quick Demo / Preview
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white70),
                  label: Text(
                    'Explore Dashboard (Demo / Preview)',
                    style: GoogleFonts.poppins(
                      color: secondaryTextColor,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
