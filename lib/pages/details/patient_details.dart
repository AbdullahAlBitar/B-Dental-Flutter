import 'package:b_dental/cards/payment_card.dart';
import 'package:b_dental/cards/visit_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PatientDetails extends StatefulWidget {
  const PatientDetails({super.key});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  String jwt = "";
  int id = 0;
  String name = "";
  String phone = "";
  String sex = "";
  String dues = "";
  List visits = [];
  List payments = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int? patientId = ModalRoute.of(context)?.settings.arguments as int?;
      if (patientId != null) {
        setState(() {
          id = patientId;
        });
        getInfo();
      }
    });
  }

  Future<void> getInfo() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    jwt = logindata.getString('jwt') ?? '';
    if (jwt.isEmpty) {
      Navigator.pushNamed(context, "/");
    }

    try {
      final response = await http.post(
        Uri.parse('$url/patients/profile/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jwt': jwt,
        }),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        setState(() {
          name = res['name'];
          phone = res['phone'];
          sex = res['sex'];
          dues = res['dues'].toString();
          if (dues.contains(".")) {
            dues = res['dues']
                .toString()
                .substring(0, res['dues'].toString().indexOf("."));
          }
          visits = res['visits'];
          payments = res['payments'];
        });
        return;
      } else {
        final res = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["error"])),
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
    // Use the dynamic color getters based on context
    Color accentColor = getAccentColor(context);
    Color backgroundColor = getBackgroundColor(context);
    Color darkBackgroundColor = getDarkBackgroundColor(context);
    Color textColor = getTextColor(context);

    return Scaffold(
      backgroundColor: darkBackgroundColor,  // Dynamically set background color
      body: SingleChildScrollView(
        child: Container(
          color: darkBackgroundColor,  // Dynamically set background color
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sex == "Male" ? Icons.person : Icons.person_2,
                            color: sex == "Male" ? Colors.blue : Colors.pink,
                            size: 30,
                          ),
                          Text(
                            name,
                            style: TextStyle(
                                color: textColor,  // Dynamically set text color
                                fontSize: 24,
                                decoration: TextDecoration.none),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        phone,
                        style: TextStyle(
                            color: accentColor,  // Dynamically set accent color
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit_note_rounded,
                      color: accentColor,  // Dynamically set accent color
                      size: 36,
                    ),
                  )
                ],
              ),
              Divider(color: textColor),  // Dynamically set divider color
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dues: ',
                        style: TextStyle(
                            color: accentColor,  // Dynamically set accent color
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        dues,
                        style: TextStyle(
                            color: textColor,  // Dynamically set text color
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        ' SYP',
                        style: TextStyle(
                            color: textColor,  // Dynamically set text color
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Visits: ',
                    style: TextStyle(
                        color: accentColor,  // Dynamically set accent color
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: backgroundColor,  // Dynamically set background color
                    ),
                    padding: const EdgeInsets.all(10),
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: visits
                            .map((v) => VisitCard(
                                v['id'],
                                v['name'],
                                double.parse("${v['charge']}"),
                                DateTime.parse(v['date'])))
                            .toList(),
                      ),
                    ),
                  ),
                  Text(
                    'Payments: ',
                    style: TextStyle(
                        color: accentColor,  // Dynamically set accent color
                        fontSize: 20,
                        decoration: TextDecoration.none),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: backgroundColor,  // Dynamically set background color
                    ),
                    padding: const EdgeInsets.all(10),
                    height: 200,
                    child: SingleChildScrollView(
                      child: Column(
                        children: payments
                            .map((p) => PaymentCard(
                                p['id'],
                                name,
                                p['Doctor']['name'],
                                double.parse("${p['amount']}"),
                                DateTime.parse(p['date'])))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: accentColor, width: 5),
                    borderRadius: BorderRadius.circular(8),
                    color: backgroundColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: accentColor,
                        size: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                      icon: Icon(
                        Icons.home,
                        color: accentColor,
                        size: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
