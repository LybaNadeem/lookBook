import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Controllers/edit_controller.dart';
import 'HomePage.dart';
import 'package:flutter_svg/flutter_svg.dart'; //

class Edit extends StatefulWidget  {
  var productId;

  Edit({Key? key, required this.productId}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}
InputDecoration customInputDecoration(String hintText, {String? labelText}) {
  return InputDecoration(
    hintText: hintText,
    labelText: labelText, // Added labelText property
    labelStyle: TextStyle(
      fontFamily: 'TenorSans',
      color: Colors.grey[600], // Label color
      fontSize: 14,
    ),
    hintStyle: TextStyle(
      fontFamily: 'TenorSans',
      color: Colors.grey[400],
      fontSize: 14,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(
        color: Colors.grey,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.0),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  );
}


class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _eventDate;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  bool showDropdown = false;
  String? selectedCategory;
  final List<String> categories = ['Dresses', 'Shoes', 'Jackets'];

  // TextEditingControllers for input fields
  final TextEditingController dressTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController minOrderController = TextEditingController();
  final TextEditingController socialLinkController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController addCategoryController = TextEditingController();


  @override
  void initState() {
    super.initState();
    final editController = Provider.of<edit_controller>(context, listen: false);
    editController.fetchData(widget.productId).then((_) {
      if (!mounted) return;
      setState(() {
        dressTitleController.text = editController.dressTitle;
        descriptionController.text = editController.description;
        priceController.text = editController.price.toString();
        minOrderController.text = editController.minimumOrderQuantity.toString();
        instagramController.text = editController.instagram;
        linkedinController.text = editController.linkedin;
        socialLinkController.text = editController.photographerSocialLink;

      });
    });
  }

  @override
  void dispose() {
    dressTitleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    minOrderController.dispose();
    socialLinkController.dispose();
    barcodeController.dispose();
    eventNameController.dispose();
    instagramController.dispose();
    linkedinController.dispose();
    super.dispose();
  }
  Future<void> deleteProduct(var productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
       // Notify listeners after deletion if needed
    } catch (e) {
      print("Error deleting product: $e");
      // Handle error appropriately (e.g., show a message to the user)
    }
  }
  void addCategory() {
    final newCategory = addCategoryController.text.trim();

    if (newCategory.isNotEmpty && !categories.contains(newCategory)) {
      setState(() {
        categories.add(newCategory);
        categoryController.text =
            newCategory; // Automatically select the new category
      });
      addCategoryController.clear(); // Clear the text field after adding
      Navigator.pop(context); // Close the bottom sheet
    }
  }
  @override
  Widget build(BuildContext context) {
    final editController = Provider.of<edit_controller>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        centerTitle: true,
      ),
      body: editController.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Upload Section
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 450,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/product1.png', // Replace with your placeholder
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.orange,
                              ),
                              onPressed: () {
                                // Handle image upload
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle, size: 10, color: Colors.orange),
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 10, color: Colors.grey),
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 10, color: Colors.grey),
                        SizedBox(width: 4),
                        Icon(Icons.circle, size: 10, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Category',
                style: TextStyle(fontSize: 20), // Font size for the label
              ),
              SizedBox(height: 10), // Space after the label

              // GestureDetector with TextField
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDropdown = !showDropdown;
                  });
                },
                child: TextField(
                  controller: categoryController,
                  readOnly: true, // Makes the TextField non-editable
                  decoration: InputDecoration(
                    hintText: 'Select Category', // Placeholder text
                    hintStyle:
                    TextStyle(fontFamily: 'TenorSans'), // Custom font
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(30), // Rounded corners
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ), // Padding inside the field
                  ),
                ),
              ),

              // Dropdown Container
              if (showDropdown)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10), // Rounded corners
                    color: Colors.white, // Background color
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Shadow color
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: Offset(0, 2), // Shadow position
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          categories[index],
                          style: TextStyle(
                            fontSize: 16, // Font size for category items
                            color: Colors.black, // Text color
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            categoryController.text =
                            categories[index]; // Update TextField value
                            showDropdown = false; // Close the dropdown
                          });
                        },
                      );
                    },
                  ),
                ),

              SizedBox(height:10), // Space after the dropdown

              // Add Category Row
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Adjust the left padding as needed
                    child: Text(
                      'Add Category',
                      style:
                      TextStyle(fontSize: 14, fontFamily: 'TenorSans'),
                      textAlign:
                      TextAlign.left, // Specify the text alignment
                    ),
                  ),
                  SizedBox(
                      width:8), // Add space between text and icon
                  GestureDetector(
                    onTap: () {
                      // Show the bottom sheet when the SVG icon is tapped
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height:
                            300, // Set the desired fixed height for the bottom sheet
                            width:
                            double.infinity, // Full width of the screen
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
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    10), // Spacing between the title and the text field
                                TextField(
                                  controller: addCategoryController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .shade700), // Light gray border
                                    ),
                                    hintText:
                                    'Type category', // Placeholder text for the text field
                                    hintStyle: TextStyle(
                                      fontFamily: 'TenorSans',
                                      color: Colors.grey
                                          .shade400, // Light gray hint text
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                Center(
                                  child: ElevatedButton(
                                    onPressed:
                                    addCategory, // Call addCategory method
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Color(0xFFE47F46), // Button color
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal:
                                          16), // Add padding for height and width
                                      minimumSize: Size(399,
                                          59), // Set the fixed width and height
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Space between text and icon
                                      children: [
                                        Expanded(
                                          // Use Expanded to take up available space
                                          child: Text(
                                            'ADD',
                                            textAlign: TextAlign
                                                .left, // Align text to the left
                                            style: TextStyle(
                                              fontFamily:
                                              'Outfit_VariableFont_wght',
                                              color: Colors
                                                  .white, // Text color
                                              fontSize: 16, // Font size
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/Vector.svg', // Update with your SVG path
                                          width:15, // Adjust width for icon
                                          height: 15, // Adjust height for icon
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: SvgPicture.asset(
                      'assets/icons/Vector.svg', // Update with your SVG path
                      width:15, // Adjust width for icon
                      height:15, // Adjust height for icon
                    ),
                  ),
                ],
              ),
              SizedBox(height:20),
              // Dress Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label outside the TextField
                  Text(
                    "Dress Title", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: dressTitleController,
                    decoration: customInputDecoration("Enter dress title"),
                  ),
                ],
              ),


              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label outside the TextField
                  Text(
                    "Price", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: priceController,
                    decoration: customInputDecoration("Enter price"),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label outside the TextField
                  Text(
                      "Description", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: descriptionController,
                    decoration: customInputDecoration("Enter description"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label outside the TextField
                  Text(
                    "Minimum Order Quantity", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: minOrderController,
                    decoration: customInputDecoration("Enter minimum order quantity"),
                  ),
                  SizedBox(height: 10),

                  Text(
                    "instagram", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: instagramController,
                    decoration: customInputDecoration("Link"),
                  ),
                  SizedBox(height: 10),

                  Text(
                    "linkedin", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: linkedinController,
                    decoration: customInputDecoration("Link"),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              TextField(
                controller: socialLinkController,
                decoration: customInputDecoration("Social Links"),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label outside the TextField
                  Text(
                    "Social Links", // Label text
                    style: TextStyle(
                      fontFamily: 'TenorSans',
                      fontSize: 14,

                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Space between label and TextField
                  TextField(
                    controller: socialLinkController,
                    decoration: customInputDecoration("Enter social links"),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0), // Adjust the left padding as needed
                    child: Text(
                      'Add Social links',
                      style:
                      TextStyle(fontFamily: 'TenorSans', fontSize: 14),
                      textAlign:
                      TextAlign.left, // Specify the text alignment
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
                            height:
                            350, // Set the desired fixed height for the bottom sheet
                            width:
                            double.infinity, // Full width of the screen
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
                                SizedBox(
                                    height:
                                    10), // Spacing between the title and the text field
                                TextField(
                                  // Controller for dress titleController,
                                  decoration: InputDecoration(
                                    hintText: 'Title',
                                    hintStyle: TextStyle(
                                        fontFamily: 'TenorSans',
                                        color: Colors.black,
                                        fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Set radius for the border
                                      borderSide: BorderSide(
                                        color: Colors.grey, // Lighter border color
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Same radius when enabled
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(
                                              0.5)), // Border color when enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Same radius when focused
                                      borderSide: BorderSide(
                                          color: Colors
                                              .grey), // Same color when focused
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                    10), // Spacing between the title and the text field
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Link',
                                    hintStyle: TextStyle(
                                        fontFamily: 'TenorSans',
                                        color: Colors.black,
                                        fontSize: 14),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Set radius for the border
                                      borderSide: BorderSide(
                                        color: Colors
                                            .grey, // Lighter border color
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Same radius when enabled
                                      borderSide: BorderSide(
                                          color: Colors.grey.withOpacity(
                                              0.5)), // Border color when enabled
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          30.0), // Same radius when focused
                                      borderSide: BorderSide(
                                          color: Colors
                                              .grey), // Same color when focused
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height: 20), // Space before the button
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add your action here when the button is pressed
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Color(0xFFE47F46), // Button color
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal:
                                          16), // Add padding for height and width
                                      minimumSize: Size(399,
                                          59), // Set the fixed width and height
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween, // Space between text and icon
                                      children: [
                                        Expanded(
                                          // Use Expanded to take up available space
                                          child: Text(
                                            'ADD',
                                            textAlign: TextAlign
                                                .left, // Align text to the left
                                            style: TextStyle(
                                              fontFamily:
                                              'Outfit_Variable_wght',
                                              color: Colors
                                                  .white, // Text color
                                              fontSize: 16, // Font size
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/white Vector.svg', // Update with your SVG path
                                          height:
                                          24, // Adjust height as needed
                                          width:
                                          24, // Adjust width as needed
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
                      width: 15, // Adjust width for icon
                      height:15, // Adjust height for icon
                    ),
                  ),
                ],
              ),




              const SizedBox(height: 20),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Centers buttons vertically
                    crossAxisAlignment: CrossAxisAlignment.center, // Centers buttons horizontally
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFE47F46),
                          minimumSize: const Size(350, 50), // Set width and height
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Update product logic
                            editController.updateProduct(widget.productId, {
                              'dressTitle': dressTitleController.text,
                              'description': descriptionController.text,
                              'price': double.tryParse(priceController.text) ?? 0.0,
                              'minimumOrderQuantity': int.tryParse(minOrderController.text) ?? 0,
                              'photographerSocialLink': socialLinkController.text,
                              'eventName': eventNameController.text,
                              'instagram': instagramController.text,
                              'linkedin': linkedinController.text
                            }).then((_) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomePage(productId: widget.productId),
                                ),
                              );
                            });
                          }
                        },
                        child: const Text("UPDATE"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(350,20), // Set width and height
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        onPressed: () {
                          // Delete product logic
                          editController.deleteProduct(widget.productId).then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("DELETE PRODUCT"),
                      ),
                    ],
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
