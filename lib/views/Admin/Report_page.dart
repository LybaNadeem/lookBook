import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Report_detail.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          title: Text(
            "LOOK\n      BOOK",
            style: TextStyle(
              fontFamily: 'Agne',
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              Text(
                'REPORT',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontFamily: 'TenorSans',
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              SvgPicture.asset(
                'assets/icons/3.svg',
                height: screenHeight * 0.015,
              ),
              SizedBox(height: screenHeight * 0.02),
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                tabs: [
                  Tab(text: 'Designer'),
                  Tab(text: 'Customer'),
                  Tab(text: 'Product'),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Designer List
                    Center(child: Text('Designer Content')),
                    // Tab 2: Customer Content
                    Center(child: Text('Customer Content')),
                    // Tab 3: Product Content
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products') // Replace 'products' with your collection name
                          .where('report', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No reported products found.'));
                        }

                        final products = snapshot.data!.docs;

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index].data() as Map<String, dynamic>;

                            // Safely handle the `image` field
                            final imageField = product['image'];
                            final imageUrl = (imageField is List && imageField.isNotEmpty)
                                ? imageField.first // Use the first image if it's a list
                                : (imageField is String ? imageField : null); // Use the string or fallback to null

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                                radius: screenWidth * 0.06,
                                child: imageUrl == null ? Icon(Icons.image, color: Colors.grey) : null,
                              ),
                              title: Text(
                                product['DressTitle'] ?? 'Unnamed Product',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(product['description'] ?? ''),
                              trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportDetail(),
                                  ),
                                );
                              },
                            );
                          },
                        );

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
