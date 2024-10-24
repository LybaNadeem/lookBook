import 'package:flutter/material.dart';

import 'ChatDetailScreen.dart';

void main() {
  runApp(MessagesApp());
}

class MessagesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessagesScreen(),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("LOOK\n      BOOK",
                style: TextStyle(
                    fontFamily: 'Agne', fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          Text(
            "MESSAGES",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
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
          // Messages List
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
    );
  }

  // Widget for each message tile
  Widget messageTile(BuildContext context, String name, String message, String imageUrl, int unreadCount) {
    return ListTile(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(name: '', imageUrl: ''),
          ),
        );

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


