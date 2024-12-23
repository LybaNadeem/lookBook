import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReportDetail extends StatefulWidget {
  @override
  _ReportDetailState createState() => _ReportDetailState();
}

class _ReportDetailState extends State<ReportDetail> {
  final String name = "John Doe";
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get the screen width and calculate padding
    double screenPadding = MediaQuery.of(context).size.width * 0.05; // 5% of screen width for padding

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(
            fontFamily: 'Agne',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Message Report',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 24,

                    color: Colors.black,
                  ),
                ),
                SvgPicture.asset(
                  'assets/icons/3.svg',
                  height: 12,
                  width: 12,
                ),
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ChatBubble(
                      text: "No worries. Let me know",
                      isSentByUser: false,
                      sender: name,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Enter your report...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.blueGrey[50],
                      filled: true,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC60D06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "REPORT",
                            style: TextStyle(
                              fontFamily: 'Outfit_Variable_wght',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(
                            'assets/icons/arrow_icon.svg',
                            width: 10,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final String sender;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isSentByUser,
    required this.sender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bubblePadding = MediaQuery.of(context).size.width * 0.03; // 3% of screen width

    return DottedBorder(
      borderType: BorderType.RRect,
      radius: Radius.circular(15),
      dashPattern: [6, 3],
      color: Colors.red,
      strokeWidth: 1.5,
      child: Container(
        padding: EdgeInsets.all(bubblePadding),
        decoration: BoxDecoration(
          color: isSentByUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: isSentByUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSentByUser ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                color: isSentByUser ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
