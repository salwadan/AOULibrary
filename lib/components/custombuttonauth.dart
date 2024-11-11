import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final String title;
  final Color buttonColor;
  final VoidCallback onPressed;
  final double? width; // Optional width parameter

  const CustomButtonAuth({
    Key? key,
    required this.title,
    required this.buttonColor,
    required this.onPressed,
    this.width, // Initialize the optional width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 200, // Default width if not provided
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
