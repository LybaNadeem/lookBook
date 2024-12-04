// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import 'Notification_services.dart'; // Import flutter_svg
//
// class DesignerReport extends StatefulWidget {
//   final String messageText;
//   final String senderName;
//   DesignerReport({required this.messageText, required this.senderName});
//   @override
//   DesignerReportState createState() => DesignerReportState();
//
// }
//
// class DesignerReportState extends State<DesignerReport> {
//   final NotificationServices _notificationServices = NotificationServices();
//   final TextEditingController _descriptionController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           "LOOK\n      BOOK",
//           style: TextStyle(
//             fontFamily: 'Agne',
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Title: REPORT
//               SizedBox(height: 10),
//               Text(
//                 'REPORT',
//                 style: TextStyle(
//                   fontFamily: 'TenorSans',
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   letterSpacing: 1.2,
//                 ),
//               ),
//               SizedBox(height: 4),
//               SvgPicture.asset(
//                 'assets/icons/3.svg', // Replace with your actual SVG path
//                 height: 12, // Set height for better visibility
//                 width: 12,  // Set width for better visibility
//               ),
//
//               // Add space between SVG and chat bubble
//               SizedBox(height: 30),
//
//               // Chat bubble
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: ChatBubble(
//                   text: "No worries. Let me know if you need any help 😊",
//                   isSentByUser: false,
//                   sender: name,
//                 ),
//               ),
//
//               // Add space between chat bubble and input box
//               SizedBox(height: 20),
//
//               // TextField for input
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   border: Border.all(
//                     color: Colors.grey.shade300, // Set the border color
//                     width: 1.0, // Set the border width
//                   ),
//                   borderRadius: BorderRadius.circular(12.0), // Rounded corners
//                 ),
//                 child: TextField(
//                   controller: _descriptionController,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 5, // Limit the height to 5 lines
//                   decoration: InputDecoration(
//                     hintText: 'Type Reason',
//                     hintStyle: TextStyle(color: Colors.grey),
//                     border: InputBorder.none, // Remove the default TextField border
//                     contentPadding: EdgeInsets.all(16.0), // Add padding inside the TextField
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: 30), // Space between TextField and button
//
//               // REPORT Button
//               Row(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () async {
//                       String? adminToken = await getAdminDeviceToken();
//
//                       if (adminToken != null) {
//                         _notificationServices.sendPushNotification(
//                           "admin",
//                           adminToken,
//                           "A new report has been submitted. Tap to view.",
//                           "admin",
//                           "report",
//                           "",
//                           "",
//                         );
//                       } else {
//                         print("Admin token not found");
//                       }
//                     },
//
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFFC60D06), // Button background color
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(40), // Rounded corners
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0), // Button height
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "REPORT",
//                           style: TextStyle(
//                             fontFamily: 'Outfit_Variable_wght',
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         SvgPicture.asset(
//                           'assets/icons/arrow_icon.svg', // Replace with your actual SVG path
//                           width: 16,
//                           height: 16,
//                           color: Colors.white,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Future<String?> getAdminDeviceToken() async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('users')
//         .where('role', isEqualTo: 'admin') // Adjust 'role' as per your database schema
//         .get();
//
//     if (querySnapshot.docs.isNotEmpty) {
//       return querySnapshot.docs.first['deviceToken']; // Get the token from the first admin
//     }
//     return null; // Return null if no admin found
//   }
//
// }
//
// // ChatBubble widget
// class ChatBubble extends StatelessWidget {
//   final String text;
//   final bool isSentByUser;
//   final String sender;
//
//   const ChatBubble({
//     Key? key,
//     required this.text,
//     required this.isSentByUser,
//     required this.sender,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       padding: EdgeInsets.all(12.0),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(16.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             sender,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 5),
//           Text(
//             text,
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Notification_services.dart';

class DesignerReport extends StatefulWidget {
  final String messageText;
  final String senderName;

  DesignerReport({required this.messageText, required this.senderName});

  @override
  _DesignerReportState createState() => _DesignerReportState();
}

class _DesignerReportState extends State<DesignerReport> {
  final TextEditingController _descriptionController = TextEditingController();
  final NotificationServices _notificationServices = NotificationServices();


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
          onPressed: () => Navigator.pop(context),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align all child elements to the start (left)
          children: [
            SizedBox(height: 10),
            Text(
              'REPORT',
              style: TextStyle(
                fontFamily: 'TenorSans',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 30),

            // ChatBubble aligned to the left
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ChatBubble(
                    text: widget.messageText,
                    isSentByUser: false,
                    sender: widget.senderName,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Input box for typing a reason
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Type Reason',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Report button centered
            ElevatedButton(
              onPressed: () async {
                // Print the report message to the console
                print('Reported: ${widget.messageText}');

                // Fetch the admin's device token
                String? adminToken = await getAdminDeviceToken();

                // If the token is found, send a push notification
                if (adminToken != null) {
                  _notificationServices.sendPushNotification(
                    "admin",
                    adminToken,
                    "A new report has been submitted. Tap to view.",
                    "admin",
                    "report",
                    "",
                    "",
                  );
                  print('Push notification sent to admin.');
                } else {
                  print("Admin token not found");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC60D06), // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 40.0), // Button padding
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
                  SizedBox(width: 8),
                  SvgPicture.asset(
                    'assets/icons/arrow_icon.svg',
                    width: 16,
                    height: 16,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
  Future<String?> getAdminDeviceToken() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'admin') // Adjust 'role' as per your database schema
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first['deviceToken']; // Get the token from the first admin
    }
    return null;
  }

}


class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSentByUser;
  final String sender;

  const ChatBubble({
    required this.text,
    required this.isSentByUser,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 5),
          Text(text, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
