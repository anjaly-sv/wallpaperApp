import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget TabButtonn(String text, {bool isSelected = false, double bottomPadding = 8.0}) {
  return Padding(
    padding: EdgeInsets.only(left: 6, right: 6, bottom: bottomPadding),
    child: Container(
      height: 40, // Increased height for better visual clarity
      padding: const EdgeInsets.symmetric(horizontal: 12), // Added padding inside the button
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.black, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16, // Adjusted font size
            color: isSelected ? Colors.black : Colors.white, // Text color
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    ),
  );
}
