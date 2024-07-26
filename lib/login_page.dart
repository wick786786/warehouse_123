import 'package:flutter/material.dart';
import 'constants.dart';
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Color(0xFFF6F5FA).withOpacity(0.8),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Phone Diagnostic made ",
                              style: TextStyle(
                                fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF030712),
                                fontSize: 72,
                                height: 1,
                              ),
                            ),
                            TextSpan(
                              text: "faster.",
                              style: TextStyle(
                                fontFamily: 'Poppins, "Segoe UI", Tahoma, Geneva, Verdana, sans-serif',
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryColor,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
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
                            color: AppColors.primaryColor,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: AppColors.primaryColor),
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                              labelText: 'Password',
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
                              backgroundColor: AppColors.primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
