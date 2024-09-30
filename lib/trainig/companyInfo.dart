import 'package:flutter/material.dart'; // Importing Flutter's material design package

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
                    height: 150, // Setting the height of the image container
                    width: 150, // Setting the width of the image container
                    child: Image.network(
                      imageUrl, // Displaying the image from the URL
                      fit: BoxFit
                          .contain, // Ensuring the image fits within the container
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue, // Shadow color
                          spreadRadius: 2, // Spread radius of the shadow
                          blurRadius: 6, // Blur radius of the shadow
                        )
                      ],
                    ),
                  ),
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
                          CustomIconStyle(icon: Icons.mail),
                          SizedBox(width: 8), // Adding space between icons
                          // Phone icon
                          CustomIconStyle(icon: Icons.phone),
                          SizedBox(width: 8), // Adding space between icons
                          // Location icon
                          CustomIconStyle(icon: Icons.location_on_outlined),
                        ],
                      ),
                      SizedBox(
                          height: 8), // Adding space between icons and text
                      // Display email
                      Text("Email: $email", style: TextStyle(fontSize: 16)),
                      // Display phone
                      Text("Contact: $phone", style: TextStyle(fontSize: 16)),
                      // Display location
                      Text("Location: $location",
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
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
            ],
          ),
        ),
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
