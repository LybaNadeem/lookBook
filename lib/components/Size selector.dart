import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  final TextEditingController controller;

  SizeSelector({Key? key, required this.controller}) : super(key: key);

  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String selectedSize = ''; // Initialize as empty

  // List of available sizes
  final List<String> sizes = ['S', 'M', 'L'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 2),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Center the size boxes
          children: sizes.map((size) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedSize = size;
                  widget.controller.text = size; // Update the controller with the selected size
                });
              },
              child: Container(
                width: 30, // Set box width
                height: 30, // Set box height
                margin: EdgeInsets.symmetric(horizontal: 10), // Adds space between boxes
                decoration: BoxDecoration(
                  color: selectedSize == size ? Colors.black : Colors.white, // Change background color based on selection
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selectedSize == size ? Colors.black : Colors.grey, // Border color
                  ),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 18,
                      color: selectedSize == size ? Colors.white : Colors.black, // Text color based on selection
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}