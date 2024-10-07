import 'package:b_dental/globals.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String page;
  final int id;



  const NavBar(this.page, this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                decoration: BoxDecoration(
                    border: Border.all(color: getPrimaryColor(context), width: 5),
                    borderRadius: BorderRadius.circular(8),
                    color: getBackgroundColor(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: getPrimaryColor(context),
                        size: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                      icon: Icon(
                        Icons.home,
                        color: getPrimaryColor(context),
                        size: 36,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName('/home'));
                      },
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              );
  }
}
