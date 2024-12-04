import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlockUserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchBlockedUsers() async {
    try {
      QuerySnapshot blockedUsersSnapshot = await _firestore
          .collection('users')
          .where('block', isEqualTo: true)
          .get();

      return blockedUsersSnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      print("Error fetching blocked users: $e");
      return [];
    }
  }
}

class BlockPage extends StatefulWidget {
  @override
  _BlockPageState createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage> {
  final BlockUserController _controller = BlockUserController();
  late Future<List<Map<String, dynamic>>> _blockedUsersFuture;

  @override
  void initState() {
    super.initState();
    _blockedUsersFuture = _controller.fetchBlockedUsers();
  }

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
              SvgPicture.asset('assets/icons/3.svg', height: 12, width: 12),
              SizedBox(height: 20.0), // Space between the SVG and the TabBar
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Additional padding for the TabBarView content
                  child: TabBarView(
                    children: [
                      // Designer Tab with fetched blocked users
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _blockedUsersFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error fetching blocked users'));
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No blocked users found'));
                          }

                          final blockedUsers = snapshot.data!;
                          return ListView.builder(
                            itemCount: blockedUsers.length,
                            itemBuilder: (context, index) {
                              final user = blockedUsers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFE5E5), // Light red background
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: user['image'] != null
                                          ? NetworkImage(user['image']) // Assuming image URL is in the 'image' field
                                          : AssetImage('assets/images/default_avatar.png')
                                      as ImageProvider,
                                      radius: 30,
                                    ),
                                    title: Text(
                                      user['fullName'] ?? 'Unknown',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(user['phone'] ?? 'No phone number'),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        // Handle unblock action
                                        print('Unblock user: ${user['id']}');
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
