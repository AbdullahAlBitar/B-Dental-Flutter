// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final jwt = jsonDecode(response.body)['jwt'];
        SharedPreferences logindata = await SharedPreferences.getInstance();
        await logindata.setBool('login', false);
        await logindata.setString('username', username);
        await logindata.setString('jwt', jwt);
        return {'success': true, 'jwt': jwt};
      } else {
        return {'success': false, 'message': 'Login failed. Please try again.'};
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again later.'
      };
    }
  }
  return {
    'success': false,
    'message': 'Username and password cannot be empty.'
  };
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
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: globalDarkBG,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: globalBG,
                    border: Border.all(color: globalColorLight, width: 5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: globalColorDark,
                          border:
                              Border.all(color: globalColorLight, width: 3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "B-Dental",
                            style: TextStyle(
                                backgroundColor: globalColorDark,
                                fontSize: 34,
                                color: globalColorLight,
                                fontFamily: "SpicyRice"),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Column(
                        children: [
                          TextField(
                            cursorColor: globalColorLight,
                            style: TextStyle(
                                color: globalColorLight,
                                fontFamily: "Paprika"),
                            decoration: InputDecoration(
                                suffixIconColor: globalColorLight,
                                filled: true,
                                fillColor: globalColorDark,
                                hintText: "Username",
                                hintStyle: TextStyle(
                                    color: globalColorLight,
                                    fontFamily: "Paprika"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: globalColorDark, width: 3),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: globalColorLight, width: 3),
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () =>
                                      _controllerUsername.clear(),
                                )),
                            controller: _controllerUsername,
                          ),
                          SizedBox(height: 30),
                          TextField(
                            obscureText: true,
                            cursorColor: globalColorLight,
                            style: TextStyle(
                                color: globalColorLight,
                                fontFamily: "Paprika"),
                            decoration: InputDecoration(
                                suffixIconColor: globalColorLight,
                                filled: true,
                                fillColor: globalColorDark,
                                hintText: "Password",
                                hintStyle: TextStyle(
                                    color: globalColorLight,
                                    fontFamily: "Paprika"),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: globalColorDark, width: 3),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: globalColorLight, width: 3),
                                    borderRadius: BorderRadius.circular(10)),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () =>
                                      _controllerPassword.clear(),
                                )),
                            controller: _controllerPassword,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text(
                                  "SignUp?",
                                  style: TextStyle(color: globalColorLight),
                                ),
                                onPressed: () {},
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          globalColorDark),
                                ),
                                onPressed: () async {
                                  String username = _controllerUsername.text;
                                  String password = _controllerPassword.text;
                                  Map<String, dynamic> result =
                                      await login(username, password);
                                  if (mounted) {
                                    if (result['success']) {
                                      _controllerPassword.clear();
                                      _controllerUsername.clear();
                                      // Additional check before using context
                                      Navigator.pushNamed(context, "/home");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(result['message'])),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      borderRadius:
                                          BorderRadius.circular(20)),
                                  child: Text(
                                    "LogIn",
                                    style: TextStyle(
                                      fontFamily: "Paprika",
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
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