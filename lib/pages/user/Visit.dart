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
    return const SafeArea(
      child: Text("Visit"),
    );
  }
}