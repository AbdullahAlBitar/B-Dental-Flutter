import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final int id;
  final String name;
  final String phone;
  final int sex;

  const PatientCard(this.id, this.name, this.phone, this.sex, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getPrimaryColor(context),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 10),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/patientDetails", arguments: id);
              },
              icon: Icon(
                Icons.info_outline,
                color: getAccentColor(context),
                size: 26,
              )),
          const SizedBox(width: 7),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  color: getAccentColor(context),
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 15,
                  color: getTextColor(context),
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                sex == 1 ? Icons.person : Icons.person_2,
                color: sex == 1 ? Colors.blue : Colors.pink,
                size: 26,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
