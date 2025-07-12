import 'package:flutter/material.dart';

Widget buildLogoHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'img/logo.png',
        height: 50,
      ),
      const SizedBox(width: 5),
      const Text(
        'MindFlash',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 124, 48, 114),
        ),
      )
    ],
  );
}