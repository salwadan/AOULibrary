import 'package:flutter/material.dart';

class Companyinfo extends StatelessWidget {
  const Companyinfo({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Info"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Image(
                    image: AssetImage("assets/google.png"),
                    fit: BoxFit.contain,
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 2,
                      blurRadius: 6,
                    )
                  ]),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Google",
                      style: TextStyle(fontSize: 34),
                    ),
                    Text(
                      "Jeddah,SA",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      
                      children: [
                        CustomIconStyle(icon: Icons.mail),
                        SizedBox(width: 8,),
                       CustomIconStyle(icon: Icons.phone),
                       SizedBox(width: 8,),
                        CustomIconStyle(icon: Icons.location_on_outlined),

                      ],
                    ),
                    
                  ],
                ),
              ],
            ),
            SizedBox(height: 32,),
            Text("About", style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),),
            SizedBox(height: 8,),
            Text("Lor fgj gyjt dtjyrtrhdge tyjrhtgehrt6 tru5 teue y4u65yt t6jrr rththt hhrth thyty sfrtjy fthrt rhrth rdhtrg htheef ", style: TextStyle(fontSize: 20),)
          ]),
        ),
      ),
    );
  }
}

class CustomIconStyle extends StatelessWidget {
  const CustomIconStyle({
    super.key,
    required this.icon,
  });
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
       
      },
      child: Container(
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 4, 64, 112),
          size: 32,
        ),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 209, 231, 251),
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
