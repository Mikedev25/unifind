import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/social_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void signup() async {
    try {
      await AuthService().signUp(
        username: _usernameController.text,
        email: _emailController.text, 
        password: _passwordController.text);
      
      // Show success message with verification email info
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF2A2A2A),
              title: const Text(
                'Verification Email Sent',
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                'A verification email has been sent to ${_emailController.text}. Please verify your email before signing in.',
                style: const TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close signup page
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Color(0xFF4ADE4A)),
                  ),
                ),
              ],
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
    }
  }

  void popPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Top Bar
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      //Logo Seal
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white30,
                            width: 1.5
                          ), 
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/school_logo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      Image.asset(
                        'assets/brand_logo.png',
                        width: 150,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 28),

                      //Username Field
                      CustomTextField(
                        controller: _usernameController, 
                        hint: 'Username',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 12),

                      //Email Field
                      CustomTextField(
                        controller: _emailController,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),

                      //Password Field
                      CustomTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                            color: Colors.white54,
                            size: 18,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )
                      ),

                      if (errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: signup,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4ADE4A),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),                 
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.white30,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or Log in with',
                              style: TextStyle(
                                color: Colors.white30,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.white30,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Social Login buttons
                       // Social login buttons (Apple + Google)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            customChild: Image.asset(
                              'assets/apple_logo.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.contain
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(width: 30),

                          SocialButton(
                            customChild: Image.asset(
                              'assets/google_logo.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Sign In prompt (If user has an account already)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 12.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color(0xFF4ADE4A),
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ), 
    );
  }
}