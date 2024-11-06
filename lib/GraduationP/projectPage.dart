import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class Projectpage extends StatefulWidget {
  const Projectpage({super.key});

  @override
  State<Projectpage> createState() => _ProjectpageState();
}

class _ProjectpageState extends State<Projectpage> {
  List photos = ["assets/chat.png"]; // temporay until firebase done
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Name"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the content
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligning children to the start
            children: [
              Row(children: [
                Expanded(
                  child: Container(
                    height: 150, // Setting the height of the image container
                    width: 150, // Setting the width of the image container
                    child: Image.asset(
                      photos[0], // Displaying the image from the URL
                      fit: BoxFit
                          .fill, // Ensuring the image fits within the container
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
                ),
                SizedBox(
                    width: 30), // Adding space between the image and the text
                Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligning text to the start
                  children: [
                    Text("Aou Library",
                        style:
                            TextStyle(fontSize: 34)), // Displaying company name
                    Text("Asma , Salwa, Njood",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey)), // Displaying city
                    SizedBox(height: 8),
                    // Adding space before the about section
             
                  ],
                ),
              ]),
               SizedBox(height: 32),
               Text("About",
                  style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w500)), // Displaying "About" title
              SizedBox(height: 8), // Adding space between title and description
              Text("DSgfgh drhfth drhyfthtf thftjft ftjfj hrtrd ththdr tfjftht ththd gdh hdthh rdhth dgfhjt",
                  style:
                      TextStyle(fontSize: 20)),
                      SizedBox(height: 20,),
                      AutoSizeText("Programming Language", presetFontSizes: [30 , 40, 50],),
                      AutoSizeText("Flutter, Firebase", presetFontSizes: [18, 20, 25],)
            ],
          ),
        ),
      ),
    );
  }
}
