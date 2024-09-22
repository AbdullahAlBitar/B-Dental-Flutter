import 'dart:async';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> login(String username, String password) async {
  if (username.isNotEmpty && password.isNotEmpty) {
    try {
      final response = await http.post(
        Uri.parse('$url/auth/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'phone': username, 'password': password}),
      ).timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode == 201) {
        final jwt = jsonDecode(response.body)['jwt'];
        SharedPreferences logindata = await SharedPreferences.getInstance();
        await logindata.setBool('login', false);
        await logindata.setString('username', username);
        await logindata.setString('jwt', jwt);
        return {'success': true, 'jwt': jwt};
      } else {
        final res = jsonDecode(response.body);
        return {'success': false, 'message': res['error']};
      }
    } on TimeoutException catch (_) {
      return {'success': false, 'message': 'Request timed out. Please try again.'};
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please try again later.'};
    }
  }
  return {'success': false, 'message': 'Username and password cannot be empty.'};
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool newuser;
  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    isLogedIn();
  }

  Future<void> isLogedIn() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      setState(() {
        Navigator.pushNamed(context, "/home");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalDarkBG,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "B-Dental",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: globalColorLight),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _controllerUsername,
              cursorColor: globalColorLight,
              style: TextStyle(color: globalColorLight),
              decoration: InputDecoration(
                filled: true,
                fillColor: globalBG,
                hintText: "Username",
                hintStyle: TextStyle(color: globalColorLight),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                    color: globalColorLight
                  )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controllerPassword,
              obscureText: true,
              cursorColor: globalColorLight,
              style: TextStyle(color: globalColorLight),
              decoration: InputDecoration(
                filled: true,
                fillColor: globalBG,
                hintText: "Password",
                hintStyle: TextStyle(color: globalColorLight),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                    color: globalColorLight
                  )),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register");
                  }, // Handle signup
                  child: Text("Sign Up?", style: TextStyle(color: globalColorLight)),
                ),
                ElevatedButton(
                  onPressed: _isButtonDisabled ? null : () async {
                    setState(() {
                      _isButtonDisabled = true;
                    });
                    String username = _controllerUsername.text;
                    String password = _controllerPassword.text;
                    Map<String, dynamic> result = await login(username, password);
                    if (mounted) {
                      if (result['success']) {
                        _controllerUsername.clear();
                        _controllerPassword.clear();
                        Navigator.pushNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                      }
                    }
                    setState(() {
                      _isButtonDisabled = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: globalColorLight, backgroundColor: globalColorDark,
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
