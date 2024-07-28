import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';

class VisitCard extends StatelessWidget {

  final int id;
  final String name;
  final double charge;
  final DateTime date;

  const VisitCard(this.id,this.name,this.charge,this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: globalColorDarker,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(name,
                style: TextStyle(
                  fontSize: 20,
                  color: globalColorLight,
                ),),
              Text("$charge SYP",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),),
                const SizedBox( height: 10)
            ],
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(date.toString().substring(0, 10),
                style: const TextStyle(
                  color: Colors.white
                ),
              )
            ),
          ),
          const SizedBox(width: 10,)
        ],
      ),
    );
  }
}
