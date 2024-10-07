import 'dart:async';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> signUp(String name, String phone, String password, String passwordConfirmation) async {
  if (name.isNotEmpty && phone.isNotEmpty && password.isNotEmpty && passwordConfirmation.isNotEmpty) {
    if (password != passwordConfirmation) {
      return {'success': false, 'message': 'Passwords do not match.'};
    }

    try {
      final response = await http.post(
        Uri.parse('$url/auth/signup'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{'name': name, 'phone': phone, 'password': password, "cPassword": passwordConfirmation}),
      ).timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'User created successfully'};
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
  return {'success': false, 'message': 'All fields are required.'};
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerPasswordConfirmation = TextEditingController();
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDarkBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: getAccentColor(context)),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _controllerName,
                  cursorColor: getAccentColor(context),
                  style: TextStyle(color: getAccentColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: getBackgroundColor(context),
                    hintText: "Name",
                    hintStyle: TextStyle(color: getAccentColor(context)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: getAccentColor(context)
                      )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerPhone,
                  cursorColor: getAccentColor(context),
                  style: TextStyle(color: getAccentColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: getBackgroundColor(context),
                    hintText: "Phone",
                    hintStyle: TextStyle(color: getAccentColor(context)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: getAccentColor(context)
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
                  cursorColor: getAccentColor(context),
                  style: TextStyle(color: getAccentColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: getBackgroundColor(context),
                    hintText: "Password",
                    hintStyle: TextStyle(color: getAccentColor(context)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: getAccentColor(context)
                      )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerPasswordConfirmation,
                  obscureText: true,
                  cursorColor: getAccentColor(context),
                  style: TextStyle(color: getAccentColor(context)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: getBackgroundColor(context),
                    hintText: "Confirm Password",
                    hintStyle: TextStyle(color: getAccentColor(context)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                        color: getAccentColor(context)
                      )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isButtonDisabled ? null : () async {
                    setState(() {
                      _isButtonDisabled = true;
                    });
            
                    String name = _controllerName.text;
                    String phone = _controllerPhone.text;
                    String password = _controllerPassword.text;
                    String passwordConfirmation = _controllerPasswordConfirmation.text;
            
                    Map<String, dynamic> result = await signUp(name, phone, password, passwordConfirmation);
            
                    if (mounted) {
                      if (result['success']) {
                        _controllerName.clear();
                        _controllerPhone.clear();
                        _controllerPassword.clear();
                        _controllerPasswordConfirmation.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result['message'])),
                        );
                        Navigator.pop(context);
                        //Navigator.pushNamed(context, "/home");
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
                    foregroundColor: getAccentColor(context), backgroundColor: getPrimaryColor(context),
                  ),
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
