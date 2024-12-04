import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Controllers/Productdetail_controller.dart'; // Import your controller

class CustomerProductreport extends StatefulWidget {
  final String productId; // Accepts product ID

  CustomerProductreport({Key? key, required this.productId}) : super(key: key);

  @override
  _PreviewReportState createState() => _PreviewReportState();
}

class _PreviewReportState extends State<CustomerProductreport> {
  final ProductDetailController controller = ProductDetailController();
  List<String> imageList = [];
  String dressTitle = '';
  String price = '';
  bool isLoading = true;
  bool report = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      await controller.getData(widget.productId);
      if (mounted) {
        setState(() {
          imageList = controller.imageList;
          dressTitle = controller.dressTitle;
          price = controller.price.toString();
          isLoading = false; // Data loaded
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> updateReportField() async {
    try {
      // Update Firestore document
      await FirebaseFirestore.instance
          .collection('products') // Replace with your collection name
          .doc(widget.productId) // Document ID
          .update({'report': true});

      // Update local state
      setState(() {
        report = true;
      });

      // Add a notification to Firestore for admin
      await FirebaseFirestore.instance.collection('notifications').add({
        'title': 'Product Reported',
        'message': 'A product with ID ${widget.productId} has been reported.',
        'timestamp': FieldValue.serverTimestamp(),
        'productId': widget.productId,
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Report submitted successfully in Firebase!")),
      );
    } catch (e) {
      print("Error updating report field: $e");

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit report!")),
      );
    }
  }


  Future<String?> getAdminDeviceToken() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'admin') // Adjust 'role' as per your database schema
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first['deviceToken']; // Get the token from the first admin
      }
    } catch (e) {
      print("Error fetching admin device token: $e");
    }
    return null; // Return null if no admin found or error occurs
  }

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
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // REPORT Title
                Text(
                  'REPORT',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),

                // SVG Icon
                SvgPicture.asset(
                  'assets/icons/3.svg',
                  height: 10,
                  width: 10,
                ),
                SizedBox(height: 20),

                // Product Card
                Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Column(
                    children: [
                      // Product Image
                      Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageList.isNotEmpty
                                ? NetworkImage(imageList[0]) // Use first image
                                : AssetImage('assets/images/placeholder.png')
                            as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Product Details
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dressTitle.isNotEmpty
                                  ? dressTitle
                                  : "Product Title",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Price: ${price.isNotEmpty ? price : "N/A"}',
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

                SizedBox(height: 20),

                // Report Text Field
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter your report...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),

                SizedBox(height: 20),

                // Submit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed:(){
                        getAdminDeviceToken().then((token) {
                          if (token != null) {
                            print('Admin device token: $token');
                            updateReportField();
                          }
                        });
                      } ,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC60D06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "REPORT",
                            style: TextStyle(
                              fontFamily: 'Outfit_Variable_wght',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(
                            'assets/icons/arrow_icon.svg',
                            width: 10,
                            height: 10,
                          ),
                        ],
                      ),
                    )

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