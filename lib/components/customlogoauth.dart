import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          alignment: Alignment.center,
          width: 180,
          height: 180,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(120)),
          child: Image.asset(
            'assets/mylogo.png',
            width: 200,
            height: 200,
            //fit: BoxFit.fill,
          )),
    );
  }
}
