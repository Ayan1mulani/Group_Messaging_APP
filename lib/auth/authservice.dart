import 'package:flutter/material.dart';

class textfeild extends StatelessWidget {
  const textfeild({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Color(0xff383A40),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 15.0),
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                  hintStyle: TextStyle(color: Color(0xff575A5B))),
            ),
          )),
    );
  }
}
