import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../Controllers/Chat_controller.dart';
import '../../Controllers/Productdetail_controller.dart';



class ProductRemoveScreen extends StatefulWidget {
var productId;
var photographerId;

  ProductRemoveScreen({Key? key, required this.productId, this.photographerId})
      : super(key: key);

  @override
  _ProductRemoveScreenState createState() => _ProductRemoveScreenState();
}

class _ProductRemoveScreenState extends State<ProductRemoveScreen> {
  final ProductDetailController controller = ProductDetailController();
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
  String photographerName = '';
  String photographerImageUrl = '';
  String photographerEmail = '';
  String photographerPhone = '';
  String photographerSocialLink = '';

  @override
  void initState() {
    super.initState();

    // Ensure data fetching is awaited
    getData();

  }

  Future<void> getData() async {
    if (widget.productId == null) {
      print('Invalid productId error');
      return;
    }
    await controller.getData(widget.productId);
    if (mounted) {
      setState(() {
        imageList = controller.imageList;
        dressTitle = controller.dressTitle;
        description = controller.description;
        price = controller.price.toString();
        colorsList = controller.colorsList;
        sizesList = controller.sizesList;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
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
          padding:
          EdgeInsets.symmetric(horizontal: isPortrait ? 16.0 : width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  imageList.isNotEmpty
                      ? CarouselSlider(
                    items: imageList.map((imageUrl) {
                      return GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: isPortrait ? width * 0.9 : width * 0.6,
                          height:
                          isPortrait ? height * 0.5 : height * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
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
                padding:
                EdgeInsets.symmetric(vertical: isPortrait ? 16.0 : 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.dressTitle.isNotEmpty
                          ? controller.dressTitle
                          : "Loading...",
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),

                    SizedBox(height: isPortrait ? 16.0 : 8.0),
                    Text(
                      controller.description.isNotEmpty
                          ? controller.description
                          : "Loading description...",
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: isPortrait ? 16.0 : 8.0),
                    Text(
                      "\$${controller.price.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        color: Color(0xFFE47F46),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
                          children: colorsList
                              .map((color) => buildColorOption(color))
                              .toList(),
                        ),
                        Spacer(),
                        Text(
                          "Size",
                          style: TextStyle(fontFamily: 'TenorSans'),
                        ),
                        SizedBox(width: 8),
                        // Display available sizes
                        Row(
                          children: sizesList
                              .map((size) => buildSizeOption(size))
                              .toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Minimum Order Quantity ($minimumOrderQuantity)",
                      style: TextStyle(
                          fontFamily: 'TenorSans', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
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
                            Container(
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

                          ],
                        ),
                      ],
                    ),


                    // Minimum Order Quantity and Buttons

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
          border: Border.all(
              color: _selectedColor == color ? Colors.grey : Colors.transparent,
              width: 2),
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
        backgroundColor:
        _selectedSize == size ? Colors.black : Colors.transparent,
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

// Bottom Buttons UI Section
  Widget actionButtons(double width, bool isPortrait) {
    return Column(
      children: [
        SizedBox(height: 20), // Add spacing between sections

        Row(
          children: [
            // "REMOVE FROM HOME" Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE47F46), // Orange background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "REMOVE FROM HOME",
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10), // Spacing between buttons


      ],
    );
  }
}
