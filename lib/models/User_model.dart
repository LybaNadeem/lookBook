class UserModel {
  String? userId;
  String? email;
  String? fullName;
  String? password;
  String? phoneNumber;
  List<String>? socialLinks; // New field for social media links
  final String imagePath;
  final String title;
  final String description;
  final String imageurl;

  // Constructor for both user and onboarding data
  UserModel({
    this.userId,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.socialLinks, // Add to constructor
    required this.imageurl,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  // Convert UserModel to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'socialLinks': socialLinks, // Add to map
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'ImageUrl': imageurl,
    };
  }

  // Create a UserModel from a map (for retrieving data from Firebase)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      fullName: map['fullName'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phoneNumber'],
      socialLinks: List<String>.from(map['socialLinks'] ?? []), // Retrieve social links
      imagePath: map['imagePath'],
      title: map['title'],
      imageurl: map['ImageUrl'],
      description: map['description'],
    );
  }
}
