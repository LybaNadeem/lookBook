import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Customer_detail.dart';
import 'Designer_detail.dart';

class CustomerPage extends StatelessWidget {
  final List<Map<String, String>> designers = [
    {'name': 'Jhone Lane', 'phone': '+49 40 60774609', 'image': 'assets/images/antwon.jpg'},
    {'name': 'Ronald Richards', 'phone': '+49 40 60774609', 'image': 'assets/images/brooke.jpg'},
    {'name': 'Darlene Robertson', 'phone': '+49 40 60774609', 'image': 'assets/images/haley.jpg'},
    {'name': 'Marvin McKinney', 'phone': '+49 40 60774609', 'image': 'assets/images/marvin.jpg'},
    {'name': 'Savannah Nguyen', 'phone': '+49 40 60774609', 'image': 'assets/images/jake.jpg'},
    {'name': 'Ralph Edwards', 'phone': '+49 40 60774609', 'image': 'assets/images/nathan.jpg'},
    {'name': 'Annette Black', 'phone': '+49 40 60774609', 'image': 'assets/images/jamie.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back on button press
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "LOOK\n      BOOK",
              style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Customers',
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'TenorSans',
                letterSpacing: 1.5,
              ),
            ),
            SvgPicture.asset('assets/icons/3.svg'),
            SizedBox(height: 30.0),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                filled: true,
                fillColor: Color(0xFF8F9FEE).withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              child: ListView.builder(
                itemCount: designers.length,
                itemBuilder: (context, index) {
                  final designer = designers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to the DesignerDetailScreen with the designer's name
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerDetailScreen(
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 90.0,
                        child: Card(
                          shadowColor: Color(0xFFA5B3F6).withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListView.builder(
                            itemCount: designers.length,
                            itemBuilder: (context, index) {
                              final designer = designers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigate to the DesignerDetailScreen with the designer's name
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DesignerDetail(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 90.0,
                                    child: Card(
                                      shadowColor: Color(0xFF8F9CD6).withOpacity(0.05),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.transparent, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(designer['image']!),
                                        ),
                                        title: Text(
                                          '${designer['name']} (Designer)',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          designer['phone']!,
                                          style: TextStyle(
                                            decoration: TextDecoration.underline, // Add underline decoration
                                          ),
                                        ),
                                        trailing: Icon(Icons.arrow_forward, color: Color(0xFFE47F46)),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
