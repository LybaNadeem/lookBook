import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/views/Admin/Designer_detail.dart';
import 'package:untitled/views/customer/preview%20report.dart';

import 'Customer_detail.dart';
// Ensure this is imported


class ProductDetail extends StatefulWidget {

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Color cancelButtonColor = Colors.white; // Default color for Cancel button
  Color confirmButtonColor = Colors.white;

  int _currentIndex = 0; // Define the current index for the carousel
  Color _selectedColor = Colors.black; // Default selected color
  String _selectedSize = 'S'; // Default selected size

  final List<String> imageList = [
    'assets/images/picture 1.png',
    'assets/images/picture 2.png',
    'assets/images/picture 3.png',
  ];

  // Dots Indicator
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("LOOK\n      BOOK",
            style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel with Dots
            Stack(
              alignment: Alignment.center,
              children: [
                // Image Carousel
                CarouselSlider(
                  items: imageList.map((imagePath) {
                    return Container(
                      width: 398,
                      height: 533,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 533,
                    autoPlay: true,
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex =
                            index; // Update current index on page change
                      });
                    },
                  ),
                ),
                // Dot indicators
                Positioned(
                  bottom: 1, // Adjust the position of the dots
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageList.asMap().entries.map((entry) {
                      int index = entry.key;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentIndex =
                                index; // Update the current index on tap
                          });
                        },
                        child: Container(
                          width: 8.0,
                          height: 15.0,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.white // Highlight current index
                                : Colors.grey.withOpacity(0.5), // Other dots
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MOHAN (DRESS)",
                    style: TextStyle(
                        fontFamily: 'TenorSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Recycle Boucle Knit Cardigan Pink",
                    style: TextStyle(
                        fontFamily: 'TenorSans', color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$120",
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      color: Color(0xFFE47F46),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Color and Size Selection
                  Row(
                    children: [
                      Text(
                        "Color",
                        style: TextStyle(
                          fontFamily: 'TenorSans',
                        ),
                      ),
                      SizedBox(width: 16),
                      // Color selection with GestureDetector
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor =
                                Colors.black; // Change to black when tapped
                          });
                        },
                        child: Container(
                          width: 22.24,
                          height: 22.24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == Colors.black
                                  ? Colors.grey
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor =
                                Colors.orange; // Change to orange when tapped
                          });
                        },
                        child: Container(
                          width: 22.24,
                          height: 22.24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == Colors.orange
                                  ? Colors.grey
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: Color(0xFFE47F46),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor =
                                Colors.grey; // Change to grey when tapped
                          });
                        },
                        child: Container(
                          width: 22.24,
                          height: 22.24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == Colors.grey
                                  ? Colors.grey
                                  : Colors.transparent,
                              width: 2,
                            ),
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 35), // Gap between color and size
                      Text(
                        "Size",
                        style: TextStyle(
                          fontFamily: 'TenorSans',
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSize = 'S'; // Change to size S when tapped
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: _selectedSize == 'S'
                              ? Colors.black
                              : Colors
                              .transparent, // Background color change on selection
                          radius: 15, // Adjust the size of the circle
                          child: Text(
                            "S",
                            style: TextStyle(
                              fontFamily: 'TenorSans',
                              fontWeight: FontWeight.bold,
                              color: _selectedSize == 'S'
                                  ? Colors.white
                                  : Colors
                                  .black, // Text color change on selection
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Designer and Custom Button
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/Designer circle.png'), // Photographer Image
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "DESIGNER NAME (JHONE)",
                                style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => DesignerDetailScreen ()),
                                  );
                                },

                                child: Container(
                                  height: 30, // Set your desired height
                                  width: 110, // Set your desired width
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE47F46), // Orange background color
                                    borderRadius: BorderRadius.circular(80), // Rounded corners
                                  ),
                                  alignment: Alignment.center, // Center text inside the button
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center both text and icon
                                    children: [
                                      Text(
                                        "VIEW",
                                        style: TextStyle(
                                          fontFamily: 'TenorSans',
                                          color: Colors.white, // White text color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 8), // Space between text and icon
                                      SvgPicture.asset(
                                        'assets/icons/arrow_icon.svg', // Path to the SVG icon
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height:10,),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                                'assets/images/photographer circle.png'), // Photographer Image
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "PHOTOGRAPHER NAME (LISA)",
                                style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              InkWell(
                                onTap: () {

                                  // Show the bottom sheet when the SVG icon is tapped

                                },

                                child: Container(
                                  height: 30, // Set your desired height
                                  width: 110, // Set your desired width
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE47F46), // Orange background color
                                    borderRadius: BorderRadius.circular(80), // Rounded corners
                                  ),
                                  alignment: Alignment.center, // Center text inside the button
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center, // Center both text and icon
                                    children: [
                                      Text(
                                        "VIEW",
                                        style: TextStyle(
                                          fontFamily: 'TenorSans',
                                          color: Colors.white, // White text color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 8), // Space between text and icon
                                      SvgPicture.asset(
                                        'assets/icons/arrow_icon.svg', // Path to the SVG icon
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Minimum Order Quantity
                      Text(
                        "Minimum Order Quantity (150)",
                        style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 8),

                      // Buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Makes the buttons take full width
                        children: [
                          // Full width// Space between buttons
                          Container(
                            height:59 ,
                            width: 399,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start of the row
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add your onPressed logic here
                                      _showBlockDialog(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFC60D06), // Button background color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(80), // Rounded corners
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // Ensures button takes only needed width
                                      children: [ // Space between icon and text
                                        Text(
                                          "REMOVE",
                                          style: TextStyle(
                                            fontFamily: 'Outfit_Variable_wght',
                                            color: Colors.white, // Text color
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18, // Font size for REPORT button
                                          ),
                                        ),
                                        SizedBox(width:220),
                                        SvgPicture.asset(
                                          // Replace with your actual SVG path
                                          'assets/icons/delete.svg',
                                          width: 15,
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showBlockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text(
            'Confirmation',
            style: TextStyle(
              fontFamily: 'TenorSans',
              fontSize: 18,
            ),
          ),
          content: Text(
            'Are you sure you want to block?',
            style: TextStyle(
              fontFamily: 'TenorSans',
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      cancelButtonColor = Colors.black; // Change to black on tap
                      confirmButtonColor = Colors.white; // Keep confirm button white
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: cancelButtonColor,
                      borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                      border: Border.all(
                        color: Colors.grey, // Set your desired border color here
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: cancelButtonColor == Colors.black ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      confirmButtonColor = Colors.black; // Change to black on tap
                      cancelButtonColor = Colors.white; // Keep cancel button white
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: confirmButtonColor,
                      borderRadius: BorderRadius.circular(8), // Slightly rounded corners
                      border: Border.all(
                        color: Colors.grey, // Set your desired border color here
                        width: 1, // Adjust the border width if needed
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: confirmButtonColor == Colors.black ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
