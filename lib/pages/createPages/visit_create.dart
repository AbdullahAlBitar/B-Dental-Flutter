import 'package:b_dental/cards/nav_bar.dart';
import 'package:b_dental/cards/patient_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VisitDetails extends StatefulWidget {
  const VisitDetails({super.key});

  @override
  State<VisitDetails> createState() => _VisitDetailsState();
}

class _VisitDetailsState extends State<VisitDetails> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  String jwt = "";
  int id = 0;
  String name = "";
  String description = "";
  String charge = "";
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
      final int? visitId = ModalRoute.of(context)?.settings.arguments as int?;
      if (visitId != null) {
        setState(() {
          id = visitId;
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
        Uri.parse('$url/visits/profile/$id'),
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
          description = res['description'];
          date = res['date'];
          charge = res['charge'].toString();
          if (charge.contains(".")) {
            charge = res['charge']
                .toString()
                .substring(0, res['charge'].toString().indexOf("."));
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


  @override
  Widget build(BuildContext context) {
    Color colorLight = getAccentColor(context);
  
    return Scaffold(
      backgroundColor: getDarkBackgroundColor(context),
      body: SingleChildScrollView(
          child: Container(
            color: getDarkBackgroundColor(context),
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
                      Text(
                        name,
                        style: TextStyle(
                            color: colorLight,
                            fontSize: 24,
                            decoration: TextDecoration.none),
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
                Text(
                  description,
                  softWrap: true,
                  style: TextStyle(
                      color: getTextColor(context),
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      date.substring(0, 10),
                      softWrap: true,
                      style: TextStyle(
                          color: getAccentColor(context),
                          fontSize: 14,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                Divider(color: getTextColor(context)),
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
                          style: TextStyle(
                              color: getTextColor(context),
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Charge: ',
                          style: TextStyle(
                              color: colorLight,
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          charge,
                          style: TextStyle(
                              color: getTextColor(context),
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          ' SYP',
                          style: TextStyle(
                              color: getTextColor(context),
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PatientCard(patientId, patientName, patientPhone, patientSex == "Male"? 1 : 0),
                    const SizedBox(height: 20),
                  ],
                ),
                NavBar('visit', id),
              ],
            ),
          ),
        ),
    );
  }
}
