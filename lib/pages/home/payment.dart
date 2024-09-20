import 'package:b_dental/cards/payment_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  final List<PaymentCard> payments = [
    PaymentCard(1, "p1", "d1", 500000, DateTime.now()),
    PaymentCard(1, "abdah", "yousof", 500000, DateTime.now()),
    PaymentCard(1, "p1", "d1", 500000, DateTime.now()),
    PaymentCard(1, "p1", "d1", 500000, DateTime.now()),
    PaymentCard(1, "p1", "d1", 500000, DateTime.now()),
  ];

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
            icon: const Icon(
              Icons.attach_money,
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
                  'Payments: ',
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
                      children: payments,
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
