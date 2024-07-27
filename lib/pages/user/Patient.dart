import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {

  void logOut() async{
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Text("Patient"),
    );
  }
}