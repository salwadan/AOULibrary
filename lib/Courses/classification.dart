import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassificationItem extends StatefulWidget {
final String title;
final List<String> items;

ClassificationItem({required this.title, required this.items});

@override
_ClassificationItemState createState() => _ClassificationItemState();
}

class _ClassificationItemState extends State<ClassificationItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title),
      initiallyExpanded: _isExpanded,
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });
      },
      children: widget.items.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            // Handle actions for each item tap if necessary
            // For example, navigate to a detailed page or show a dialog
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on $item')),
            );
          },
        );
      }).toList(),
    );
  }
}