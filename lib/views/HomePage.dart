import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'MessageApp.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of images to display
  final List<String> images = [
    'assets/images/image block1.png', // Update your image paths
    'assets/images/image block2.png',
    'assets/images/image block1.png',
    'assets/images/image block2.png',
    'assets/images/image block1.png',
    'assets/images/image block2.png',
  ];

  // Method to handle tab tap
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MessagesApp()), // Navigate to ChatScreen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Add your drawer opening functionality
          },
        ),
        centerTitle: true,
        title:
        Text("LOOK\n      BOOK",
            style: TextStyle(
                fontFamily: 'Agne', fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            childAspectRatio: 0.7, // Adjust this to make items taller
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'MOHAN',
                      style: TextStyle(fontFamily: 'TenorSans', fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'We work with monitoring programs...',
                      style: TextStyle(fontFamily: 'TenorSans', color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '\$120',
                      style: TextStyle(
                        fontFamily: 'TenorSans',
                        color: Color(0xFFE47F46),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your functionality
        },
        backgroundColor:Color(0xFFE47F46),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFE47F46),
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped, // Handle taps for navigation
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/Home.svg',
              width: 24,
              height: 15,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/chat.svg', // Update with your icon path for Chat
              width: 24,
              height: 24,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/notification-bing.svg', // Update with your icon path for Notification
              width: 24,
              height: 24,
            ),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg', // Update with your icon path for Profile
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

// Example ChatScreen
class MessageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Center(child: Text('Welcome to Chat')),
    );
  }
}
