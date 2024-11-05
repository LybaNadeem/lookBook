import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Dummy sender name; you can set it dynamically
  final String name = "John Doe";

  // Controller for the description TextField
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Center contents horizontally
              children: [
                // Title: REPORT
                Text(
                  'REPORT',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                // SVG image
                SvgPicture.asset(
                  'assets/icons/3.svg', // Replace with your actual SVG path
                  height: 12, // Set height for better visibility
                  width: 12,  // Set width for better visibility
                ),

                // Add space between SVG and chat bubble
                SizedBox(height: 60),

                // Chat bubble positioned at the start of the row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the start of the row
                  children: [
                    ChatBubble(
                      text: "No worries. Let me know",
                      isSentByUser: false,
                      sender: name, // Dynamic sender
                    ),
                  ],
                ),

                // Add space between chat bubble and description TextField
                SizedBox(height: 20), // Space between card and TextField

                // TextField for input with multiple lines
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Set the color and width of the border
                    borderRadius: BorderRadius.circular(20), // Optional: for rounded corners
                  ),
                  child: TextField(
                    maxLines: 5, // Allows up to 5 lines of text
                    decoration: InputDecoration(
                      hintText: 'Enter your report...',
                      border: InputBorder.none, // Removes the inner border
                      fillColor: Colors.grey[200], // Set light grey background color
                      filled: true, // Enables the fill color
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),




                SizedBox(height: 20), // Space between TextField and Button

                // Elevated Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, // Aligns items to the start of the row
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add your onPressed logic here

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC60D06), // Button background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80), // Rounded corners
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Ensures button takes only needed width
                        children: [ // Space between icon and text
                          Text(
                            "REPORT",
                            style: TextStyle(
                              fontFamily: 'Outfit_Variable_wght',
                              color: Colors.white, // Text color
                              fontWeight: FontWeight.bold,
                              fontSize: 18, // Font size for REPORT button
                            ),
                          ),
                          SizedBox(width: 5),
                          SvgPicture.asset(
                            // Replace with your actual SVG path
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

// Assuming you have a ChatBubble widget defined like this
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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(10.0),
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
    );
  }
}
