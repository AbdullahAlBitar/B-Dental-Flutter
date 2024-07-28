import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Visit extends StatefulWidget {
  const Visit({super.key});

  @override
  State<Visit> createState() => _VisitState();
}

class _VisitState extends State<Visit> {

  void logOut() async{
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          color: globalDarkBG,
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(children: [

          ],),
        ),
      ),
    );
  }
}