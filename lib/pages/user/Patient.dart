import 'package:b_dental/cards/patient_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Container(
          padding: const EdgeInsets.all(5),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: globalColorDark),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_outlined, size: 30,),
            color: globalColorLight,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            color: globalDarkBG,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Patients: ',
                  style: TextStyle(
                      color: globalColorLight,
                      fontSize: 24,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: globalBG,
                  ),
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height - 50 - 120,
                  child: const SingleChildScrollView(
                    child: Column(
                      children: [
                        PatientCard(1, "avsvsrv", "0912345678", 1),
                        PatientCard(1, "avsvsrv", "0912345678", 1),
                        PatientCard(1, "avsvsrv", "0912345678", 0),
                        PatientCard(1, "avsvsrv", "0912345678", 0),
                        PatientCard(1, "avsvsrv", "0912345678", 1),
                        PatientCard(1, "avsvsrv", "0912345678", 0),
                        PatientCard(1, "avsvsrv", "0912345678", 1),
                        PatientCard(1, "avsvsrv", "0912345678", 0),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
