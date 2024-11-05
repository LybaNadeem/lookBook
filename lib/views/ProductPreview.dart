import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Controllers/product_previewcontroller.dart';
import '../components/CustomButton.dart';
import 'Edit.dart';

class ProductPreviewStateful extends StatefulWidget {
  @override
  _ProductPreviewStatefulState createState() => _ProductPreviewStatefulState();
}

class _ProductPreviewStatefulState extends State<ProductPreviewStateful> {
  final ProductPreviewController controller = ProductPreviewController();
  int _currentIndex = 0;
  Color _selectedColor = Colors.black;
  String _selectedSize = 'S';
  List<String> imageList = [];
  List<Color> colorsList = [];
  List<String> sizesList = [];
  String dressTitle = '';
  String description = '';
  String price = '';
  String minimumOrderQuantity = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  // Function to fetch data from Firebase
  Future<void> getData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    CollectionReference productsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('products');

    try {
      QuerySnapshot querySnapshot = await productsRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      setState(() {
        if (allData.isNotEmpty) {
          final productData = allData[0];
          imageList = List<String>.from(productData['image'] ?? []);
          dressTitle = productData['DressTitle'] ?? '';
          description = productData['projectDescription'] ?? '';
          price = productData['price'] ?? '';
          minimumOrderQuantity = productData['minimumorder'] ?? '';

          // Convert color codes from string to Color
          colorsList = List<String>.from(productData['Colors'] ?? [])
              .map((colorCode) => Color(int.parse("0xff$colorCode")))
              .toList();

          // Get sizes
          sizesList = List<String>.from(productData['Sizes'] ?? []);
        }
      });
    } catch (e) {
      print("Error getting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isPortrait ? 16.0 : width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  imageList.isNotEmpty
                      ? CarouselSlider(
                    items: imageList.map((imageUrl) {
                      return Container(
                        width: isPortrait ? width * 0.9 : width * 0.6,
                        height: isPortrait ? height * 0.5 : height * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: isPortrait ? height * 0.5 : height * 0.4,
                      autoPlay: true,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  )
                      : Center(child: CircularProgressIndicator()),
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        int index = entry.key;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: isPortrait ? 16.0 : 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dressTitle,
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        fontWeight: FontWeight.bold,
                        fontSize: isPortrait ? 22 : 18,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 16.0 : 8.0),
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        color: Colors.grey[700],
                        fontSize: isPortrait ? 16 : 14,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 16.0 : 8.0),
                    Text(
                      "\$$price",
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        color: Color(0xFFE47F46),
                        fontWeight: FontWeight.bold,
                        fontSize: isPortrait ? 20 : 16,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 16.0 : 8.0),

                    // Color and Size Selection
                    Row(
                      children: [
                        Text(
                          "Color",
                          style: TextStyle(fontFamily: 'TenorSans'),
                        ),
                        SizedBox(width: 16),
                        // Display available colors
                        Row(
                          children: colorsList.map((color) => buildColorOption(color)).toList(),
                        ),
                        Spacer(),
                        Text(
                          "Size",
                          style: TextStyle(fontFamily: 'TenorSans'),
                        ),
                        SizedBox(width: 8),
                        // Display available sizes
                        Row(
                          children: sizesList.map((size) => buildSizeOption(size)).toList(),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Photographer Info and Actions
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/photographer circle.png'),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PHOTOGRAPHER NAME (LISA)",
                              style: TextStyle(fontFamily: 'TenorSans', fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            viewButton(context),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Minimum Order Quantity and Buttons
                    Text(
                      "Minimum Order Quantity ($minimumOrderQuantity)",
                      style: TextStyle(fontFamily: 'TenorSans', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    actionButtons(width, isPortrait),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = color;
        });
      },
      child: Container(
        width: 22.24,
        height: 22.24,
        margin: EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _selectedColor == color ? Colors.grey : Colors.transparent, width: 2),
          color: color,
        ),
      ),
    );
  }

  Widget buildSizeOption(String size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: CircleAvatar(
        backgroundColor: _selectedSize == size ? Colors.black : Colors.transparent,
        radius: 15,
        child: Text(
          size,
          style: TextStyle(
            fontFamily: 'TenorSans',
            fontWeight: FontWeight.bold,
            color: _selectedSize == size ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget viewButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 513,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other Bottom Sheet Content
                ],
              ),
            );
          },
        );
      },
      child: Container(
        height: 30,
        width: 110,
        decoration: BoxDecoration(
          color: Color(0xFFE47F46),
          borderRadius: BorderRadius.circular(80),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "VIEW",
              style: TextStyle(
                fontFamily: 'TenorSans',
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset('assets/icons/arrow_icon.svg', width: 10, height: 10),
          ],
        ),
      ),
    );
  }

  Widget actionButtons(double width, bool isPortrait) {
    return Column(
      children: [
        Container(
          height: 58,
          width: width * (isPortrait ? 0.9 : 0.6),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Edit()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE47F46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("EDIT", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Spacer(),
                SvgPicture.asset('assets/icons/edit.svg', width: 20, height: 20),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 80,
          width: width * (isPortrait ? 0.9 : 0.6),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
                side: BorderSide(color: Color(0xFFE47F46), width: 1),
              ),
            ),
            child: Text(
              "DONE",
              style: TextStyle(color: Color(0xFFE47F46), fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}