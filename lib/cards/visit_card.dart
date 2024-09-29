
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {
  final int id;
  final String name;
  final double charge;
  final DateTime date;

  const VisitCard(this.id, this.name, this.charge, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globalColorDark,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5),
          IconButton(
              onPressed: () {
                    Navigator.pushNamed(context, "/visitDetails", arguments: id);
              },
              icon: Icon(
                Icons.info_outline,
                color: globalColorLight,
                size: 26,
              )),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 5,),
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  color: globalColorLight,
                ),
              ),
              Text(
                "${charge.toString().substring(0, charge.toString().indexOf("."))} SYP",
                style: TextStyle(
                  fontSize: 15,
                  color: globalTextColor,
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
                  style: TextStyle(color: globalTextColor),
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
