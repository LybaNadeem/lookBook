import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/views/Admin/Block_page.dart';

import '../Logout.dart';
import '../MessageApp.dart';
import '../customer/customer profile.dart';
import 'Converstaions.dart';
import 'Customer_page.dart';
import 'Designer_Page.dart';
import 'Product_page.dart';
import 'Report_page.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<Map<String, dynamic>> dashboardItems = [
    {'title': 'Designers', 'iconPath': 'assets/icons/Admin_designer.svg'},
    {'title': 'Customers', 'iconPath': 'assets/icons/Admin_customer.svg'},
    {'title': 'Products', 'iconPath': 'assets/icons/Admin_product.svg'},
    {'title': 'Reports', 'iconPath': 'assets/icons/Admin_report.svg'},
    {'title': 'Conversations', 'iconPath': 'assets/icons/conversations.svg'},
    {'title': 'Blocked Users', 'iconPath': 'assets/icons/Admin_block.svg'},
  ];

  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 3) {
      // Navigate to the ReportPage and trigger a notification
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportPage()),
      );

    } else if (index == 1) {
      // Navigate to MessagesApp
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagesApp(id: ''), // Pass appropriate ID
        ),
      );
    } else {
      print("Other tab selected: $index");
    }
  }




  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05; // Adjust padding based on screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LogoutPage()),
              );
            },
          ),
        ),
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Agne',
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Admin Dashboard',
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: dashboardItems.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[50],
                    margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(padding),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          leading: dashboardItems[index]['iconPath'] != null
                              ? SvgPicture.asset(
                            dashboardItems[index]['iconPath'],
                            width: 60,
                            height: 60,
                          )
                              : Icon(Icons.image_not_supported,
                              size: 40, color: Colors.grey),
                          title: Text(
                            dashboardItems[index]['title'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            if (index == 0) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DesignersPage()),
                              );
                            } else if (index == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerPage()),
                              );
                            } else if (index == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage()),
                              );
                            } else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportPage()),
                              );
                            } else if (index == 4) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Converstaions()),
                              );
                            } else if (index == 5) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BlockPage()),
                              );
                            }
                          },
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFE47F46),
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Home.svg',
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/chat.svg',
              width: 24,
              height: 24,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/notification-bing.svg',
              width: 24,
              height: 24,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}



