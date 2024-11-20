import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Report.dart';


class CustomerChatDetail extends StatelessWidget {
  final String name;
  final String chatRoomId;

  const CustomerChatDetail({Key? key, required this.name, required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .collection('messages')
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var messages = snapshot.data!.docs;
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              var message = messages[index];
              return ListTile(
                title: Text(message['message']),
                subtitle: Text(message['sender']),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: "Enter message"),
                onSubmitted: (text) {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(chatRoomId)
                      .collection('messages')
                      .add({
                    'message': text,
                    'sender': "currentUserId", // Replace with actual user ID
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                // Add send functionality here, if required
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final String? sender;
  final String? receiver;

  ChatBubble({
    required this.text,
    required this.isSentByUser,
    this.sender,
    this.receiver,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment:
        isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          GestureDetector(
            onLongPress: () {
              _showReportMenu(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSentByUser ? Color(0xFFE47F46) : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: isSentByUser ? Radius.circular(15) : Radius.zero,
                  bottomRight: isSentByUser ? Radius.zero : Radius.circular(15),
                ),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isSentByUser && sender != null)
                    Text(
                      sender!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  if (isSentByUser && receiver != null)
                    Text(
                      receiver!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  Text(
                    text,
                    style: TextStyle(
                      color: isSentByUser ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReportMenu(BuildContext context) {
    final RenderBox overlay =
    Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero, ancestor: overlay);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx + 10, // Add an offset for better visibility
        offset.dy + 10, // Add an offset for better visibility
        overlay.size.width - offset.dx - 10, // Right edge
        overlay.size.height - offset.dy - 10, // Bottom edge
      ),
      items: [
        PopupMenuItem(
          value: 'report',
          child: Text('Report'),
        ),
      ],
    ).then((value) {
      if (value == 'report') {
        _handleReportAction(context);
      }
    });
  }

  void _handleReportAction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Report(),
      ),
    );
  }
}
