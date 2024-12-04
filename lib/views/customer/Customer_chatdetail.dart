import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/messages_model.dart';
import '../designer_report.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;
  final String designerId;
  final String SenderId;

  const ChatScreen({
    Key? key,
    required this.chatRoomId,
    required this.designerId,
    required this.SenderId,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  Future<void> _sendMessage(
      String text, String receiverId, String senderId) async {
    if (text.trim().isEmpty) return;

    try {
      MessageModel newMessage = MessageModel(
        text: text,
        sender: senderId,
        receiver: receiverId,
        sentOn: DateTime.now(),
        isRead: false,
      );

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add(newMessage.toMap());

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoomId)
          .update({
        'lastMessage': text,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastMessageSender': senderId,
        'lastMessageReceiver': receiverId,
      });

      _messageController.clear();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<void> _reportMessage(String messageId, String messageText) async {
    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'messageId': messageId,
        'messageText': messageText,
        'reportedBy': widget.SenderId,
        'reportedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message reported successfully')),
      );
    } catch (e) {
      print("Error reporting message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.designerId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                    NetworkImage('https://via.placeholder.com/150'),
                    radius: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Loading...",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>?;

            return Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    userData?['profileImage'] ??
                        'https://via.placeholder.com/150',
                  ),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Text(
                  userData?['fullName'] ?? 'Unknown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        backgroundColor: Color(0xFFE47F46),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('sentOn', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var messageData = docs[index].data() as Map<String, dynamic>;
                    bool isCurrentUser = messageData['sender'] == widget.SenderId;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Builder(
                        builder: (messageContext) => GestureDetector(
                          onLongPress: () async {
                            // Get the position of the message widget
                            final RenderBox renderBox = messageContext.findRenderObject() as RenderBox;
                            final Offset offset = renderBox.localToGlobal(Offset.zero);
                            final Size size = renderBox.size;

                            final result = await showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy - size.height,
                                MediaQuery.of(context).size.width - offset.dx - size.width,
                                MediaQuery.of(context).size.height - offset.dy,
                              ),
                              items: [
                                PopupMenuItem(
                                  value: 'report',
                                  child: Row(
                                    children: [
                                      Text('Report'),
                                      SizedBox(width: 5),
                                      Icon(Icons.flag, color: Colors.red),
                                    ],
                                  ),
                                ),
                              ],
                            );

                            if (result == 'report') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DesignerReport(
                                    messageText: messageData['text'],
                                    senderName: messageData['sender'], // Assuming sender is the sender's name
                                  ),
                                ),
                              );
                            }
                          },

                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCurrentUser
                                  ? Colors.orange[300]
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(messageData['text']),
                          ),
                        ),
                      ),
                    );
                  },
                );

              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xFFE47F46)),
                  onPressed: () {
                    _sendMessage(
                        _messageController.text,
                        widget.designerId,
                        widget.SenderId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
