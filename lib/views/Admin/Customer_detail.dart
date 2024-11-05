import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerDetailScreen extends StatefulWidget {
  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Color cancelButtonColor = Colors.white; // Default color for Cancel button
  Color confirmButtonColor = Colors.white; // Default color for Confirm button

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.05; // 5% of screen width for padding

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Agne',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'CUSTOMER',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'TenorSans',
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Center(child: SvgPicture.asset('assets/icons/3.svg')),
              SizedBox(height: 40),
              Center(
                child: Container(
                  width: screenSize.width * 0.9, // 90% of screen width
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/images/Mask group.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'R O B E R T',
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              Text(
                'We work with monitoring programmes to ensure compliance with safety, health and quality standards for our products.',
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  color: Colors.grey.shade700,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              // Phone Row
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phone Section
                  _buildContactInfoSection('Phone', '+49 40 60774609', 'assets/icons/phone.svg'),
                  SizedBox(height: 10),

                  // Email Section
                  _buildContactInfoSection('Email', 'info@eternal-vitality.de', 'assets/icons/Message.svg'),
                  SizedBox(height: 10),

                  // Instagram Section
                  _buildContactInfoSection('Instagram', '@Instagram/designer', 'assets/icons/Instagram.svg'),
                  SizedBox(height: 20),
                ],
              ),
              // Button Section wrapped in a container for better layout
              Row(
                children: [
                  Center(
                    child: Container(
                      width: screenSize.width * 0.4, // 50% of screen width
                      height: 42,
                      child: ElevatedButton(
                        onPressed: () {
                          _showBlockDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'BLOCK',
                              style: TextStyle(
                                fontFamily: 'TenorSans',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 25),
                            SvgPicture.asset(
                              'assets/icons/arrow_icon.svg',
                              width: 10,
                              height: 10,
                            ),
                            SizedBox(width: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build contact info sections
  Widget _buildContactInfoSection(String title, String info, String iconPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'TenorSans',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
            SizedBox(width: 8),
            Text(
              info,
              style: TextStyle(
                fontFamily: 'TenorSans',
                fontSize: 14,
                color: Colors.grey.shade700,
                overflow: TextOverflow.ellipsis, // Handle overflow
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/orange arrow_icon.svg',
              width: 10,
              height: 10,
            ),
          ],
        ),
      ],
    );
  }

  // Function to show the dialog
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
