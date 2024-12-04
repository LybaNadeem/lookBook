import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/User_model.dart';
import '../models/chat_model.dart';
import '../models/messages_model.dart';

class ChatController {
  var unreadMessageCount = 0;
  var unreadMessageCountCustomer = 0;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  var designersList = <UserModel>[];
  var filteredDesignersList = <UserModel>[];
  var customersList = <UserModel>[];
  var filteredCustomersList = <UserModel>[];
  TextEditingController searchController = TextEditingController();
  var isLoading = true;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ChatRoomModel? chatroom;
  static User get user => auth.currentUser!;
  String get currentUserId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  ChatController() {
    filterDesigners(searchController.text);
    filterCustomers(searchController.text);
  }

  void filterDesigners(String query) {
    if (query.isEmpty) {
      filteredDesignersList = List.from(designersList);
    } else {
      filteredDesignersList = designersList.where((Designer) {
        return Designer.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
  }

  void filterCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomersList = List.from(customersList);
    } else {
      filteredCustomersList = customersList.where((customer) {
        return customer.fullName?.toLowerCase().contains(query.toLowerCase()) ?? false;
      }).toList();
    }
  }

  CollectionReference get chatroomsRef => _firestore.collection('chatrooms');

  String generateChatroomId(String customerId, String designerId) {
    List<String> ids = [customerId, designerId]..sort();
    return ids.join('_');
  }

  Future<ChatRoomModel> createOrGetChatroom({
    required String customerId,
    required String designerId,
  }) async {
    String chatroomId = generateChatroomId(customerId, designerId);

    DocumentReference chatroomDoc = chatroomsRef.doc(chatroomId);

    DocumentSnapshot docSnapshot = await chatroomDoc.get();

    if (docSnapshot.exists) {

      return ChatRoomModel.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } else {

      ChatRoomModel chatroom = ChatRoomModel(
        chatroomId: chatroomId,
        participants: {
          customerId: true,
          designerId: true,
        },
        lastMessage: '',
      );

      await chatroomDoc.set(chatroom.toMap());

      return chatroom;
    }
  }


  Future<String> startChatWithDesigner(BuildContext context, String productId) async {
    try {
      final productDoc = await FirebaseFirestore.instance.collection('products').doc(productId).get();

      if (!productDoc.exists) {
        print("Product not found.");
        return ''; // Return an empty string if product is not found
      }

      String userId = productDoc['userId'];
      print(userId);

      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      print(userDoc);
      if (!userDoc.exists) {
        print("User not found.");
        return ''; // Return an empty string if user is not found
      }

      String role = userDoc['role'];
      if (role != 'Designer') {
        print("User is not a designer.");
        return ''; // Return an empty string if the user is not a designer
      }

      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Create or get the chat room and return its ID
      ChatRoomModel chatRoom = await createOrGetChatroom(
        customerId: currentUserId,
        designerId: userId,
      );

      return chatRoom.chatroomId; // Return the chat room ID from the ChatRoomModel
    } catch (e) {
      print("Error starting chat: $e");
      return ''; // Return an empty string in case of error
    }
  }


  Future<String?> getDesignerUserId() async {
    try {
      // Query users collection to find a user with role 'Designer'
      QuerySnapshot designerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Designer')
          .get();

      if (designerSnapshot.docs.isNotEmpty) {
        // Return the first designer's userId
        return designerSnapshot.docs.first.id;
      } else {
        print("No user with role 'Designer' found.");
        return null;
      }
    } catch (e) {
      print("Error fetching designer: $e");
      return null;
    }
  }
  Future<void> sendMessage(
      String text, String currentUserId, String chatRoomId) async {
    try {
      // Get Designer's User ID
      String? designerUserId = await getDesignerUserId();

      if (designerUserId == null) {
        print("Designer not found. Cannot send the message.");
        return;
      }

      // Create message data
      Map<String, dynamic> messageData = {
        'text': text,
        'sender': currentUserId,
        'receiver': designerUserId,

      'sentOn': FieldValue.serverTimestamp(),
        'isRead': false,
        'messageType': 'text',
        'isReported': null,
        'replyTo': null,
      };


      // Add message to Firebase
      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);

      print("Message sent successfully.");
    } catch (e) {
      print("Error sending message: $e");
    }
  }
  // Stream<List<MessageModel>> fetchMessages(String chatRoomId, String currentUserId) {
  //   try {
  //     // Stream messages for the given chatroom
  //     return FirebaseFirestore.instance
  //         .collection('chatrooms')
  //         .doc(chatRoomId)
  //         .collection('messages')
  //         .orderBy('sentOn', descending: false) // Oldest messages first
  //         .snapshots()
  //         .map((snapshot) {
  //       return snapshot.docs.map((doc) {
  //         // Map each document to a MessageModel
  //         return MessageModel.fromMap(doc.data() as Map<String, dynamic>);
  //       }).where((message) {
  //         // Filter messages where the current user is either the sender or receiver
  //         return message.sender == currentUserId || message.receiver == currentUserId;
  //       }).toList();
  //     });
  //   } catch (e) {
  //     print("Error fetching messages: $e");
  //     return const Stream.empty();
  //   }
  //
  // }


  Stream<List<MessageModel>> fetchMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentOn', descending: true) // Use consistent sorting
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      return MessageModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList());
  }

}
