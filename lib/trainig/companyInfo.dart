
import 'package:auto_size_text/auto_size_text.dart';
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
     var screenHeight = MediaQuery.of(context).size.height;
    var screenWiidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Company Info",
          presetFontSizes: [screenWiidth >= 700? 30 : 25],
        ), // Setting the title of the app bar
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
                   border: Border.all(color: Colors.black26, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      spreadRadius: 2,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // Optional corner radius
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,  // Blur radius of the shadow
                            )
              ),),
              
                  SizedBox(
                      width: 30), // Adding space between the image and the text
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Aligning text to the start
                    children: [
                      AutoSizeText(companyName,
                          presetFontSizes: [screenWiidth >= 700? 50 : 25], style: TextStyle(fontWeight: FontWeight.bold)), // Displaying company name
                      AutoSizeText(city,
                        presetFontSizes: [screenWiidth >= 700? 30 : 15],
                          style: TextStyle(
                              
                              fontWeight: FontWeight.w400,
                              color:  Color(0xFF2196F3),)), // Displaying city
                      SizedBox(
                          height: 8), // Adding space between text and icons
                      Row(
                        children: [
                          // Email icon

                          InkWell(
                              onTap: () => _launchurl(
                                  Uri.parse('mailto: $email'), false),
                              child: CustomIconStyle(icon: Icons.mail, )),
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
              AutoSizeText("About",
                presetFontSizes:[screenWiidth >= 700? 50 : 35],
                  style: TextStyle(
                      
                      fontWeight: FontWeight.w500)), // Displaying "About" title
              SizedBox(height: 8), // Adding space between title and description
              AutoSizeText(about,
                    presetFontSizes: [screenWiidth >= 700? 40 : 20],), // Displaying about description
            
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
     var screenWiidth = MediaQuery.of(context).size.width;
    return Container(
      child: Icon(icon,
          color: const Color.fromARGB(255, 4, 64, 112),
          size: screenWiidth >= 700? 54: 32,), // Displaying the icon with specific color and size
      height: screenWiidth >= 700? 70: 48, // Setting the height of the container
      width: screenWiidth >= 700? 70: 48, // Setting the width of the container
      decoration: BoxDecoration(
        color: Color.fromARGB(
            255, 209, 231, 251), // Background color of the container
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for the container
      ),
    );
  }
}
