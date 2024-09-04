// ignore_for_file: prefer_const_constructors

import 'package:b_dental/globals.dart';
import 'package:b_dental/pages/user/doctor.dart';
import 'package:b_dental/pages/user/patient.dart';
import 'package:b_dental/pages/user/payment.dart';
import 'package:b_dental/pages/user/Visit.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color colorLight = globalColorLight;

  TextStyle labelStyle = TextStyle(color: Colors.white);

  int currentIndex = 0;
  final List<Widget> screens = [Doctor(), Patient(), Visit(), Payment()];

  final List<BottomNavigationBarItem> desNav = [
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined), label: "Doctor", activeIcon: Icon(Icons.account_circle_rounded)),
    BottomNavigationBarItem(icon: Icon(Icons.sick_outlined), label: "Patients", activeIcon: Icon(Icons.sick)),
    BottomNavigationBarItem(
        icon: Icon(Icons.view_timeline_outlined), label: "Visits", activeIcon: Icon(Icons.view_timeline)),
    BottomNavigationBarItem(
        icon: Icon(Icons.payments_outlined), label: "Payments", activeIcon: Icon(Icons.payments)),
  ];

  @override
  void initState() {
    super.initState();
    printUser();
  }

  void printUser() async {
    print((await SharedPreferences.getInstance()).getString("username"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: desNav,
        backgroundColor: globalColorDark,
        unselectedItemColor: Colors.cyanAccent.shade700,
        selectedItemColor: globalColorLight,
        elevation: 5,
      ),
    );
  }
}
