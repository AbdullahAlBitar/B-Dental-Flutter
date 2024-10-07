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
      color: getPrimaryColor(context),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {
                    Navigator.pushNamed(context, "/paymentDetails", arguments: id);
              },
              icon: Icon(
                Icons.info_outline,
                color: getAccentColor(context),
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
                      color: getAccentColor(context),
                    ),
                  ),
                  Icon(
                    Icons.double_arrow_outlined,
                    color: getTextColor(context),
                    size: 15,
                  ),
                  Text(
                    doctorName,
                    style: TextStyle(
                      fontSize: 14,
                      color: getAccentColor(context),
                    ),
                  ),
                ],
              ),
              Text(
                "${amount.toString().substring(0, amount.toString().indexOf("."))} SYP",
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
                child: Text(
                  date.toString().substring(0, 10),
                  style: TextStyle(color: getTextColor(context)),
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
