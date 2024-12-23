import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  // Dummy sender name; you can set it dynamically
  final String name = "Brooke";

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title: REPORT
              SizedBox(height: 10),
              Text(
                'REPORT',
                style: TextStyle(
                  fontFamily: 'TenorSans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              SvgPicture.asset(
                'assets/icons/3.svg', // Replace with your actual SVG path
                height: 12, // Set height for better visibility
                width: 12,  // Set width for better visibility
              ),

              // Add space between SVG and chat bubble
              SizedBox(height: 30),

              // Chat bubble
              Align(
                alignment: Alignment.centerLeft,
                child: ChatBubble(
                  text: "No worries. Let me know if you need any help 😊",
                  isSentByUser: false,
                  sender: name,
                ),
              ),

              // Add space between chat bubble and input box
              SizedBox(height: 20),

              // TextField for input
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(
                    color: Colors.grey.shade300, // Set the border color
                    width: 1.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                child: TextField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5, // Limit the height to 5 lines
                  decoration: InputDecoration(
                    hintText: 'Type Reason',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none, // Remove the default TextField border
                    contentPadding: EdgeInsets.all(16.0), // Add padding inside the TextField
                  ),
                ),
              ),

              SizedBox(height: 30), // Space between TextField and button

              // REPORT Button
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC60D06), // Button background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0), // Button height
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                        SizedBox(width: 8),
                        SvgPicture.asset(
                          'assets/icons/arrow_icon.svg', // Replace with your actual SVG path
                          width: 16,
                          height: 16,
                          color: Colors.white,
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
    );
  }
}

// ChatBubble widget
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
      margin: EdgeInsets.symmetric(vertical: 10.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
