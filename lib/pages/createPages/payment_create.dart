import 'package:b_dental/cards/patient_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({super.key});

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  String jwt = "";
  int id = 0;
  String amount = "";
  String date = "             ";
  String doctorName = "";
  int patientId = 0;
  String patientName = "";
  String patientSex = "";
  String patientPhone = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final int? paymentId = ModalRoute.of(context)?.settings.arguments as int?;
      if (paymentId != null) {
        setState(() {
          id = paymentId;
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
        Uri.parse('$url/payments/profile/$id'),
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
          date = res['date'];
          amount = res['amount'].toString();
          if (amount.contains(".")) {
            amount = res['amount']
                .toString()
                .substring(0, res['amount'].toString().indexOf("."));
          }
          patientId = res['patient_id'];
          doctorName = res['doctor_name'];
          patientName = res['patient_name'];
          patientSex = res['patient_sex'];
          patientPhone = res['patient_phone'];
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

  Color colorLight = globalColorLight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globalDarkBG,
      body: SingleChildScrollView(
        child: Container(
          color: globalDarkBG,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                              color: globalColorLight,
                              fontSize: 24,
                              decoration: TextDecoration.none),
                        ),
                        const Text(
                          ' SYP',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_note_rounded,
                        color: colorLight,
                        size: 36,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    date.substring(0, 10),
                    softWrap: true,
                    style: TextStyle(
                        color: globalColorLight,
                        fontSize: 14,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              const Divider(color: Colors.white),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Dr: ',
                        style: TextStyle(
                            color: colorLight,
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                      Text(
                        doctorName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  PatientCard(patientId, patientName, patientPhone,
                      patientSex == "Male" ? 1 : 0),
                  const SizedBox(height: 20),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: globalColorLight, width: 5),
                    borderRadius: BorderRadius.circular(8),
                    color: globalBG),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: colorLight,
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
                        color: colorLight,
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
