import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final Color? buttonColor;
  const CustomButtonAuth({
    super.key,
    this.onPressed,
    required this.title,
    this.buttonColor = const Color.fromARGB(255, 4, 6, 93),
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 40,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: buttonColor,
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
