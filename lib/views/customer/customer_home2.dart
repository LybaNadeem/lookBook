import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Logout.dart';
import '../MessageApp.dart';
import 'Notification.dart';
import 'Preview.dart';
import 'customer profile.dart';

class CustomerHome2 extends StatefulWidget {
  @override
  _CustomerHome2State createState() => _CustomerHome2State();
}

class _CustomerHome2State extends State<CustomerHome2> {
  int _currentIndex = 0;

  final List<Map<String, String>> products = [
    {'image': 'assets/images/image block1.png', 'title': '21WN Reversible Ring Cardigan'},
    {'image': 'assets/images/image block2.png', 'title': '21WN Reversible Ring Cardigan'},
    {'image': 'assets/images/image block1.png', 'title': '21WN Reversible Ring Cardigan'},
    {'image': 'assets/images/image block2.png', 'title': '21WN Reversible Ring Cardigan'},
    {'image': 'assets/images/image block1.png', 'title': '21WN Reversible Ring Cardigan'},
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessagesApp(id: '',)),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileCustomerScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
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
                suffixIcon: IconButton(
                  icon: SvgPicture.asset('assets/icons/filter.svg'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          height: 524,
                          width: 430,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/bottom sheet.svg',
                                width: 151,
                                height: 4,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),

            // Single Scrollable Area for Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'UK FASHION SHOW',
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/icons/3.svg',
                      width: 10,
                      height: 10,
                    ),
                    SizedBox(height: 10),

                    // Product Grid 1
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Preview(),
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
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(products[index]['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        products[index]['title']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                         fontFamily: 'TenorSans',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$120',
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

                    SizedBox(height: 30), // Space between sections

                    Text(
                      'TEAR SHOW',
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    SvgPicture.asset(
                      'assets/icons/3.svg',
                      width: 10,
                      height: 10,
                    ),
                    SizedBox(height: 10),

                    // Product Grid 2
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Preview(),
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
                                  width: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(products[index]['image']!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        products[index]['title']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'TenorSans',
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$120',
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
                  ],
                ),



              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            selectedItemColor: Color(0xFFE47F46),
            unselectedItemColor: Colors.grey,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/Home.svg',
                  width: 30,
                  height: 15,
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
                icon: SizedBox(width: 0),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/notification-bing.svg',
                  width: 30,
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

          Positioned(
            bottom: 20,
            left: 0,
            right: 0,

              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/barcode.svg',
                  width: 83,
                  height: 83,
                ),
              ),

          ),
        ],
      ),
    );
  }
}