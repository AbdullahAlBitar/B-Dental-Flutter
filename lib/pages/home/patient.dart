import 'package:b_dental/cards/patient_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Patient extends StatefulWidget {
  const Patient({super.key});

  @override
  State<Patient> createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  TextEditingController searchController = TextEditingController();
  String jwt = "";
  List patients = [];
  List filteredPatients = [];

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
        Uri.parse('$url/patients/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwt',
        },
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        setState(() {
          patients = res;
          filteredPatients = patients; // Initialize filtered list
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

  void filterPatients(String query) {
    List filtered = patients.where((p) {
      final nameLower = p['name'].toLowerCase();
      final phoneLower = p['phone'].toLowerCase();
      final searchLower = query.toLowerCase();
      return nameLower.contains(searchLower) || phoneLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredPatients = filtered;
    });
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
            Navigator.pushNamed(context, "/patientUpdate");
          },
          icon: const Icon(
            Icons.person_add_alt_outlined,
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Patients: ',
                    style: TextStyle(
                        color: getAccentColor(context),
                        fontSize: 24,
                        decoration: TextDecoration.none),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search bar
              TextField(
                cursorColor: getTextColor(context),
                controller: searchController,
                style: TextStyle(
                  color: getAccentColor(context)
                ),
                onChanged: (value) {
                  filterPatients(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search by name or phone',
                  labelStyle: TextStyle(
                    color: getAccentColor(context)
                  ),
                  prefixIcon: Icon(Icons.search, color: getAccentColor(context)),
                  filled: true,
                  fillColor: getBackgroundColor(context),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(
                    color: getAccentColor(context)
                  )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: getBackgroundColor(context),
                ),
                padding: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height - 50 - 170,
                child: SingleChildScrollView(
                  child: Column(
                    children: filteredPatients
                          .map((p) => PatientCard(
                            p['id'], p['name'], p['phone'], p['sex'] == "Male" ? 1 : 0
                          ))
                          .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

}