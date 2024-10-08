import 'dart:async';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> fetchPatientDetails(int id, String jwt) async {
  try {
    final response = await http.post(
      Uri.parse('$url/patients/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwt',
      },
    ).timeout(const Duration(seconds: 5), onTimeout: () {
      throw TimeoutException('Request timed out');
    });

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      return {'success': false, 'message': 'Failed to fetch patient details'};
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error. Please try again later.'
    };
  }
}

Future<Map<String, dynamic>> createOrUpdatePatient(
    int id, String name, String phone, String birthdate, String sex) async {
  if (name.isNotEmpty &&
      phone.isNotEmpty &&
      birthdate.isNotEmpty &&
      sex.isNotEmpty) {
    try {
      final uri = id == 0
          ? Uri.parse('$url/patients/create')
          : Uri.parse('$url/patients/update/$id');
      final response = await http
          .post(
        uri,
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'name': name,
          'phone': phone,
          'birthdate': birthdate,
          'sex': sex,
        }),
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': id == 0
              ? 'Patient created successfully'
              : 'Patient updated successfully'
        };
      } else {
        final res = jsonDecode(response.body);
        return {'success': false, 'message': res['error']};
      }
    } on TimeoutException catch (_) {
      return {
        'success': false,
        'message': 'Request timed out. Please try again.'
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again later.'
      };
    }
  }
  return {'success': false, 'message': 'All fields are required.'};
}

class CreateUpdatePatient extends StatefulWidget {
  const CreateUpdatePatient({super.key});

  @override
  State<CreateUpdatePatient> createState() => _CreateUpdatePatientState();
}

class _CreateUpdatePatientState extends State<CreateUpdatePatient> {
  String jwt = "";
  int? _patientId; // ID for updating the patient
  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  String? _selectedSex;
  DateTime? _selectedBirthdate;
  bool _isButtonDisabled = false;
  bool _isPhoneEditable = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // Initialize the JWT and patient ID
  Future<void> _initialize() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    jwt = logindata.getString('jwt') ?? '';
    
    if (jwt.isEmpty) {
      // If no JWT is found, redirect to login page
      Navigator.pushNamed(context, "/");
      return;
    }

    // Get the ID from the arguments if provided
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    _patientId = args != null && args.containsKey('id') ? args['id'] : null;

    if (_patientId != null) {
      // If we have an ID, load patient data for updating
      _fetchPatientData();
    } else {
      setState(() {
        _isLoading = false; // No need to load patient data for creation
      });
    }
  }

  Future<void> _fetchPatientData() async {
    final result = await fetchPatientDetails(_patientId!, jwt);
    if (result['success']) {
      final data = result['data'];
      setState(() {
        _controllerName.text = data['name'];
        _controllerPhone.text = data['phone'];
        _selectedBirthdate = DateTime.parse(data['birth']);
        _selectedSex = data['sex'];
        _isPhoneEditable = false; // Disable phone field for update
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result['message'])));
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: getPrimaryColor(context),
              onPrimary: Colors.white,
              onSurface: getAccentColor(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedBirthdate) {
      setState(() {
        _selectedBirthdate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDarkBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _patientId != null
                            ? "Update Patient"
                            : "Create Patient",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: getAccentColor(context)),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _controllerName,
                        cursorColor: getAccentColor(context),
                        style: TextStyle(color: getAccentColor(context)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: getBackgroundColor(context),
                          hintText: "Name",
                          hintStyle: TextStyle(color: getAccentColor(context)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controllerPhone,
                        cursorColor: getAccentColor(context),
                        style: TextStyle(color: getAccentColor(context)),
                        enabled: _isPhoneEditable, // Disable if it's an update
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: getBackgroundColor(context),
                          hintText: "Phone",
                          hintStyle: TextStyle(color: getAccentColor(context)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: getAccentColor(context))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedBirthdate == null
                                  ? "Select Birthdate"
                                  : "Birthdate: ${_selectedBirthdate!.toLocal()}"
                                      .split('00')[0],
                              style: TextStyle(color: getAccentColor(context)),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: getAccentColor(context),
                              backgroundColor: getPrimaryColor(context),
                            ),
                            child: const Text("Choose Date"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: Text("Male",
                                style:
                                    TextStyle(color: getAccentColor(context))),
                            value: "Male",
                            groupValue: _selectedSex,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSex = value;
                              });
                            },
                            activeColor: getPrimaryColor(context),
                          ),
                          RadioListTile<String>(
                            title: Text("Female",
                                style:
                                    TextStyle(color: getAccentColor(context))),
                            value: "Female",
                            groupValue: _selectedSex,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedSex = value;
                              });
                            },
                            activeColor: getPrimaryColor(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                setState(() {
                                  _isButtonDisabled = true;
                                });

                                String name = _controllerName.text;
                                String phone = _controllerPhone.text;
                                String birthdate = _selectedBirthdate != null
                                    ? "${_selectedBirthdate!.year}-${_selectedBirthdate!.month}-${_selectedBirthdate!.day}"
                                    : "";
                                String sex = _selectedSex ?? "";

                                Map<String, dynamic> result =
                                    await createOrUpdatePatient(
                                  _patientId ??
                                      0, // Use 0 for new patient creation
                                  name,
                                  phone,
                                  birthdate,
                                  sex,
                                );

                                if (mounted) {
                                  if (result['success']) {
                                    _controllerName.clear();
                                    _controllerPhone.clear();
                                    setState(() {
                                      _selectedBirthdate = null;
                                      _selectedSex = null;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(result['message'])),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(result['message'])),
                                    );
                                  }
                                }

                                setState(() {
                                  _isButtonDisabled = false;
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: getAccentColor(context),
                          backgroundColor: getPrimaryColor(context),
                        ),
                        child: const Text("Submit"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
