import 'package:b_dental/cards/visit_card.dart';
import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Doctor extends StatefulWidget {
  const Doctor({super.key});

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  void logOut() async {
    (await SharedPreferences.getInstance()).remove("login");
    setState(() {
      Navigator.pop(context);
    });
  }

  Color colorLight = globalColorLight;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        color: globalDarkBG,
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dr. ',
                          style: TextStyle(
                              color: colorLight,
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                        const Text(
                          'Yousof',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "0994669593",
                      style: TextStyle(
                          color: colorLight,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit_note_rounded,
                      color: colorLight,
                      size: 36,
                    ))
              ],
            ),
            const Divider(
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Dues: ',
                      style: TextStyle(
                          color: colorLight,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                    const Text(
                      '1000000000',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                    const Text(
                      ' SYP',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Visits: ',
                  style: TextStyle(
                      color: colorLight,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
                const SizedBox( height: 10,), 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: globalBG,
                  ),
                  padding: const EdgeInsets.all(10),
                  height: 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        VisitCard(1, "avsvsrv", 123456, DateTime(2002)),
                        VisitCard(1, "avsvsrv", 123456, DateTime(2002)),
                        VisitCard(1, "avsvsrv", 123456, DateTime(2002)),
                        VisitCard(1, "avsvsrv", 123456, DateTime(2002)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: logOut,
                    icon: const Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                      size: 36,
                    )),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
