import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {

  void logOut() async{
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  // TextButton(
  //       onPressed: logOut,
  //       child: const Text("logOut"),
  //     ),

  Color colorLight = globalColorLight;
  Color colorDark = globalColorDark;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Dr.",
                style: TextStyle(
                  color: colorLight,
                ),
                ),
                Icon(
                  Icons.edit_note_rounded,
                  color: colorLight,
                )
              ],
            )
          ],) ,)
    );
  }
}