import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Controllers/designer_controller.dart';
import 'Designer_detail.dart';

class DesignersPage extends StatefulWidget {
  @override
  _DesignersPageState createState() => _DesignersPageState();
}

class _DesignersPageState extends State<DesignersPage> {
  final DesignerController _designerController = DesignerController();
  List<Map<String, dynamic>> designers = [];  // To store designers data
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    getDesignersByRoles();  // Fetch the designers by role on page load
  }

  void getDesignersByRoles() async {
    try {
      // Fetch the designers whose role is 'designer'
      List<Map<String, dynamic>> fetchedDesigners = await _designerController.getDesignersByRole('Designer');
      setState(() {
        designers = fetchedDesigners;
        isLoading = false;  // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false;  // Set loading to false in case of error
      });
      print('Error fetching designers: $e');
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
              'Designers',
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
            // Dynamically display designer details in a list
            Expanded(
              child: ListView.builder(
                itemCount: designers.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Pass userId and index to CustomerDetailScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DesignerDetailScreen (
                            userId: designers[index]['userId'],  // Pass the userId
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
                          // Use the profileImage from the current designer
                          backgroundImage: NetworkImage(designers[index]['profileImage'] ?? 'https://via.placeholder.com/150'),
                        ),
                        title: Text(
                          designers[index]['fullName'] ?? 'No Name',  // Use fullName from current designer
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          designers[index]['phone'] ?? 'No Phone',  // Use phone from current designer
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
