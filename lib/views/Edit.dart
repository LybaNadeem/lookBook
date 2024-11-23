import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Controllers/edit_controller.dart';
import 'HomePage.dart';

class Edit extends StatefulWidget  {
  var productId;

  Edit({Key? key, required this.productId}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _eventDate;
  final _dateFormat = DateFormat('yyyy-MM-dd');

  // TextEditingControllers for input fields
  final TextEditingController dressTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController minOrderController = TextEditingController();
  final TextEditingController socialLinkController = TextEditingController();
  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController eventNameController = TextEditingController();

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
                      height: 250,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/product_placeholder.png', // Replace with your placeholder
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

              // Category Field
              const Text(
                "Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Dresses",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const Divider(height: 20),

              // Dress Title
              TextFormField(
                controller: dressTitleController,
                decoration: const InputDecoration(labelText: "Dress Title"),
              ),
              const SizedBox(height: 10),

              // Price Field
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Description Field
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Product Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Minimum Order Field
              TextFormField(
                controller: minOrderController,
                decoration: const InputDecoration(labelText: "Minimum Order Quantity"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Social Link Field
              TextFormField(
                controller: socialLinkController,
                decoration: const InputDecoration(labelText: "Social Links"),
              ),
              const SizedBox(height: 10),

              // Barcode Field
              TextFormField(
                controller: barcodeController,
                decoration: const InputDecoration(labelText: "Barcode"),
              ),
              const SizedBox(height: 10),

              // Event Field
              TextFormField(
                controller: eventNameController,
                decoration: const InputDecoration(labelText: "Event"),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Update product logic
                          editController.updateProduct(widget.productId, {
                            'dressTitle': dressTitleController.text,
                            'description': descriptionController.text,
                            'price': double.tryParse(priceController.text) ?? 0.0,
                            'minimumOrderQuantity': int.tryParse(minOrderController.text) ?? 0,
                            'photographerSocialLink': socialLinkController.text,
                            'barcode': barcodeController.text,
                            'eventName': eventNameController.text,
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
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        // Delete product logic
                        editController.deleteProduct(widget.productId).then((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: const Text("DELETE PRODUCT"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
