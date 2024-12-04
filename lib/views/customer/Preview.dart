import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'Report.dart'; // Ensure this is imported


class Preview extends StatefulWidget {
  @override
  _PreviewStatefulState createState() => _PreviewStatefulState();
}

class _PreviewStatefulState extends State<Preview> {
  int _currentIndex = 0; // Define the current index for the carousel
  Color _selectedColor = Colors.black; // Default selected color
  String _selectedSize = 'S'; // Default selected size

  final List<String> imageList = [
    'assets/images/product1.png',
    'assets/images/picture2.jpg',
    'assets/images/picture3.jpg',
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
                                  // Show the bottom sheet when the SVG icon is tapped
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 513, // Set the desired fixed height for the bottom sheet
                                        width: double.infinity, // Full width of the screen
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/bottom sheet.svg',
                                                width: 151,
                                                height: 4,
                                              ),
                                            ),
                                            SizedBox(height: 30), // Adjust height to fit image
                                            Center(
                                              child: Image.asset(
                                                'assets/images/Mask group2.png', // Update the path to your image
                                                width: 379, // Set desired width
                                                height: 185, // Set desired height
                                                fit: BoxFit.cover, // Adjust the image fit as needed
                                              ),
                                            ),
                                            SizedBox(height: 20), // Space between the image and text
                                            Text(
                                              'J H O N E',
                                              style: TextStyle(
                                                fontFamily: 'TenorSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 10), // Spacing between the title and the next section
                                            Text(
                                              'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                                              style: TextStyle(
                                                fontFamily: 'TenorSans',
                                                color: Colors.grey.shade700, // Description text color
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 20), // Space before the buttons
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/phone.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  '+49 40 60774609',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset(
                                                  'assets/icons/orange arrow_icon.svg', // Path to the orange arrow icon
                                                  width: 10,
                                                  height: 10,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/Message.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'info@eternal-vitality.de',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset('assets/icons/orange arrow_icon.svg', width: 10, height: 10),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/Instagram.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  '@Instagram/designer',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset('assets/icons/orange arrow_icon.svg', width: 10, height: 10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 513, // Set the desired fixed height for the bottom sheet
                                        width: double.infinity, // Full width of the screen
                                        padding: EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/bottom sheet.svg',
                                                width: 151,
                                                height: 4,
                                              ),
                                            ),
                                            SizedBox(height: 30), // Adjust height to fit image
                                            Center(
                                              child: Image.asset(
                                                'assets/images/Mask group.png', // Update the path to your image
                                                width: 379, // Set desired width
                                                height: 185, // Set desired height
                                                fit: BoxFit.cover, // Adjust the image fit as needed
                                              ),
                                            ),
                                            SizedBox(height: 20), // Space between the image and text
                                            Text(
                                              'L I S A',
                                              style: TextStyle(
                                                fontFamily: 'TenorSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 10), // Spacing between the title and the next section
                                            Text(
                                              'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                                              style: TextStyle(
                                                fontFamily: 'TenorSans',
                                                color: Colors.grey.shade700, // Description text color
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 20), // Space before the buttons
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/phone.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  '+49 40 60774609',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset(
                                                  'assets/icons/orange arrow_icon.svg', // Path to the orange arrow icon
                                                  width: 10,
                                                  height: 10,
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/Message.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'info@eternal-vitality.de',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset('assets/icons/orange arrow_icon.svg', width: 10, height: 10),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/Instagram.svg', // Path to the phone.svg icon
                                                  width: 20, // Adjust the width if needed
                                                  height: 20, // Adjust the height if needed
                                                  // Apply color if needed, or remove this if the SVG already has the desired color
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  '@Instagram/designer',
                                                  style: TextStyle(
                                                    fontFamily: 'TenorSans',
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                SvgPicture.asset('assets/icons/orange arrow_icon.svg', width: 10, height: 10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
                          Container(
                            height:70, // Set the desired height for the Edit button
                            width: 399, // Full width
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add your onPressed logic here
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE47F46), // Button background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80),
                                    // Rounded corners
                                  ),
                                ),
                                child: Text(
                                  "DONE",
                                  style: TextStyle(
                                    fontFamily: 'Outfit_Variable_wght',
                                    color: Colors.white, // Text color
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // Font size for DONE button
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8), // Space between buttons
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start of the row
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Add your onPressed logic here

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
                                        "REPORT",
                                        style: TextStyle(
                                          fontFamily: 'Outfit_Variable_wght',
                                          color: Colors.white, // Text color
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18, // Font size for REPORT button
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      SvgPicture.asset(
                                        // Replace with your actual SVG path
                                        'assets/icons/arrow_icon.svg',
                                        width: 10,
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
}
