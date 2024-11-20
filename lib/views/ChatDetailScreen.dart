import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'designer_report.dart';

class Chatdetailscreen extends StatelessWidget {
  final String name; // Name of the selected contact

  Chatdetailscreen({required this.name}); // Constructor to accept name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "LOOK\n      BOOK",
              style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigating back to the previous screen
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.white,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0),
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24,

                  fontFamily: 'TenorSans',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: SvgPicture.asset(
                'assets/icons/3.svg', // Replace with your SVG asset path
                height: 9, // Adjust height and width as needed
                width: 9,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        name, // Display the contact's name dynamically
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'TenorSans',
                        ),
                      ),
                    ),
                  ),

                  CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/images/brooke.jpg'), // Replace with appropriate image asset
                    radius: 20, // Adjust the size as needed
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ChatBubble(
                    text: "Hey Lucas!",
                    isSentByUser: false,
                    sender: name, // Use the dynamic name here
                  ),
                  ChatBubble(
                    text: "How's your project going?",
                    isSentByUser: false,
                  ),
                  ChatBubble(
                    text: "Hi Brooke!",
                    isSentByUser: true,
                    receiver: 'Lucas',
                  ),
                  ChatBubble(
                    text: "It's going well. Thanks for asking!",
                    isSentByUser: true,
                  ),
                  ChatBubble(
                    text: "No worries. Let me know if you need anything.",
                    isSentByUser: false,
                    sender: name, // Dynamic sender
                  ),
                  ChatBubble(
                    text: "You're the best!",
                    isSentByUser: true,
                    receiver: 'Lucas',
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Color(0xFFE47F46)),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Color(0xFFE47F46)),
                    onPressed: () {},
                  ),
                ],
              ),
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
    final RenderBox overlay = Overlay.of(context)!.context
        .findRenderObject() as RenderBox;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(
        Offset.zero, ancestor: overlay);

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
        // Pass context to the report action handler
        _handleReportAction(context); // Pass the context here
      }
    });
  }

  void _handleReportAction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DesignerReport()), // Ensure ReportPage is defined and imported
    );
  }


}
