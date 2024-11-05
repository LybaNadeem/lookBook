import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlockPage extends StatelessWidget {
  final List<Map<String, String>> designers = [
    {'name': 'Robert Fox', 'phone': '+49 40 60774609', 'image': 'assets/images/antwon.jpg'},
    // Add more designers if needed
  ];

  @override
  Widget build(BuildContext context) {
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
          padding: const EdgeInsets.all(16.0), // Padding around the entire content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Block Users',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'TenorSans',
                  letterSpacing: 1.5,
                ),
              ),
             // Space between the title and SVG
              SvgPicture.asset('assets/icons/3.svg', height: 12, width: 12),
              SizedBox(height: 20.0), // Space between the SVG and the TabBar
              // TabBar
              Container(
                color: Colors.grey[100],
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                child: TabBar(
                  labelColor: Colors.orange,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  unselectedLabelStyle: TextStyle(fontSize: 14),
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
              SizedBox(height: 20.0), // Space between the TabBar and content
              // Expanded content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Additional padding for the TabBarView content
                  child: TabBarView(
                    children: [
                      // Designer Tab with card layout
                      ListView.builder(
                        itemCount: designers.length,
                        itemBuilder: (context, index) {
                          final designer = designers[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE5E5), // Light red background
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: AssetImage(designer['image']!),
                                  radius: 30,
                                ),
                                title: Text(
                                  designer['name']!,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(designer['phone']!),
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    // Handle unblock action
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    'UNBLOCK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Customer Tab content
                      Center(child: Text('Customer Content')),
                      // Product Tab content
                      Center(child: Text('Product Content')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
