import 'package:flutter/material.dart';

class Companyinfo extends StatelessWidget {
  //store company information
  final String companyName;
  final String city;
  final String email;
  final String phone;
  final String location;
  final String about;
  final String imageUrl;

  const Companyinfo({
    super.key,
    required this.companyName,
    required this.city,
    required this.email,
    required this.phone,
    required this.location,
    required this.about,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: Image.network(
                    imageUrl,
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
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(companyName, style: TextStyle(fontSize: 34)),
                    Text(city,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700])),
                    SizedBox(height: 8),
                    Row(
                      //Displays icons (email, phone, location) side by side
                      children: [
                        CustomIconStyle(icon: Icons.mail),
                        SizedBox(width: 8),
                        CustomIconStyle(icon: Icons.phone),
                        SizedBox(width: 8),
                        CustomIconStyle(icon: Icons.location_on_outlined),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text("Contact: $phone", style: TextStyle(fontSize: 16)),
                    Text("Location: $location", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 32),
            Text(
                "About", // Displays a header ("About") followed by a description of the company
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Text(about, style: TextStyle(fontSize: 20))
          ]),
        ),
      ),
    );
  }
}

class CustomIconStyle extends StatelessWidget {
  const CustomIconStyle({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        child:
            Icon(icon, color: const Color.fromARGB(255, 4, 64, 112), size: 32),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 209, 231, 251),
            borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
