import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Controllers/edit_controller.dart';
import 'HomePage.dart';

class Edit extends StatefulWidget {
  final String productId;

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
  final TextEditingController photographerNameController = TextEditingController();
  final TextEditingController photographerEmailController = TextEditingController();
  final TextEditingController photographerPhoneController = TextEditingController();
  final TextEditingController photographerSocialLinkController = TextEditingController();

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Fetch data on initialization
    final editController = Provider.of<edit_controller>(context, listen: false);
    editController.fetchData(widget.productId).then((_) {
      if (!mounted) return; // Ensure the widget is still mounted
      setState(() {
        // Populate TextEditingControllers with fetched data
        dressTitleController.text = editController.dressTitle;
        descriptionController.text = editController.description;
        priceController.text = editController.price.toString();
        minOrderController.text = editController.minimumOrderQuantity.toString();
        photographerNameController.text = editController.photographerName;
        photographerEmailController.text = editController.photographerEmail;
        photographerPhoneController.text = editController.photographerPhone;
        photographerSocialLinkController.text = editController.photographerSocialLink;
     // Assuming you fetch the date as well
      });
    });


  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    dressTitleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    minOrderController.dispose();
    photographerNameController.dispose();
    photographerEmailController.dispose();
    photographerPhoneController.dispose();
    photographerSocialLinkController.dispose();
    super.dispose();
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
              Center(
                child: Column(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add_a_photo, size: 50, color: Colors.orange),
                    ),
                    const SizedBox(height: 8),
                    const Text("Add Product Images", style: TextStyle(fontSize: 16)),
                    const Text("Photo Images", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Text Fields
              TextFormField(
                controller: dressTitleController,
                decoration: const InputDecoration(labelText: "Dress Title"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Product Description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: minOrderController,
                decoration: const InputDecoration(labelText: "Minimum Order Quantity"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: photographerNameController,
                decoration: const InputDecoration(labelText: "Photographer Name"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: photographerEmailController,
                decoration: const InputDecoration(labelText: "Photographer Email"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: photographerPhoneController,
                decoration: const InputDecoration(labelText: "Photographer Phone"),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: photographerSocialLinkController,
                decoration: const InputDecoration(labelText: "Photographer Social Link"),
              ),
              const SizedBox(height: 10),

              // Date Picker
              const Text("Event Date"),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: _eventDate == null
                      ? 'Select Event Date'
                      : _dateFormat.format(_eventDate!),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _eventDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _eventDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Submit updated data to the backend
                      editController.updateProduct(widget.productId, {
                        'dressTitle': dressTitleController.text,
                        'description': descriptionController.text,
                        'price': double.tryParse(priceController.text) ?? 0.0,
                        'minimumOrderQuantity': int.tryParse(minOrderController.text) ?? 0,
                        'photographerName': photographerNameController.text,
                        'photographerEmail': photographerEmailController.text,
                        'photographerPhone': photographerPhoneController.text,
                        'photographerSocialLink': photographerSocialLinkController.text,
                        'eventDate': _eventDate,
                      }).then((_) {
                        // Navigate to the homepage after the update is successful
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage(productId:widget.productId,)),
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text("Next", style: TextStyle(fontSize: 16)),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
