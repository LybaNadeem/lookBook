import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ProductRemove_Screen.dart';

class ProductPage extends StatefulWidget {
  var productId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('products').get();
      final List<Map<String, dynamic>> fetchedProducts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        // Safely handle fields that could be lists
        final image = (data['image'] is List && data['image'].isNotEmpty)
            ? data['image'][0] // Use the first image if it's an array
            : (data['image'] ?? ''); // Use the string or a default value

        return {
          'image': image,
          'DressTitle': data['DressTitle'] ?? 'Untitled',
          'price': data['price'] ?? '0',
        };
      }).toList();

      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? Center(child: Text('No products available'))
          : Padding(
        padding: EdgeInsets.all(0.6),
        child: Column(
          children: [
            // Search Bar
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                filled: true,
                fillColor: const Color(0xFFD9D9D9).withOpacity(0.24),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black.withOpacity(0.50),
                  size: 24,
                ),
                hintText: 'search',
                hintStyle: TextStyle(
                  color: const Color(0xFF8F9098),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            // Product Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: padding,
                  mainAxisSpacing: padding,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductRemoveScreen(
                            productId: product[widget.productId],
                            photographerId: product['photographerId'], // Pass photographerId if available
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(product['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  product['DressTitle'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '\$${product['price']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFFE47F46),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
