import 'package:flutter/material.dart'; // Import Flutter material design package for UI components.

class ClassificationItem extends StatelessWidget { // Define a stateless widget for each classification item.
  final String title; // Declare a variable to hold the title of the classification item.
  final List<String> items; // Declare a variable to hold the list of items associated with the classification.
  final void Function(String)? onItemTap; // Declare a callback function for handling item tap actions. The callback takes a String as an argument and is optional.

  ClassificationItem({  // Constructor to initialize the widget's properties.
    required this.title,  // The title is required.
    required this.items,  // The list of items is required.
    this.onItemTap,  // The callback is optional.
  });

  @override
  Widget build(BuildContext context) { // Override the build method to construct the widget's UI.
    return Card(  // Use a Card widget to provide a material design style for the item.
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),  // Set the margin around the card for spacing between other widgets.
      child: ExpansionTile(  // Use ExpansionTile to create a collapsible list with a title and children.
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),  // Set the title of the expansion tile with bold text style.
        children: items.map((item) {  // Iterate over the list of items and generate a ListTile for each one.
          return ListTile(  // Use ListTile widget to represent each item as a tappable element.
            title: Text(item),  // Display the item as the title in the ListTile.
            onTap: () {  // Define the behavior when a ListTile is tapped.
              if (onItemTap != null) {  // Check if the onItemTap callback is provided (not null).
                onItemTap!(item);  // Call the onItemTap function with the tapped item as an argument.
              }
            },
          );
        }).toList(),  // Convert the list of ListTile widgets into a list and pass it to the children of the ExpansionTile.
      ),
    );
  }
}

