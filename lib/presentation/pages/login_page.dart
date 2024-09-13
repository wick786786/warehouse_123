import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:warehouse_phase_1/presentation/pages/homepage/home_page.dart';

class LoginPage extends StatefulWidget {
  final String title;
  final Function(Locale) onLocaleChange;
  final VoidCallback onThemeToggle;
  const LoginPage({super.key ,required this.title,
      required this.onLocaleChange,
      required this.onThemeToggle});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Variables to store input values
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String emptyusername = "";
  String emptypassword = "";
  String successLogin = "";
  String failureLogin = "";
   Locale _locale = const Locale('en', 'US');
  bool _isDarkMode = false;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Future<void> loginfun(BuildContext context,String username, String password) async {
    setState(() {
      // Reset error messages
      emptyusername = "";
      emptypassword = "";
    });

    if (username.isEmpty) {
      setState(() {
        emptyusername = "Please enter username";
      });
    }

    if (password.isEmpty) {
      setState(() {
        emptypassword = "Please enter password";
      });
    }

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        Response response = await post(
          Uri.parse('http://xxxx.com'), // Replace with your API
          body: {'username': username, 'password': password},
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          print(data['token']);
          setState(() {
            successLogin = "Login successful";
          });
          //Navigate to HomePage after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: 'Warehouse Application',
                      onLocaleChange: _setLocale,
                      onThemeToggle: _toggleTheme,
                    )), // Replace with your HomePage class
          );
        } else {
          print('login failed');
          setState(() {
            failureLogin = "Login failed. Incorrect username or password.";
          });
        }
      } catch (e) {
        setState(() {
          failureLogin = "Login failed. Incorrect username or password.";
        });
      }
    }
  }

  @override
  void dispose() {
    // Dispose of controllers when no longer needed
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;

    return Scaffold(
      body: Stack(
        children: [
          // Background image with color filter
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background_4.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary.withOpacity(0.6),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Overlay
          Container(
            color: theme.colorScheme.surface.withOpacity(0.8),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Phone Diagnostic made ",
                              style: TextStyle(
                                fontFamily:
                                    'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 72,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: "faster.",
                              style: TextStyle(
                                fontFamily:
                                    'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8A2BE2),
                                fontSize: 72,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.lock,
                            size: 60,
                            color: primaryColor,
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.person, color: primaryColor),
                              labelText: 'Username',
                              labelStyle:
                                  TextStyle(color: theme.colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          if (emptyusername.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                emptyusername,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: primaryColor),
                              labelText: 'Password',
                              labelStyle:
                                  TextStyle(color: theme.colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          if (emptypassword.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                emptypassword,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              loginfun(context,usernameController.text,
                                  passwordController.text);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: onPrimaryColor,
                              ),
                            ),
                          ),
                          if (failureLogin.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                failureLogin,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
