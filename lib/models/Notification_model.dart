class NotificationModel {
  late String id;
  late String senderId;
  late String receiverId;
  late String message;
  late String? navigationId;
  late String? productId;
  late String notificationType;
  late DateTime time;
  late bool isRead;

  NotificationModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.time,
    required this.notificationType,
    this.navigationId,
    this.productId,
    this.isRead = false,
  });

  NotificationModel.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    senderId = map["senderId"];
    receiverId = map["receiverId"];
    message = map["message"];
    navigationId = map['navigationId'] ?? '';
    productId = map['productId'] ?? '';
    notificationType = map['notificationType'] ?? '';
    time = map["time"].toDate();
    isRead = map['isRead'] ?? false;
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
      "navigationId": navigationId,
      "productId": productId,
      "notificationType": notificationType,
      "time": time,
      "isRead": isRead,
    };
  }
}