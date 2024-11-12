import 'package:flutter/material.dart';

class ClassificationItem extends StatelessWidget {
  final String title;
  final List<String> items;
  final void Function(String)? onItemTap;

  ClassificationItem({
    required this.title,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ExpansionTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        children: items.map((item) {
          return ListTile(
            title: Text(item),
            onTap: () {
              if (onItemTap != null) {
                onItemTap!(item); // Calls the _launchURL function on tap
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
