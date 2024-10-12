import 'dart:async';
import 'package:b_dental/cards/patient_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// Fetch Payment Details function
Future<Map<String, dynamic>> fetchPaymentDetails(int id, String jwt) async {
  try {
    final response = await http.post(
      Uri.parse('$url/payments/profile/$id'),
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
      return {'success': false, 'message': 'Failed to fetch payment details'};
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error. Please try again later.'
    };
  }
}

// Create or Update Payment function
Future<Map<String, dynamic>> createOrUpdatePayment(
    int id, int patientId, double amount, String date, String jwt) async {
  if (patientId > 0 && amount > 0) {
    try {
      final uri = id == 0
          ? Uri.parse('$url/payments/create')
          : Uri.parse('$url/payments/update/$id');
      final response = await http
          .post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonEncode(<String, dynamic>{
          'patient_id': patientId,
          'amount': amount,
          'date': date,
        }),
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw TimeoutException('Request timed out');
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {
          'success': true,
          'message': id == 0
              ? 'Payment created successfully'
              : 'Payment updated successfully'
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

class CreateUpdatePayment extends StatefulWidget {
  const CreateUpdatePayment({super.key});

  @override
  State<CreateUpdatePayment> createState() => _CreateUpdatePaymentState();
}

class _CreateUpdatePaymentState extends State<CreateUpdatePayment> {
  String jwt = "";
  int? _paymentId; // ID for updating the payment
  int? _patientId; // Patient ID for whom the payment is made
  String patientName = "";
  String patientSex = "";
  String patientPhone = "";
  final _controllerAmount = TextEditingController();
  DateTime? _selectedDate;
  bool _isButtonDisabled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // Initialize the JWT and payment ID
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
    _paymentId = args != null && args.containsKey('id') ? args['id'] : null;
    _patientId = args != null && args.containsKey('patientId')
        ? args['patientId']
        : null;

    if (_paymentId != null) {
      // If we have an ID, load payment data for updating
      _fetchPaymentData();
    } else if (_patientId != null) {
      patientName = args != null && args.containsKey('patient_name')
          ? args['patient_name']
          : null;
      patientSex = args != null && args.containsKey('patient_sex')
          ? args['patient_sex']
          : null;
      patientPhone = args != null && args.containsKey('patient_phone')
          ? args['patient_phone']
          : null;
      setState(() {
        _selectedDate = DateTime.now();
        _isLoading = false; // No need to load payment data for creation
      });
    } else {
      // For creation, set the date to now
      setState(() {
        _selectedDate = DateTime.now();
        _isLoading = false; // No need to load payment data for creation
      });
    }
  }

  Future<void> _fetchPaymentData() async {
    final result = await fetchPaymentDetails(_paymentId!, jwt);
    if (result['success']) {
      final data = result['data'];
      setState(() {
        _patientId = data['patient_id'];
        patientName = data['patient_name'];
        patientSex = data['patient_sex'];
        patientPhone = data['patient_phone'];
        _controllerAmount.text = data['amount'].toString();
        _selectedDate = DateTime.parse(data['date']);
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
      initialDate: _selectedDate ?? DateTime.now(),
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
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
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
                        _paymentId != null
                            ? "Update Payment"
                            : "Create Payment",
                        style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: getAccentColor(context)),
                      ),
                      const SizedBox(height: 40),
                      if (_paymentId == null && patientName == "")
                        DropdownButtonFormField<int>(
                          value: _patientId,
                          items: [
                            // Populate the patients here. Example:
                            DropdownMenuItem(
                                value: 1, child: Text("Patient 1")),
                            DropdownMenuItem(
                                value: 2, child: Text("Patient 2")),
                          ],
                          onChanged: (int? newValue) {
                            setState(() {
                              _patientId = newValue;
                            });
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: getBackgroundColor(context),
                            hintText: "Select Patient",
                            hintStyle:
                                TextStyle(color: getAccentColor(context)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: getAccentColor(context))),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      else
                        PatientCard(_patientId!, patientName, patientPhone, patientSex == "Male"? 1 : 0),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _controllerAmount,
                        cursorColor: getAccentColor(context),
                        style: TextStyle(color: getAccentColor(context)),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: getBackgroundColor(context),
                          hintText: "Amount",
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
                              _selectedDate == null
                                  ? "Select Date"
                                  : "Date: ${_selectedDate!.toLocal()}".split('00')[0],
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
                      ElevatedButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                setState(() {
                                  _isButtonDisabled = true;
                                });

                                double amount =
                                    double.tryParse(_controllerAmount.text) ??
                                        0.0;
                                String date = _selectedDate != null
                                    ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
                                    : "";

                                Map<String, dynamic> result =
                                    await createOrUpdatePayment(
                                  _paymentId ?? 0,
                                  _patientId ?? 0,
                                  amount,
                                  date,
                                  jwt,
                                );

                                if (mounted) {
                                  if (result['success']) {
                                    _controllerAmount.clear();
                                    setState(() {
                                      _selectedDate = null;
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
