import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'ProductPreview.dart';

class AddPhotographer extends StatefulWidget {
  @override
  _AddPhotographerState createState() => _AddPhotographerState();
}

class _AddPhotographerState extends State<AddPhotographer> {
  // For handling files
  TextEditingController PhotographerNameController = TextEditingController();
  TextEditingController SocialLinkController = TextEditingController();
  TextEditingController PhoneController = TextEditingController();
  TextEditingController EmailController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<String> _uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Products/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }

  Future<void> _submitData() async {
    String userId = currentUser!.uid;
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image.')),
      );
      return;
    }
    if (PhotographerNameController.text.isEmpty ||
        SocialLinkController.text.isEmpty ||
        PhoneController.text.isEmpty ||
        EmailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    try {
      String imageUrl = await _uploadImageToFirebase(_imageFile!.path);
      DocumentReference productDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('products')
          .doc();
      String productId = productDocRef.id;
      await productDocRef.set({
        'imageUrl': imageUrl,
        'productId': productId,
      });

      final photographerData = {
        'photographername': PhotographerNameController.text,
        'sociallink': SocialLinkController.text,
        'phone': PhoneController.text,
        'email': EmailController.text,
      };
      await productDocRef.collection('Photographer').add(photographerData);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPreviewStateful(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product and Photographer added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product and photographer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
        Text("LOOK\n      BOOK",
            style: TextStyle(
                fontFamily: 'Agne', fontWeight: FontWeight.bold)),
        ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.04), // 4% padding from width
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.15), // 15% padding from width
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'ADD PHOTOGRAPHER',
                        style: TextStyle(fontSize:20, fontFamily: 'TenorSans'), // Responsive font size
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/3.svg',
                      height: height * 0.015,
                      width: width * 0.02,
                    ),
                    SizedBox(height: height * 0.03), // Responsive height spacing
                    GestureDetector(
                      onTap: _pickImage,
                      child: _imageFile == null
                          ? Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/add product images.svg',
                            width: width * 0.68, // 68% of screen width
                            height: height * 0.3, // 30% of screen height
                          ),
                          Text('Tap to upload image',style: TextStyle(fontFamily: 'TenorSans',fontSize: width * 0.05),),
                        ],
                      )
                          : Column(
                        children: [
                          Image.file(
                            _imageFile!,
                            width: width * 0.68,
                            height: height * 0.3,
                          ),
                          SizedBox(height: 10),
                          Text('Image uploaded!'),
                        ],
                      ),
                    ),
                    if (_imageUrl != null)
                      Column(
                        children: [
                          SizedBox(height: height * 0.03),
                          Image.network(
                            _imageUrl!,
                            width: width * 0.68,
                            height: height * 0.3,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: height * 0.03),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.02), // Responsive height spacing
              Text(
                'Photographer Name',
                style: TextStyle(fontFamily: 'TenorSans',fontSize: width * 0.05), // Responsive font size
              ),
              SizedBox(height: height * 0.01), // Responsive height spacing
              TextField(
                controller: PhotographerNameController,
                decoration: InputDecoration(
                  hintText: 'Type',
                  hintStyle: TextStyle(fontFamily: 'TenorSans',color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              SizedBox(height: height * 0.03), // Responsive height spacing
              Text(
                'Social Link',
                style: TextStyle(fontFamily: 'TenorSans',fontSize: width * 0.05), // Responsive font size
              ),
              SizedBox(height: height * 0.01), // Responsive height spacing
              TextField(
                controller: SocialLinkController,
                decoration: InputDecoration(
                  hintText: 'Link',
                  hintStyle: TextStyle(fontFamily: 'TenorSans',color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              SizedBox(height: height * 0.03), // Responsive height spacing
              Text(
                'Phone Number',
                style: TextStyle(fontFamily: 'TenorSans',fontSize: width * 0.05), // Responsive font size
              ),
              SizedBox(height: height * 0.01), // Responsive height spacing
              TextField(
                controller: PhoneController,
                decoration: InputDecoration(
                  hintText: 'Type',
                  hintStyle: TextStyle(fontFamily: 'TenorSans',color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              SizedBox(height: height * 0.03), // Responsive height spacing
              Text(
                'Email',
                style: TextStyle(fontFamily: 'TenorSans',fontSize: width * 0.05), // Responsive font size
              ),
              SizedBox(height: height * 0.01), // Responsive height spacing
              TextField(
                controller: EmailController,
                decoration: InputDecoration(
                  hintText: 'Type',
                  hintStyle: TextStyle(fontFamily: 'TenorSans',color: Colors.grey[400], fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              SizedBox(height: height * 0.03), // Responsive height spacing
              ElevatedButton(
                onPressed: _submitData,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the text
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(fontFamily: 'Outfit_Variable_wght',fontSize: width * 0.05,color: Colors.white), // Responsive font size
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  backgroundColor: Color(0xFFE47F46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
