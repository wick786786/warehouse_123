import 'package:flutter/material.dart';
import '../../src/core/constants.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the theme data from the context
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color onPrimaryColor = theme.colorScheme.onPrimary;
    final TextStyle headlineStyle = theme.textTheme.headlineLarge?.copyWith(
      color: onPrimaryColor,
      fontWeight: FontWeight.w700,
    ) ?? TextStyle(fontSize: 72, fontWeight: FontWeight.w700);

    return Scaffold(
      body: Stack(
        children: [
          // Background image with color filter
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_4.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  theme.colorScheme.primary.withOpacity(0.6), // Change this color to whatever you prefer
                  BlendMode.darken, // Blend mode to apply the color filter
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
                      padding: EdgeInsets.all(20),
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Phone Diagnostic made ",
                              style: TextStyle(
                                fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 72,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: "faster.",
                              style: TextStyle(
                                fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color:  Color(0xFF4CAF50) ,
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
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 4,
                            offset: Offset(0, 3),
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
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: primaryColor),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: primaryColor),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Handle login action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
