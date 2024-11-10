import 'package:flutter/material.dart';

class ErrorData extends StatelessWidget {
  const ErrorData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Неизвестная ошибка",
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
