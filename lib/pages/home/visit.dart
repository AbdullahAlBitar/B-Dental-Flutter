import 'package:b_dental/cards/visit_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Visit extends StatefulWidget {
  const Visit({super.key});

  @override
  State<Visit> createState() => _VisitState();
}

class _VisitState extends State<Visit> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  final List<VisitCard> visits = [
    VisitCard(201, "visit 11", 5000000.02345, DateTime.now()),
    VisitCard(1, "visit 11", 123456789.02345, DateTime.now()),
    VisitCard(1, "visit 11", 4563.0, DateTime.now()),
    VisitCard(1, "visit 11", 4563.02345, DateTime.now()),
    VisitCard(1, "visit 11", 4563.02345, DateTime.now()),
    VisitCard(1, "visit 11", 4563.02345, DateTime.now()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        padding: const EdgeInsets.all(5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: globalColorDark),
        child: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.add_circle_outline_sharp,
            size: 30,
          ),
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
                'Visits: ',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: visits,
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
    );
  }
}
