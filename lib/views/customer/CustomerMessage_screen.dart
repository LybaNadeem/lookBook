import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Customer_chatdetail.dart';



class CustomermessageScreen extends StatefulWidget {
  final String currentUserId;
  CustomermessageScreen({required this.currentUserId});


  @override
  State<CustomermessageScreen> createState() => _CustomermessageScreenState();

}
class _CustomermessageScreenState extends State<CustomermessageScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'LOOK BOOK',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'MESSAGES',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16),
            // List of Messages
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chatrooms = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: chatrooms.length,
                    itemBuilder: (context, index) {
                      final chatroom = chatrooms[index];
                      final chatroomData = chatroom.data() as Map<String, dynamic>?;

                      if (chatroomData != null &&
                          chatroomData.containsKey('participants') &&
                          _getParticipants(chatroomData['participants']).contains(currentUser?.uid)) {
                        final participants = _getParticipants(chatroomData['participants']);
                        final otherUserId = participants.firstWhere(
                              (id) => id != currentUser?.uid,
                          orElse: () => '',
                        );

                        print("current user id: ${currentUser?.uid}");
                        print('participants: $participants');
                        if (participants.contains(currentUser?.uid)){
                          print("i m if current user id: ${currentUser?.uid}");
                          if (otherUserId.isNotEmpty) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                              builder: (context, userSnapshot) {
                                if (!userSnapshot.hasData) {
                                  return SizedBox.shrink();
                                }

                                final userData = userSnapshot.data!.data() as Map<String, dynamic>?;

                                if (userData != null) {
                                  final chatroomId = chatroom.id;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0), // Adds space between tiles
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              chatRoomId: chatroomId,
                                              designerId: otherUserId,
                                              SenderId: currentUser?.uid ?? '',
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              userData['profileImage'] ?? 'https://via.placeholder.com/150',
                                            ),
                                            radius: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            userData['fullName'] ?? 'Unknown',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              },
                            );
                          } else {
                            return SizedBox.shrink();
                          }}
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );

                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<String> _getParticipants(dynamic participantsField) {
    if (participantsField is Map<String, dynamic>) {
      // If participants is a Map, extract the keys as a list
      return participantsField.keys.toList();
    } else if (participantsField is List) {
      // If participants is already a List, cast it to List<String>
      return List<String>.from(participantsField);
    }
    // Return an empty list if the structure is unrecognized
    return [];
  }
}

class MessageTile extends StatelessWidget {
  final String profileImage;
  final String name;
  final String message;
  final int unreadCount;
  final bool isReceiver;

  MessageTile({
    required this.profileImage,
    required this.name,
    required this.message,
    this.unreadCount = 0,
    this.isReceiver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            backgroundImage: NetworkImage(profileImage),
            radius: 25,
          ),
          SizedBox(width: 12),
          // Name and Message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  isReceiver ? "message: $message" : message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Unread Message Counter (Receiver Only)
          if (isReceiver && unreadCount > 0)
            CircleAvatar(
              backgroundColor: Colors.orange,
              radius: 12,
              child: Text(
                '$unreadCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
