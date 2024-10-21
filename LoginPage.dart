import 'package:flutter/material.dart';
import 'RegistrationPage.dart';
import 'PostList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? globalToken;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isNotValidate = false;
  bool _isHovering = false;

  bool _validateEmail(String value) {
    String emailPattern =
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email format
    RegExp regExp = new RegExp(emailPattern);
    return regExp.hasMatch(value);
  }

  Future<void> loginUser() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      var loginData = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(loginData),
      );

      // Process response
      if (response.statusCode == 200) {
        // Login successful, extract token from response
        var data = jsonDecode(response.body);
        globalToken = data['token'];
        print('Login successful, Token: $globalToken');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DestinationListPage()), // Pass token to DestinationListPage
        );
      } else {
        // Login failed, display error message
        print('Login failed: ${response.body}');
      }
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(128, 0, 0, 1),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Let's sign you in.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xAA1A1B1E),
                border: Border.all(color: Color(0xFF373A3F)),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFF373A3F)),
                      ),
                    ),
                    child: TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                        errorText: _isNotValidate && !_validateEmail(emailController.text) ? "Invalid email format" : null,
                        hintText: "Email or Phone number",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(),
                    child: TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        errorText: _isNotValidate && passwordController.text.isEmpty ? "Password is required" : null,
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Color(0xFF5C5F65)),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                            Icons.remove_red_eye,
                            color: Color(0xFF5C5F65),
                          ),
                        ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25,),
            MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovering = false;
                });
              },
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: _isHovering ? Colors.blue : Color.fromARGB(255, 71, 114, 200),
                        fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    SizedBox(width: 6,),
                    Text(
                      "Register",
                      style: TextStyle(
                        color: _isHovering ? Colors.blue : Colors.blue,
                        fontWeight: _isHovering ? FontWeight.bold : FontWeight.normal,
                        fontSize: _isHovering ? 24.0 : 16.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: MaterialButton(
                onPressed: () {
                  loginUser();
                  setState(() {
                    _isNotValidate = true;
                  });
                  if (_validateEmail(emailController.text) && passwordController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DestinationListPage()),
                    );
                  } else {
                    // Show red error text for invalid email or missing password
                  }
                },
                color: Color(0xAA3A5BDA),
                padding: EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.7),
                      fontSize: 16,
                    ),
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
