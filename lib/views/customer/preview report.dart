import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class PreviewReport extends StatefulWidget {
  @override
  _PreviewReportState createState() => _PreviewReportState();
}

class _PreviewReportState extends State<PreviewReport> {
  // Sample product for demonstration
  List<Map<String, String>> products = [
    {
      'image': 'assets/images/product1.png', // Replace with your actual image path
      'title': 'Product Name',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(
            fontFamily: 'Agne',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
              children: [
                // Title: REPORT
                Text(
                  'REPORT',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20), // Add space between the title and the SVG

                // SVG image
                SvgPicture.asset(
                  'assets/icons/3.svg', // Replace with your actual SVG path
                  height: 10,
                  width: 10,
                ),
                SizedBox(height: 20), // Add space between the SVG and the card

                // Card in the center
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      Container(
                        height: 400, // Adjust height as needed
                        width: 400,  // Adjust width as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(products[0]['image']!), // Replace with your actual image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              products[0]['title']!, // Replace with your actual product title
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Price: \$120',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20), // Space between card and TextField

                // TextField for input with multiple lines
                TextField(
                  maxLines: 5, // Allows up to 5 lines of text
                  decoration: InputDecoration(
                    hintText: 'Enter your report...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),

                SizedBox(height: 20), // Space between TextField and Button

                // Elevated Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start of the row
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PreviewReport()),
                        );
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
