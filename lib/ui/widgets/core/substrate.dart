import 'package:flutter/cupertino.dart';

class Substrate extends StatelessWidget {
  const Substrate({super.key, required this.child, required this.padding, this.radius,});
  final Widget child;
  final EdgeInsets padding;
  final int? radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Color(0xFF8A8D93).withOpacity(.16),
        borderRadius: BorderRadius.circular(radius?.toDouble() ?? 30),
      ),
      child: child,
    );
  }
}