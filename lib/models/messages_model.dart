import 'package:cloud_firestore/cloud_firestore.dart'; // For handling Firestore Timestamp

class MessageModel {
  String? id;
  String text; // Message content (text)
  String? sender; // Sender's user ID
  String receiver; // Receiver's user ID
  DateTime? sentOn; // DateTime when the message was sent
  String? img; // URL of an image, if any
  String? messageType; // Type of message: 'text', 'image', etc.
  bool? isRead; // Whether the message has been read
  bool? isReported; // Whether the message has been reported
  String? replyTo; // ID of the message being replied to (optional)

  MessageModel({
    this.id,
    required this.text,
    this.sender,
    required this.receiver,
    this.sentOn,
    this.img,
    this.messageType = 'text',
    this.isRead,
    this.isReported,
    this.replyTo,
  });

  // Factory constructor to create a MessageModel from Firestore data
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '', // Default to empty string if 'id' is null
      text: map['text'] ?? '', // Default to empty string if 'text' is null
      sender: map['sender'] ?? '', // Default to empty string if 'sender' is null
      receiver: map['receiver'] ?? '',
      sentOn: map['sentOn'] != null
          ? (map['sentOn'] as Timestamp).toDate()
          : null, // Convert Timestamp to DateTime if present
      img: map['img'] ?? '', // Default to empty string if 'img' is null
      messageType: map['messageType'] ?? 'text', // Default to 'text'
      isRead: map['isRead'] ?? false, // Default to false if 'isRead' is null
      isReported: map['isReported'] ?? false,
      replyTo: map['replyTo'], // Can be null if no reply
    );
  }

  // Convert MessageModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'receiver': receiver,
      'sentOn': sentOn != null
          ? Timestamp.fromDate(sentOn!)
          : null, // Convert DateTime to Firestore Timestamp, handle null
      'img': img,
      'messageType': messageType,
      'isRead': isRead,
      'isReported': isReported,
      'replyTo': replyTo,
    };
  }
}
