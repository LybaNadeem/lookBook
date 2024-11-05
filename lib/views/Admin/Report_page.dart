import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'Report_detail.dart';

class ReportPage extends StatelessWidget {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
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
                style: TextStyle(
                  fontFamily: 'Agne',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.05, // Responsive font size
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'REPORT',
                style: TextStyle(
                  fontSize: screenWidth * 0.06, // Responsive font size
                  fontFamily: 'TenorSans',
                  letterSpacing: 1.5,
                ),
              ),
            // Responsive spacing
              SvgPicture.asset(
                'assets/icons/3.svg',
                height: screenHeight * 0.015, // Responsive SVG size
                width: screenWidth * 0.005,
              ),
              SizedBox(height: screenHeight * 0.03), // Responsive spacing
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
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              // TabBar
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.005,
                ),
                child: TabBar(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04, // Responsive font size
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: screenWidth * 0.035, // Responsive font size
                  ),
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
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: 'Designer'),
                    Tab(text: 'Customer'),
                    Tab(text: 'Product'),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              // Expanded ListView
              Expanded(
                child: TabBarView(
                  children: [
                    // Tab 1: Designer List
                    ListView.builder(
                      itemCount: designers.length,
                      itemBuilder: (context, index) {
                        final designer = designers[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005, // Responsive spacing
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the ReportDetail screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportDetail(),
                                ),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.1, // Responsive height
                              child: Card(
                                shadowColor: Color(0xFFA5B3F6).withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.transparent, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(designer['image']!),
                                    radius: screenWidth * 0.06, // Responsive radius
                                  ),
                                  title: Text(
                                    '${designer['name']} (Designer)',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(designer['phone']!),
                                  trailing: Icon(Icons.arrow_forward, color: Colors.orange),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // Tab 2: Customer Content
                    Center(child: Text('Customer Content')),
                    // Tab 3: Product Content
                    Center(child: Text('Product Content')),
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
