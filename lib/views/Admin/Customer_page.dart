import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Controllers/Customer_controller.dart';
import 'Customer_detail.dart';
// Change to Customer_detail screen

class CustomerPage extends StatefulWidget {
  @override
  _CustomerPageState createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerController _customerController =CustomerController();  // Change to customer controller
  List<Map<String, dynamic>> customers = [];  // Change variable name to 'customers'
  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    getCustomersByRoles();  // Fetch the customers by role on page load
  }

  void getCustomersByRoles() async {
    try {
      // Fetch the customers whose role is 'customer'
      List<Map<String, dynamic>> fetchedCustomers = await _customerController.getCustomersByRole('Customer');  // Change to 'Customer'
      setState(() {
        customers = fetchedCustomers;
        isLoading = false;  // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;  // Set loading to false in case of error
      });
      print('Error fetching customers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "LOOK\n BOOK",
              style: TextStyle(fontFamily: 'Agne', fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Customers',  // Change label to 'Customers'
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'TenorSans',
                letterSpacing: 1.5,
              ),
            ),
            SvgPicture.asset('assets/icons/3.svg'),
            SizedBox(height: 30.0),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                filled: true,
                fillColor: Color(0xFF8F9FEE).withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(60),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Dynamically display customer details in a list
            Expanded(
              child: ListView.builder(
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Pass userId and index to CustomerDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerDetailScreen(
                            userId: customers[index]['userId'],  // Pass the userId
                            index: index,  // Pass the index
                          ),
                        ),
                      );
                    },

                    child: Card(
                      elevation: 4.0, // Adds shadow and elevation
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          // Use the profileImage from the current customer
                          backgroundImage: NetworkImage(customers[index]['profileImage'] ?? 'https://via.placeholder.com/150'),
                        ),
                        title: Text(
                          customers[index]['fullName'] ?? 'No Name',  // Use fullName from current customer
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          customers[index]['phone'] ?? 'No Phone',  // Use phone from current customer
                          style: TextStyle(decoration: TextDecoration.underline),
                        ),
                        trailing: Icon(Icons.arrow_forward, color: Color(0xFFE47F46)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
