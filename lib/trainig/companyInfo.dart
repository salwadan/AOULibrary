
import 'package:flutter/material.dart'; // Importing Flutter's material design package
import 'package:url_launcher/url_launcher.dart';

// Defining a stateless widget named Companyinfo
class Companyinfo extends StatelessWidget {
  final String companyName; // Variable to hold the company name
  final String city; // Variable to hold the city
  final String email; // Variable to hold the email
  final String phone; // Variable to hold the phone number
  final String location; // Variable to hold the location
  final String about; // Variable to hold the about description
  final String imageUrl; // Variable to hold the image URL

  // Constructor for the Companyinfo widget
  const Companyinfo({
    super.key,
    required this.companyName, // Initializing companyName
    required this.city, // Initializing city
    required this.email, // Initializing email
    required this.phone, // Initializing phone
    required this.location, // Initializing location
    required this.about, // Initializing about
    required this.imageUrl, // Initializing imageUrl
  });
  void _launchurl(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(
            uri,
            mode: LaunchMode.inAppWebView,
          );
        } else {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Info"), // Setting the title of the app bar
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligning children to the start
            children: [
              Row(
                children: [
                  Container(
                width: MediaQuery.of(context).size.width * 0.3, // 30% of screen width
                height: MediaQuery.of(context).size.width * 0.3, // Same value for height
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      spreadRadius: 2,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Optional corner radius
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,  // Blur radius of the shadow
                            )
              ),),
              
                  SizedBox(
                      width: 30), // Adding space between the image and the text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligning text to the start
                    children: [
                      Text(companyName,
                          style: TextStyle(
                              fontSize: 34)), // Displaying company name
                      Text(city,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey)), // Displaying city
                      SizedBox(
                          height: 8), // Adding space between text and icons
                      Row(
                        children: [
                          // Email icon

                          InkWell(
                              onTap: () => _launchurl(
                                  Uri.parse('mailto: $email'), false),
                              child: CustomIconStyle(icon: Icons.mail)),
                          SizedBox(width: 8), // Adding space between icons
                          // Phone icon
                          InkWell(
                              onTap: () =>
                                  _launchurl(Uri.parse('tel: $phone'), false),
                              child: CustomIconStyle(icon: Icons.phone)),
                          SizedBox(width: 8), // Adding space between icons
                          // Location icon
                          InkWell(
                              onTap: () =>
                                  _launchurl(Uri.parse(location), false),
                              child: CustomIconStyle(
                                  icon: Icons.location_on_outlined)),
                        ],
                      ),
                    ],),
                    ],
                  ),
                
              
              SizedBox(height: 32), // Adding space before the about section
              Text("About",
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500)), // Displaying "About" title
              SizedBox(height: 8), // Adding space between title and description
              Text(about,
                  style:
                      TextStyle(fontSize: 20)), // Displaying about description
            
          ],),),
        ),
      );
    
  }
}

// Custom widget for displaying icons with specific styling
class CustomIconStyle extends StatelessWidget {
  const CustomIconStyle({super.key, required this.icon});
  final IconData icon; // Variable to hold the icon data

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(icon,
          color: const Color.fromARGB(255, 4, 64, 112),
          size: 32), // Displaying the icon with specific color and size
      height: 48, // Setting the height of the container
      width: 48, // Setting the width of the container
      decoration: BoxDecoration(
        color: Color.fromARGB(
            255, 209, 231, 251), // Background color of the container
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for the container
      ),
    );
  }
}
