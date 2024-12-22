import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(
          'assets/loading.gif', // Добавьте ваш JSON файл анимации
          width: 150,
          height: 150,
        ),
    );
  }
}
