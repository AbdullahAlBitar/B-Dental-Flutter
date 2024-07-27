// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  late bool newuser;
  @override
  void initState() {
    super.initState();
    isLogedIn();
  }

  Future<void> isLogedIn() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);

    print(newuser);
    if (newuser == false) {
      Navigator.pushNamed(context, "/home");
    }
  }

  Color colorLight = globalColorLight;
  Color colorDark = globalColorDark;

  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.jpg"),
                fit: BoxFit.cover
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: colorLight,
                    border: Border.all(
                      color: Colors.white,
                      width: 5
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: colorDark,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            "B-Dental",
                            style: TextStyle(
                              backgroundColor: Colors.white,
                              fontSize: 34,
                              color: colorDark,
                              fontFamily: "SpicyRice"
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                      Column(
                        children: [
                          TextField(
                          cursorColor: colorLight,
                          style: TextStyle(
                            color: colorDark,
                            fontFamily: "Paprika"
                          ),
                          decoration: InputDecoration(
                            suffixIconColor: colorLight,
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: colorLight,
                              fontFamily: "Paprika"
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorLight,
                                width: 3
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorDark,
                                width: 3
                              ),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () => _controllerUsername.clear(),
                            )
                          ),
                          controller: _controllerUsername,
                        ),
                          SizedBox(height: 30,),
                          TextField(
                            obscureText: true,
                            cursorColor: colorLight,
                            style: TextStyle(
                              color: colorDark,
                              fontFamily: "Paprika"
                            ),
                            decoration: InputDecoration(
                              suffixIconColor: colorLight,
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: colorLight,
                                fontFamily: "Paprika"
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorLight,
                                  width: 3
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: colorDark,
                                  width: 3
                                ),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () => _controllerPassword.clear(),
                              )
                            ),
                            controller: _controllerPassword,
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                child: Text(
                                  "SignUp?",
                                ),
                                onPressed: () {
                                  
                                },
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll<Color>(colorDark),
                                ),
                                onPressed: () async{
                                  String username = _controllerUsername.text;
                                  String password = _controllerPassword.text;

                                  if (username != '' && password != '') {
                                    SharedPreferences logindata = await SharedPreferences.getInstance();
                                    print('Successfull');
                                    logindata.setBool('login', false);

                                    logindata.setString('username', username);

                                    _controllerPassword.clear();
                                    _controllerUsername.clear();

                                    Navigator.pushNamed(context, "/home");
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white
                                    ),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
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
