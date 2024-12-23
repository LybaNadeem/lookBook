import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'ProductPreview.dart';

class AddPhotographer extends StatefulWidget {
  var productId;


  AddPhotographer({Key? key, required this.productId}) : super(key: key);
  @override
  _AddPhotographerState createState() => _AddPhotographerState();
}

class _AddPhotographerState extends State<AddPhotographer> {
  // Controllers
  TextEditingController photographerNameController = TextEditingController();
  TextEditingController socialLinkController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
    // Validate the image file
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image.')),
      );
      return;
    }

    // Validate the text fields
    if (photographerNameController.text.isEmpty ||
        socialLinkController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      // Upload the image to Firebase and get the URL
      String imageUrl = await _uploadImageToFirebase(_imageFile!.path);
      print('imageUrl: $imageUrl');

      // Reference to the specific product document
      DocumentReference productDocRef =
      FirebaseFirestore.instance.collection('products').doc(widget.productId);

      // Add or update the product details in the `products` collection
      await productDocRef.set({
        'imageUrl': imageUrl,
        'productId': widget.productId,
        'userId': currentUser!.uid, // Pass the userId
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      print('Product data saved: $imageUrl');

      // Prepare photographer data (initially without document ID)
      final photographerData = {
        'photographerName': photographerNameController.text,
        'socialLink': socialLinkController.text,
        'phone': phoneController.text,
        'email': emailController.text,
        'userId': currentUser!.uid, // Pass the userId here too
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the photographer details to the 'Photographer' subcollection
      DocumentReference photographerDocRef =
      await productDocRef.collection('Photographer').add(photographerData);

      // Update the photographer document with its own ID
      await photographerDocRef.update({'photographerId': photographerDocRef.id});

      print('Photographer added with ID: ${photographerDocRef.id}');

      // Navigate to the Product Preview page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPreviewStateful(productId: widget.productId, photgrapherId: null,),
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product and Photographer added successfully!')),
      );
    } catch (e) {
      // Show error message in case of failure
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
        title: Text(
          "LOOK\n      BOOK",
          style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'ADD PHOTOGRAPHER',
                style: TextStyle(fontSize: 20, fontFamily: 'TenorSans'),
              ),

              SvgPicture.asset(
                'assets/icons/3.svg',
                height: height * 0.02,
                width: width * 0.04,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/add product images.svg',
                      width: width * 0.68,
                      height: height * 0.3,
                    ),
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
              if (_imageUrl != null) ...[
                SizedBox(height: 20),
                Image.network(
                  _imageUrl!,
                  width: width * 0.68,
                  height: height * 0.3,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 20),
              ],
              SizedBox(height: 10),
              _buildTextField('Photographer Name', photographerNameController),
              SizedBox(height: 10),
              _buildTextField('Social Link', socialLinkController),
              SizedBox(height: 10),
              _buildTextField('Phone Number', phoneController),
              SizedBox(height: 10),
              _buildTextField('Email', emailController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitData,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontFamily: 'Outfit_Variable_wght',
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
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

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontFamily: 'TenorSans', fontSize: 16),
        ),
        SizedBox(height: 10),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Type',
            hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: BorderSide(color: Colors.orange, width: 2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
            ),
          ),
        ),
      ],
    );
  }
}