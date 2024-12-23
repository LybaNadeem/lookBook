import 'package:flutter/material.dart';
import '../../components/dot.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "LOOK\n      BOOK",
              style: TextStyle(
                fontFamily: 'Agne',
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'PRODUCT REPORT',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'TenorSans',
                letterSpacing: 1.5,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            // SizedBox to set the specific size for the dotted border container
            SizedBox(
              width: 398,
              height: 399.39,
              child: CustomPaint(
                painter: DottedBorderPainter(color: Colors.redAccent),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/images/haley.jpg'),
                          ),
                          SizedBox(width: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center, // Aligns items vertically centered
                            children: [
                              Text(
                                'Ronald Richards',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8.0), // Adds some space between the name and the profile link
                              GestureDetector(
                                onTap: () {
                                  // Add functionality for "View Profile" tap
                                },
                                child: Text(
                                  'View Profile',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline, // Underlined text
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Adjusts the column size to fit its content
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Set the desired radius
                              child: SizedBox(
                                width: 187,
                                height: 227,
                                child: Image.asset(
                                  'assets/images/product1.png', // Replace with your image path
                                  fit: BoxFit.cover, // Adjusts the image to cover the entire box
                                ),
                              ),
                            ),
                            SizedBox(height: 8), // Adds space between the image and the text
                            Text(
                              '21WN Reversible Ring Cardigan',
                              textAlign: TextAlign.center, // Center the text
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16, // Adjust font size as needed
                              ),
                            ),
                            SizedBox(height: 4), // Adds space between the product name and the price
                            Text(
                              '\$120', // Use \$ to display the dollar sign
                              textAlign: TextAlign.center, // Center the price text
                              style: TextStyle(
                                color:Color(0xFFE47F46),// Change color as needed
                                fontWeight: FontWeight.bold,
                                fontSize: 14, // Adjust font size as needed
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Add more content below if needed
                    ],
                  ),
                ),
              ),
            ),


            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/haley.jpg'),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Ronald Richards',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'View Profile',
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              "This product not right that's why our ability to work effectively and cohesively.",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Aligns the button to the start
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    // Add your onPressed functionality here
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ensures the row only takes as much space as its children
                    children: [
                      Text(
                        'REMOVE PRODUCT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8), // Adds space between the text and the icon
                      SvgPicture.asset(
                        'assets/icons/arrow_icon.svg', // Replace with your SVG icon path
                        height: 18, // Adjust height as needed
                        width: 18, // Adjust width as needed
                        color: Colors.white, // Set the color of the SVG icon
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
