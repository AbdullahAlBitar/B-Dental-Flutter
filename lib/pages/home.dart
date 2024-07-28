// ignore_for_file: prefer_const_constructors

import 'package:b_dental/globals.dart';
import 'package:b_dental/pages/user/Doctor.dart';
import 'package:b_dental/pages/user/Patient.dart';
import 'package:b_dental/pages/user/Payment.dart';
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
  Color colorDark = globalColorDark;

  TextStyle labelStyle = TextStyle(color: Colors.white);

  int currentIndex = 0;
  final List<Widget> screens = [Doctor(), Patient(), Visit(), Payment()];

  final List<BottomNavigationBarItem> desNav = [
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle_outlined), label: "Doctor"),
    BottomNavigationBarItem(icon: Icon(Icons.sick_outlined), label: "Patients"),
    BottomNavigationBarItem(
        icon: Icon(Icons.view_timeline_outlined), label: "Visits"),
    BottomNavigationBarItem(
        icon: Icon(Icons.payments_outlined), label: "Payments"),
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
        backgroundColor: globalColorDarker,
        unselectedItemColor: globalColorDark,
        selectedItemColor: globalColorLight,
        elevation: 5,
      ),
    );
  }
}
