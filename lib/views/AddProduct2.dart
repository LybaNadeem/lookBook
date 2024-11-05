import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/Size selector.dart';
import '../components/color_picker.dart';
import 'AddPhotographer .dart';

class AddProduct2 extends StatefulWidget
{
  @override
  _AddProduct2State createState() => _AddProduct2State();
}


class _AddProduct2State extends State<AddProduct2>
{
  String selectedSize = '';
  final List<String> sizes = ['S', 'M', 'L'];
  final List<String> categories = ['Dresses', 'Shoes', 'Jackets'];
  String? selectedCategory;

  TextEditingController dressTitleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController projectDescriptionController = TextEditingController();
  TextEditingController minimumorderController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController BarcodeController = TextEditingController();
  TextEditingController EventdateController = TextEditingController();
  TextEditingController EventController = TextEditingController();
  TextEditingController colorsController = TextEditingController();
  TextEditingController sizesController = TextEditingController();

  // Firebase and image handling
  User? currentUser = FirebaseAuth.instance.currentUser;
  File? _imageFile;
  String? _imageUrl;
  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
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

  // Function to upload image to Firebase
  Future<String> _uploadImageToFirebase(String imagePath) async {
    File file = File(imagePath);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('Products/$fileName');
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
    // Check if an image is selected
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an image.')),
      );
      return;
    }

    // Upload the image and get the URL
    try {
      _imageUrl = await _uploadImageToFirebase(_imageFile!.path);
      // Check if the image URL is valid
      if (_imageUrl == null || _imageUrl!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload returned an invalid URL.')),
        );
        return;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return;
    }

    // Check if any of the text fields are empty
    if (dressTitleController.text.isEmpty ||
        priceController.text.isEmpty ||
        projectDescriptionController.text.isEmpty ||
        minimumorderController.text.isEmpty ||
        instagramController.text.isEmpty ||
        linkedinController.text.isEmpty ||
        BarcodeController.text.isEmpty ||
        EventdateController.text.isEmpty ||
        EventController.text.isEmpty ||
        colorsController.text.isEmpty ||
        sizesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and upload an image.')),
      );
      return;
    }


    // Generate a new document reference to create a unique productId
    DocumentReference productRef = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('products')
        .doc();


    // Get the unique productId
    String productId = productRef.id;

    // Prepare the data for Firestore
    final productData = {
      'DressTitle': dressTitleController.text,
      'price': priceController.text,
      'projectDescription': projectDescriptionController.text,
      'image': [_imageUrl], // Store image URL in a list
      'minimumorder': minimumorderController.text,
      'instagram': instagramController.text,
      'linkedin': linkedinController.text,
      'Barcode': BarcodeController.text,
      'Eventdate': EventdateController.text,
      'Event': EventController.text,
      'Colors': [colorsController.text], // Store colors in a list
      'Sizes': [sizesController.text], // Store sizes in a list
      'productId': productId, // Add the generated productId
    };

    // Log the data for debugging
    print('Submitting data: $productData');

    // Try to add the data to Firestore
    try {
      await productRef.set(productData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product: $e')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:
        Text("LOOK\n      BOOK",
            style: TextStyle(
                fontFamily: 'Agne', fontWeight: FontWeight.bold)), // AppBar title for AddProduct2
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding for aesthetics
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  // Title below AppBar
                  Container(
                    // Positioning from the bottom
                    child: Text(
                      'ADD PRODUCT',
                      style: TextStyle(fontFamily: 'TenorSans', fontSize: 24),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/3.svg', // Update with your SVG path
                    height: height * 0.02, // Adjust the height as needed
                    width:width * 0.02, // Adjust the width as needed
                  ),
                  SizedBox(height: 20), // Space between title and image

                  // Image upload and display section
                  GestureDetector(
                    onTap: _pickImage, // Pick image when tapped
                    child: _imageFile == null
                        ? Column(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/add product images.svg', // Update with your SVG path
                          width: width * 0.272,
                          height: height * 0.240,
                        ),
                        Text('Tap to upload image',style:TextStyle(fontFamily: 'TenorSans'),),
                      ],
                    )
                        : Column(
                      children: [
                        Image.file(
                          _imageFile!,
                          width: width * 0.0272,
                          height: height * 0.0240,
                        ),
                        SizedBox(height:height * 0.020),
                        Text('Image uploaded!', style: TextStyle(fontFamily: 'TenorSans'),),
                      ],
                    ),
                  ),
                  // Show the uploaded image from Firebase
                  if (_imageUrl != null)
                    Column(
                      children: [
                        SizedBox(height:height * 0.020),
                        Image.network(
                          _imageUrl!,
                          width:width * 0.0272,
                          height:height * 0.0240,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(fontSize: 20), // Style for the category label
                    textAlign: TextAlign.left, // Align text to the left
                  ),
                  SizedBox(height:height * 0.010), // Space after the category label

                  // Category Dropdown with options
                  DropdownButtonFormField<String>(
                    style: TextStyle(fontSize: 16),
                    hint: Text('Select Category',style: TextStyle(fontFamily: 'TenorSans'),), // Hint text for the dropdown
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        // Rounded corners
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Padding inside the dropdown
                    ),
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: Colors.black, // Set the text color to black
                          ),
                        ), // Display category in the dropdown
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue; // Update selected category
                      });
                    },
                    isExpanded: true, // Make the dropdown full width
                    value:
                    selectedCategory, // Set the initial value to the selected category
                  ),
                  SizedBox(height:height * 0.010), // Space after the dropdown
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0), // Adjust the left padding as needed
                        child: Text(
                          'Add Category',
                          style: TextStyle(fontSize: 14,fontFamily: 'TenorSans'),

                          textAlign: TextAlign.left, // Specify the text alignment
                        ),
                      ),
                      SizedBox(width:width * 0.008), // Add space between text and icon
                      GestureDetector(
                        onTap: () {
                          // Show the bottom sheet when the SVG icon is tapped
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              final height = MediaQuery.of(context).size.height;
                              final width = MediaQuery.of(context).size.width;

                              return Container(
                                height: 300, // Set the desired fixed height for the bottom sheet
                                width: double.infinity, // Full width of the screen
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/bottom sheet.svg',
                                        width: 151,
                                        height: 4,
                                      ),
                                    ),
                                    SizedBox(height: 64),
                                    Text(
                                      'Add Category',
                                      style: TextStyle(
                                        fontFamily: 'TenorSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10), // Spacing between the title and the text field
                                    TextField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30),
                                          borderSide: BorderSide(color: Colors.grey.shade700), // Light gray border
                                        ),
                                        hintText: 'Type category', // Placeholder text for the text field
                                        hintStyle: TextStyle(
                                          fontFamily: 'TenorSans',
                                          color: Colors.grey.shade400, // Light gray hint text
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Add your action here when the button is pressed
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFE47F46), // Button color
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Add padding for height and width
                                          minimumSize: Size(399, 59), // Set the fixed width and height
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
                                          children: [
                                            Expanded( // Use Expanded to take up available space
                                              child: Text(
                                                'ADD',
                                                textAlign: TextAlign.left, // Align text to the left
                                                style: TextStyle(
                                                  fontFamily: 'Outfit_VariableFont_wght',
                                                  color: Colors.white, // Text color
                                                  fontSize: 16, // Font size
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/white Vector.svg', // Update with your SVG path
                                              height: 24, // Adjust height as needed
                                              width: 24, // Adjust width as needed
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),// Add other widgets here, buttons, etc.
                                  ],
                                ),
                              );


                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons/Vector.svg', // Update with your SVG path
                          width: width * 0.015, // Adjust width for icon
                          height: height * 0.015, // Adjust height for icon
                        ),
                      )

                    ],
                  ),

                  SizedBox(height:height * 0.010), // Space after the dropdown
                  Text(
                    'Dress title',
                    style: TextStyle(fontSize: 20,fontFamily: 'TenorSans'),
                  ),
                  SizedBox(height:height * 0.01),
                  TextField(
                    controller: dressTitleController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: ' Type',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030), // Space after the dropdown
                  Text(
                    'Price',
                    style: TextStyle(fontSize: 20,fontFamily: 'TenorSans'),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: priceController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: ' Type',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030),


                  Text(
                    'Project Description',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller:
                    projectDescriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: ' Type',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030),
                  ColorPickerWidget(controller: colorsController),
                  SizedBox(height:height * 0.030),

                  Text(
                    'Sizes',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  SizeSelector(controller: sizesController),

                  SizedBox(height:height* 0.010 ), // Minimum Order TextField
                  Text(
                    'Minimum Order Quantity',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: minimumorderController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: 'Enter Minimum Order Quantity',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030), // Space after the dropdown
                  Text(
                    'Social Links',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ), //
                  // Space after minimum order
                  SizedBox(height:height * 0.020),
                  Text(
                    'Instagram',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: instagramController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: 'Link',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.010),
                  Text(
                    'Linkedin',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: linkedinController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: 'Link',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.010),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0), // Adjust the left padding as needed
                        child: Text(
                          'Add Social links',
                          style: TextStyle(fontFamily: 'TenorSans',fontSize: 14),
                          textAlign: TextAlign.left, // Specify the text alignment
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show the bottom sheet when the SVG icon is tapped
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              final height = MediaQuery.of(context).size.height;
                              final width = MediaQuery.of(context).size.width;

                              return Container(
                                height: 350, // Set the desired fixed height for the bottom sheet
                                width: double.infinity, // Full width of the screen
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/bottom sheet.svg',
                                        width: 151,
                                        height: 4,
                                      ),
                                    ),
                                    SizedBox(height: 64),
                                    Text(
                                      'Add Social Link',
                                      style: TextStyle(
                                        fontFamily: 'TenorSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10), // Spacing between the title and the text field
                                    TextField(// Controller for dress titleController,
                                      decoration: InputDecoration(
                                        hintText: 'Title',
                                        hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                                          borderSide: BorderSide(
                                            color: Colors.grey, // Lighter border color
                                          ),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                                          borderSide: BorderSide(color: Colors.grey), // Same color when focused
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10), // Spacing between the title and the text field
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Link',
                                        hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                                          borderSide: BorderSide(
                                            color: Colors.grey, // Lighter border color
                                          ),
                                        ),

                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                                          borderSide: BorderSide(color: Colors.grey), // Same color when focused
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20), // Space before the button
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Add your action here when the button is pressed
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFE47F46), // Button color
                                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Add padding for height and width
                                          minimumSize: Size(399, 59), // Set the fixed width and height
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between text and icon
                                          children: [
                                            Expanded( // Use Expanded to take up available space
                                              child: Text(
                                                'ADD',
                                                textAlign: TextAlign.left, // Align text to the left
                                                style: TextStyle(
                                                  fontFamily: 'Outfit_Variable_wght',
                                                  color: Colors.white, // Text color
                                                  fontSize: 16, // Font size
                                                ),
                                              ),
                                            ),
                                            SvgPicture.asset(
                                              'assets/icons/white Vector.svg', // Update with your SVG path
                                              height: 24, // Adjust height as needed
                                              width: 24, // Adjust width as needed
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),


// Add other widgets here, buttons, etc.
                                  ],
                                ),
                              );
                            },
                          );
                        },


                        child: SvgPicture.asset(
                          'assets/icons/Vector.svg', // Update with your SVG path
                          width: width * 0.015, // Adjust width for icon
                          height: height * 0.015, // Adjust height for icon
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height:height * 0.020),
                  Text(
                    'Barcode',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller:BarcodeController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: 'Barcode',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030),
                  Text(
                    'Event',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: EventController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: 'Event',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030),
                  Text(
                    'Event Date',
                    style: TextStyle(fontFamily: 'TenorSans',fontSize: 20),
                  ),
                  SizedBox(height:height * 0.010),
                  TextField(
                    controller: EventdateController, // Controller for dress titleController,
                    decoration: InputDecoration(
                      hintText: ' Event Date',
                      hintStyle: TextStyle(fontFamily: 'TenorSans', color: Colors.grey[400], fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Set radius for the border
                        borderSide: BorderSide(
                          color: Colors.grey, // Lighter border color
                        ),
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when enabled
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)), // Border color when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0), // Same radius when focused
                        borderSide: BorderSide(color: Colors.grey), // Same color when focused
                      ),
                    ),
                  ),
                  SizedBox(height:height * 0.030),
                  //// Submit button to submit the product details
                  ElevatedButton(
                    onPressed: () {
                      _submitData(); // Call your submit data function

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPhotographer()),
                      );

                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceAround, // Space between the text and icon
                      children: [
                        Expanded(
                          child: Text(
                            ' NEXT', // Button label
                            textAlign: TextAlign.start,
                            style: TextStyle(fontFamily: 'Outfit_Variable_wght',fontSize: 20),
                            // Align text to the left
                          ),

                        ),

                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      backgroundColor: Color(0xFFE47F46),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}

