import 'package:b_dental/cards/payment_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  String jwt = "";
  List payments = [];

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  Future<void> getInfo() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    jwt = logindata.getString('jwt') ?? '';
    if (jwt.isEmpty) {
      Navigator.pushNamed(context, "/");
    }

    try {
      final response = await http.get(
        Uri.parse('$url/payments/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        setState(() {
          payments = res;
        });
      } else {
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['error'])),
        );

        logindata.setBool('login', true);
        Navigator.pushNamed(context, "/");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error. Please try again later.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: getDarkBackgroundColor(context),
        floatingActionButton: Container(
          padding: const EdgeInsets.all(5),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: getPrimaryColor(context)),
          child: IconButton(
            onPressed: () {
            Navigator.pushNamed(context, "/paymentUpdate");
            },
            icon: const Icon(
              Icons.attach_money,
              size: 30,
            ),
            color: getAccentColor(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Payments: ',
                      style: TextStyle(
                          color: getAccentColor(context),
                          fontSize: 24,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: getBackgroundColor(context),
                  ),
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height - 50 - 120,
                  child: SingleChildScrollView(
                    child: Column(
                      children: payments.map((p) => PaymentCard(p['id'], p['patient']['name'], p['Doctor']['name'], double.parse(p['amount'].toString()), DateTime.parse(p['date']))).toList(),
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
