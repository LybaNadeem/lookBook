class ChatRoomModel {
  String chatroomId;
  Map<String, dynamic>? participants;  // Map with dynamic values
  String? lastMessage;

  ChatRoomModel({
    required this.chatroomId,
    this.participants,
    this.lastMessage,
  });

  // Convert ChatRoomModel to Map
  Map<String, dynamic> toMap() {
    return {
      "chatroomId": chatroomId,
      "participants": participants,
      "lastmessage": lastMessage,
    };
  }

  // Create ChatRoomModel from Map
  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatroomId: map["chatroomId"] ?? '',
      participants: map["participants"] ?? {},
      lastMessage: map["lastmessage"] ?? '',
    );
  }
}