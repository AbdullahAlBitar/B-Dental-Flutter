import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  void logOut() async{
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Text("Payment"),
    );
  }
}