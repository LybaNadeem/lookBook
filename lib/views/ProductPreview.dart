import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../Controllers/product_previewcontroller.dart';

import 'Edit.dart';
import 'HomePage.dart';
import 'PhotographerEditer_screen.dart';
import 'ProductDetail_Designer.dart';

class ProductPreviewStateful extends StatefulWidget {
  var productId;
  var photographerId;

  ProductPreviewStateful({Key? key, required this.productId, required this.photographerId}) : super(key: key);
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
  String instagram = '';
  String linkedin = '';
  String barcode = '';
  String photographerImageUrl='';
  String photographerName = '';
  String photographerAbout = '';
  String photographerEmail = '';
  String photographerPhone = '';
  String photographerSocialLink = '';


  @override
  void initState() {
    super.initState();
    getData();
    // Pass both productId and photographerId
    getPhotographer(widget.productId,widget.photographerId);

    print('productId: ${widget.productId}');
    print('photographerId: ${widget.photographerId}');
  }


  // Function to fetch data from Firebase
  Future<void> getData() async {
    CollectionReference productsRef = FirebaseFirestore.instance.collection('products');

    try {
      DocumentSnapshot productSnapshot = await productsRef.doc(widget.productId).get();

      if (productSnapshot.exists) {
        final productData = productSnapshot.data() as Map<String, dynamic>;
        print('if snapshot exists${productData}');
        print("imageList: ${productData['image']}");
        print("DressTitle: ${productData['DressTitle']}");
        print("projectDescription: ${productData['projectDescription']}");
        print("price: ${productData['price']}");
        print("minimumorder: ${productData['minimumorder']}");
        print("Colors: ${productData['Colors']}");
        print("Sizes: ${productData['Sizes']}");
        print('instagram: ${productData['instagram']}');
        print('linkedin: ${productData['linkedin']}');
        print('barcode: ${productData['barcode']}');

        setState(() {
          imageList = List<String>.from(productData['image'] ?? []);
          dressTitle = productData['DressTitle'] ?? '';
          description = productData['projectDescription'] ?? '';
          instagram = productData['instagram'] ?? '';
          linkedin = productData['linkedin'] ?? '';
          barcode = productData['barcode'] ?? '';

          // Convert `price` to string
          price = productData['price']?.toString() ?? '';

          // Convert `minimumorder` to string
          minimumOrderQuantity = productData['minimumorder']?.toString() ?? '';

          // Convert color codes from string to Color
          colorsList = List<String>.from(productData['Colors'] ?? [])
              .map((colorCode) => Color(int.parse("0xff$colorCode")))
              .toList();

          // Get sizes
          sizesList = List<String>.from(productData['Sizes'] ?? []);
        });
      } else {
        print("No product found with ID: ${widget.productId}");
      }
    } catch (e) {
      print("Error getting data: $e");
    }
  }

  Future<Map<String, dynamic>?> getPhotographer(var productId, var photographerId) async {
    try {
      print("Fetching photographer data from Firestore...");
      final photographerDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .collection('Photographer')
          .doc(photographerId)
          .get();

      if (photographerDoc.exists) {
        print("Photographer data fetched successfully.");
        // Update the state with the fetched photographer data
        setState(() {
          photographerName = photographerDoc.data()?['photographerName'] ?? '';
          photographerImageUrl = photographerDoc.data()?['imageUrl'] ?? '';

        });

        print("Photographer Name: $photographerName");
        print("Photographer Image URL: $photographerImageUrl");
        return photographerDoc.data();
        // Optionally return data
      } else {
        print("No data found for the given photographer ID.");
        return null;
      }
    } catch (e) {
      print("Error fetching photographer data: $e");
      return null;
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
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
                    SizedBox(height: 10),

                    // Minimum Order Quantity and Buttons
                    Text(
                      "Minimum Order Quantity ($minimumOrderQuantity)",
                      style: TextStyle(fontFamily: 'TenorSans', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _launchUrl(instagram),
                        child: Text(
                          "Instagram: $instagram",
                          style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE47F46),
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 8), // Space between the two items
                      GestureDetector(
                        onTap: () => _launchUrl(linkedin),
                        child: Text(
                          "LinkedIn: $linkedin",
                          style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),



                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                      Row(
                      children: [
                      // Circle Avatar
                      CircleAvatar(
                      radius: 25,
                        backgroundImage: photographerImageUrl.isNotEmpty
                            ? NetworkImage(photographerImageUrl)
                            : AssetImage('assets/images/photographer circle.png') as ImageProvider,
                      ),
                      const SizedBox(width: 10), // Add spacing between avatar and text

                      // Photographer Name
                      Text(
                        photographerName,
                        style: const TextStyle(
                          fontFamily: 'TenorSans',
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Adjust size if needed
                        ),
                      ),
                                          ],
                                        ),

                  const SizedBox(height: 10),

                          // View Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EditPhotographer(photographerId:widget.photographerId, productId:widget.productId,)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE47F46),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                            child:Row(
                              mainAxisSize: MainAxisSize.min, // Ensures the row wraps its children
                              children: [

                                // Space between icon and text
                                const Text(
                                  "Edit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8),
                                SvgPicture.asset(
                                  'assets/icons/arrow_icon.svg', // Path to your SVG file
                                  height: 15, // Set the desired height
                                  width: 15,  // Set the desired width
                                ),
                              ],
                            ),

                          ),
                        ],
                      ),
                      const SizedBox(width: 10),

                      // Photographer Name Display

                      const SizedBox(height: 5),
                    ],
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





  Widget actionButtons(double width, bool isPortrait) {
    return Column(
      children: [
        Container(
          height: 58,
          width: width * (isPortrait ? 0.9 : 0.6),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(productId:widget.productId,)));
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
          height: 50,
          width: width * (isPortrait ? 0.9 : 0.6),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to HomePage
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ProductdetailDesigner(productId: widget.productId, photographerId: widget.photographerId,)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
                side: BorderSide(color: Color(0xFFE47F46), width: 1),
              ),
            ),
            child: Text(
              "DONE",
              style: TextStyle(
                color: Color(0xFFE47F46),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),

      ],
    );
  }

}