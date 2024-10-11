// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:b_dental/pages/createPages/patient_create.dart';
import 'package:b_dental/pages/createPages/payment_create.dart';
import 'package:b_dental/pages/details/patient_details.dart';
import 'package:b_dental/pages/details/payment_details.dart';
import 'package:b_dental/pages/details/visit_details.dart';
import 'package:b_dental/pages/home.dart';
import 'package:b_dental/pages/login.dart';
import 'package:b_dental/pages/signup.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      "/": (context) => Login(),
      "/register": (context) => SignUp(),
      "/home": (context) => Home(),
      "/patientDetails": (context) => PatientDetails(),
      "/visitDetails": (context) => VisitDetails(),
      "/paymentDetails": (context) => PaymentDetails(),
      "/patientUpdate": (context) => CreateUpdatePatient(),
      "/paymentUpdate": (context) => CreateUpdatePayment(),
    },
    themeMode: ThemeMode.system,
  )
);
