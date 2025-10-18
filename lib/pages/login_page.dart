import 'package:flutter/material.dart';
import 'package:order_up_app/backend/firebase/auth_service.dart';
import 'package:order_up_app/pages/loading_screen.dart';
import 'package:order_up_app/pages/main_page.dart';
import 'package:order_up_app/pages/password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();    // Controls the email textbox
  final TextEditingController _passwordController = TextEditingController(); // Controls the password textbox
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(                                    // Used for checking if a variable changes
      valueListenable:
          authService,                                                // Pays attention and listens if this variable will change
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              // are u waiting?
              return LoadingScreen();

            } else if (snapshot.hasData) {
              // are u logged in?
              return AppMainPage();

            } else {
              // please log in
              return Scaffold(
                backgroundColor: const Color(0xFFFFEBD2),
                body: Center(
                  child: SizedBox(
                    width: 412,
                    height: 917,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 60),

                          // Logo Asset //
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: const AssetImage('img/orderuplogo.png'),
                            backgroundColor: Colors.transparent,
                          ),

                          const SizedBox(height: 20),

                          // Login Card //
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome back!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  "Please enter your details",
                                  style: TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                                const SizedBox(height: 20),

                                // Username //
                                const Text(
                                  "Email:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.person_outline),
                                    hintText: "Type your email",
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Password //
                                const Text(
                                  "Password:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    hintText: "Type your password",
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Forgot Password //
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const Password(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: Color(0xFF3FBFFF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                // Sign In button //
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF3FBFFF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    onPressed: clickLoginButton,
                                    child: const Text(
                                      "Sign in",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 60),

                          // Footer //
                          
                        ],
                      ),
                    ),
                  ),
                ),
                bottomSheet: Container(
                  width: double.infinity,
                  height: 30,
                  color: const Color(0xFFAE3D33),
                  padding: const EdgeInsets.all(8),
                  child: const Center(
                    child: Text(
                      "©2025 OrderUp. All rights reserved", 
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clickLoginButton() async {
    try {
      if (_emailController.text == "" || _passwordController.text == "") {
        showError("Credential input should not be empty.");
      } else {
        await authService.value.signIn(
        email: _emailController.text,
        password: _passwordController.text,
        );
        _emailController.text = "";
        _passwordController.text = "";
      }

    } catch (e) {
      showError("Inputted credentials are incorrect, malformed, or have expired.");
    }
  }

  void showError(Object e) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('An error occurred.'),
        content: Text('$e'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
