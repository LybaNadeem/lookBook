import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DesignerDetailScreen extends StatefulWidget {
  String? userId;
  int? index;

  DesignerDetailScreen({this.userId,this.index});

  @override
  _DesignerDetailScreenState createState() => _DesignerDetailScreenState();
}

class _DesignerDetailScreenState extends State<DesignerDetailScreen> {
  Map<String, dynamic>? designerData;

  @override
  void initState() {
    super.initState();
    _fetchDesignerData(); // Fetch data when screen is initialized
  }

  Future<void> _fetchDesignerData() async {
    try {
      // Fetch user data from Firestore using userId
      final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        setState(() {
          designerData = doc.data(); // Store fetched data in a state variable
        });
      }
    } catch (error) {
      print("Error fetching designer data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double padding = screenSize.width * 0.05;

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
      body: designerData == null
          ? Center(child: CircularProgressIndicator()) // Show loader until data is fetched
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'DESIGNER',
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
                  width: screenSize.width * 0.9,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(designerData!['profileImage'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                designerData!['fullName'] ?? 'Unknown',
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              SizedBox(height: 20),
              // Contact Info Sections
              _buildContactInfoSection('Phone', designerData!['phone'] ?? '', 'assets/icons/phone.svg'),
              SizedBox(height: 10),
              _buildContactInfoSection('Email', designerData!['email'] ?? '', 'assets/icons/Message.svg'),
              SizedBox(height: 10),
              _buildContactInfoSection('Instagram', designerData!['instagram'] ?? '', 'assets/icons/Instagram.svg'),
              SizedBox(height: 20),
              // Button Section
              Center(
                child: Container(
                  width: screenSize.width * 0.4,
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      // Replace 'actualUserId' with the dynamic user ID
                      _showBlockDialog(context, widget.userId!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Function to show the dialog
  void _showBlockDialog(BuildContext context, String userId) {
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text('Confirmation'),
          content: Text('Are you sure you want to block?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Update the 'block' field in Firestore
                  await FirebaseFirestore.instance
                      .collection('users') // Adjust this collection name based on your database
                      .doc(userId) // Pass the specific user ID
                      .update({'block': true});

                  // Show a success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User has been blocked successfully')),
                  );
                } catch (e) {
                  // Handle errors
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error blocking user: $e')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
