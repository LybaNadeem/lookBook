import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../DesignerMessage_screen.dart';



class CustomerMesageapp extends StatelessWidget {
  final String id ;

  const CustomerMesageapp({Key? key , required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessagesPage(currentUserId: '',),
    );
  }
}

class CustomerMessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              "MESSAGES",
              style: TextStyle(
                fontFamily: 'TenorSans',
                color: Colors.black,
                fontSize: 25,
              ),
            ),
            SvgPicture.asset(
                'assets/icons/3.svg',
                height:10,
                width:7
            ),
            SizedBox(height: 10),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  messageTile(context, 'Haley James', 'Stand up for what you believe in', 'assets/images/haley.jpg', 9),
                  messageTile(context, 'Nathan Scott', 'One day you’re seventeen...', 'assets/images/nathan.jpg', 0),
                  messageTile(context, 'Brooke Davis', 'I am who I am. No excuses.', 'assets/images/brooke.jpg', 2),
                  messageTile(context, 'Jamie Scott', 'Some people are a little different.', 'assets/images/jamie.jpg', 0),
                  messageTile(context, 'Marvin McFadden', 'Last night in the NBA...', 'assets/images/marvin.jpg', 0),
                  messageTile(context, 'Antwon Taylor', 'Meet me at the Rivercourt', 'assets/images/antwon.jpg', 0),
                  messageTile(context, 'Jake Jagielski', 'In your life, you’re gonna go...', 'assets/images/jake.jpg', 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) > 0) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }
  // Widget for each message tile
  Widget messageTile(BuildContext context, String name, String message, String imageUrl, int unreadCount) {
    return ListTile(
      onTap: () async {
        String chatRoomId = getChatRoomId("currentUserId", name);

        // Create or fetch the chatroom in Firestore
        await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).set({
          'chatroomId': chatRoomId,
          'users': ["currentUserId", name],
          'lastMessage': '',
          'timestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));



      },
      leading: CircleAvatar(
        backgroundImage: AssetImage(imageUrl),
        radius: 24,
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message, overflow: TextOverflow.ellipsis),
      trailing: unreadCount > 0
          ? CircleAvatar(
        radius: 12,
        backgroundColor: Color(0xFFE47F46),
        child: Text(
          unreadCount.toString(),
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      )
          : null,
    );
  }

}


