// ignore_for_file: prefer_const_constructors

import 'package:b_dental/globals.dart';
import 'package:b_dental/pages/home/doctor.dart';
import 'package:b_dental/pages/home/patient.dart';
import 'package:b_dental/pages/home/payment.dart';
import 'package:b_dental/pages/home/visit.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
        backgroundColor: getPrimaryColor(context),
        unselectedItemColor: Colors.cyanAccent[900],
        selectedItemColor: getAccentColor(context),
        elevation: 5,
      ),
    );
  }
}
