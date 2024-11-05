import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/views/customer/customer%20profile.dart';

import '../Logout.dart';
import '../MessageApp.dart';
import '../ProfileScreen.dart';
import 'Notification.dart';
import 'customer_home2.dart';

class CustomerHomePage extends StatefulWidget {
  @override
  _CustomerHomePageState createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _currentIndex = 0;
  bool showCalendar = false;
  String displayText = 'Islamabad'; // Default event text
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();

  // Method to handle tab tap
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessagesApp()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerHome2()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NotificationScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CustomerProfileScreen()),
      );
    }
  }

  Widget _buildCalendar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9).withOpacity(0.24),
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.white,
              width: 1.0,
            ),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: focusedDate,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
                focusedDate = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Color(0xFFE47F46),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon:
              const Icon(Icons.chevron_left, color: Colors.grey),
              rightChevronIcon:
              const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.75,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/bottom sheet.svg',
                      width: 151,
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 220,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  showCalendar = false;
                                  displayText = 'Islamabad'; // Set text for event
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    'Events',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  showCalendar = true;
                                });
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFD9D9D9).withOpacity(0.24),
                                ),
                                child: Center(
                                  child: Text(
                                    'Date',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Display either the event text or calendar based on selection
                    if (!showCalendar)
                      Column(
                        children: [
                          Text(
                            displayText,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Add your event button functionality here
                            },
                            child: Text('Add Event'),
                          ),
                        ],
                      ),
                    if (showCalendar) _buildCalendar(),
                    if (showCalendar)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CustomerHome2()), // Ensure you have imported CustomerHome2
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE47F46),
                          foregroundColor: Colors.white, // Text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        child: Text('Find Result'),
                      ),


                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
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
                    onPressed: _showFilterOptions,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No products to show",
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 60), // Space between title and icon
                  SvgPicture.asset(
                    'assets/icons/cart.svg', // Path to your cart icon
                    width: 60,
                    height: 60,
                  ),
                  SizedBox(height: 50), // Space between the cart icon and black container

                  // First (Black) Container with text and SVG icons
                  Stack(
                    children: [
                      Container(
                        color: Colors.black, // Set the color to black
                        height: 296, // Adjust the height of the container
                        width: 500, // Adjust the width of the container
                      ),
                      Positioned(
                        top: 20, // Position the "LOOK BOOK" text closer to the top
                        left: 0,
                        right: 0,
                        child: Text(
                          "LOOK\n      BOOK",
                          style: TextStyle(
                            fontFamily: 'Agne',
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Set text color to white for visibility
                            fontSize: 24, // Adjust the font size
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ),
                      Positioned(
                        top: 120, // Position this text below the "LOOK BOOK" text
                        left: 40,
                        right: 40,
                        child: Text(
                          "Making a luxurious lifestyle accessible for a generous group of women is our daily drive.",
                          style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontWeight: FontWeight.normal,
                            color: Colors.white.withOpacity(0.7), // Slightly transparent white for softer look
                            fontSize: 16, // Adjust font size as necessary
                          ),
                          textAlign: TextAlign.center, // Center align the text
                        ),
                      ),
                      Positioned(
                        top: 190, // Position the SVG icons below the text
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the SVG icons
                          children: [
                            SvgPicture.asset(
                              'assets/icons/3.svg',
                              width: 15,
                              height: 15,
                            ),
                            SizedBox(height: 10), // Space between the two SVGs
                            SvgPicture.asset(
                              'assets/icons/doodle.svg',
                              width: 76,
                              height: 45,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Add a small gap between the black and white containers

                  // Second (White) Container with Group 29.svg
                  Column(
                    children: [
                      // Existing Container
                      Container(
                        color: Colors.white, // Set the color to white
                        height: 250, // Adjust the height to accommodate all content
                        width: 500, // Adjust the width of the container
                        alignment: Alignment.center, // Center the content
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Group 29.svg', // Path to your Group 29.svg
                              width: 27, // Adjust the size of the SVG as needed
                              height: 27,
                            ),
                            SizedBox(height: 10), // Space between Group 29.svg and 3.svg
                            SvgPicture.asset(
                              'assets/icons/3.svg', // Path to your 3.svg
                              width: 10, // Adjust the size of the SVG as needed
                              height: 10,
                            ),
                            SizedBox(height: 10), // Space between the SVGs and the text
                            Column(
                              children: [
                                Text(
                                  'support@fashionstore', // Email text
                                  style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5), // Space between email and phone number
                                Text(
                                  '+12 123 456 7896', // Phone number text
                                  style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5), // Space between phone number and timing text
                                Text(
                                  '08:00 - 22:00 - Everyday', // Working hours text
                                  style: TextStyle(
                                    fontFamily: 'TenorSans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 5), // Space between timing text and new row
                                SvgPicture.asset(
                                  'assets/icons/3.svg', // Path to your 3.svg
                                  width: 10, // Adjust the size of the SVG as needed
                                  height: 10,
                                ),
                                SizedBox(height: 15), // Space between timing text and new row
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.23), // Adjust horizontal padding based on screen width
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start, // Align the row content to the start
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06), // Space between About and Contact text
                                        child: Text(
                                          'About', // About text
                                          style: TextStyle(
                                            fontFamily: 'TenorSans',
                                            fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size based on screen width
                                            // Make it bold to stand out
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08), // Space between Contact and Blog text
                                        child: Text(
                                          'Contact', // Contact text
                                          style: TextStyle(
                                            fontFamily: 'TenorSans',
                                            fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size based on screen width
                                            // Make it bold to stand out
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Blog', // Blog text
                                        style: TextStyle(
                                          fontFamily: 'TenorSans',
                                          fontSize: MediaQuery.of(context).size.width * 0.04, // Adjust font size based on screen width
                                          // Make it bold to stand out
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 5), // Space between the two containers

                      // New Container
                      Container(
                        color: Colors.grey[200], // Set the color to a light grey or any desired color
                        height: 100, // Set the height for the new container
                        width: 500, // Set the width for the new container
                        alignment: Alignment.center, // Center the content
                        child: Text(
                          'Designed by fashionstore', // Centered text
                          style: TextStyle(
                            fontFamily: 'TenorSans',
                            fontSize: 16, // Adjust the font size as needed
                            // Make it bold for emphasis
                            color: Colors.black, // Set the text color
                          ),
                        ),
                      ),
                    ],
                  ),


                ],

              )
            ],
          ),
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
                  width: MediaQuery.of(context).size.width * 0.075, // 7.5% of screen width
                  height: MediaQuery.of(context).size.height * 0.025, // 2.5% of screen height
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/chat.svg',
                  width: MediaQuery.of(context).size.width * 0.06, // 6% of screen width
                  height: MediaQuery.of(context).size.height * 0.03, // 3% of screen height
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
                  width: MediaQuery.of(context).size.width * 0.075, // 7.5% of screen width
                  height: MediaQuery.of(context).size.height * 0.025, // 2.5% of screen height
                ),
                label: 'Notification',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  width: MediaQuery.of(context).size.width * 0.06, // 6% of screen width
                  height: MediaQuery.of(context).size.height * 0.03, // 3% of screen height
                ),
                label: 'Profile',
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03, // 6% from the bottom
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/barcode.svg',
                width: MediaQuery.of(context).size.width * 0.2, // 20% of screen width
                height: MediaQuery.of(context).size.width * 0.2, // 20% of screen width (maintaining aspect ratio)
              ),
            ),
          ),
        ],
      ),

    );
  }
}
