import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final int id;
  final String patientName;
  final String doctorName;
  final double amount;
  final DateTime date;

  const PaymentCard(this.id, this.patientName, this.doctorName, this.amount, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globalColorDark,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.info_outline,
                color: globalColorLight,
                size: 26,
              )),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5,),
              Row(
                children: [
                  Text(
                    patientName,
                    style: TextStyle(
                      fontSize: 14,
                      color: globalColorLight,
                    ),
                  ),
                  const Icon(
                    Icons.double_arrow_outlined,
                    color: Colors.white,
                    size: 15,
                  ),
                  Text(
                    doctorName,
                    style: TextStyle(
                      fontSize: 14,
                      color: globalColorLight,
                    ),
                  ),
                ],
              ),
              Text(
                "${amount.toString().substring(0, amount.toString().indexOf("."))} SYP",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
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
                child: Text(
                  date.toString().substring(0, 10),
                  style: const TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
