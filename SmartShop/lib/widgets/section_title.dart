import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  late String title;

  SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // margin: EdgeInsets.only(left: 20),
          child: Text(
            title,
            style: TextStyle(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Container(
          margin: EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () {},
            mouseCursor: SystemMouseCursors.click,
            child: Text(
              "See all",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
