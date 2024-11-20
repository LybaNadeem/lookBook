import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Controllers/designer_controller.dart';
import 'Designer_detail.dart';
class DesignersPage extends StatefulWidget {
  @override
  _DesignersPageState createState() => _DesignersPageState();
}
class _DesignersPageState extends State<DesignersPage> {
  final DesignerController _designerController = DesignerController();
  List<Map<String, String>> designers = [];
  bool isLoading = true;
  Map<String, String>? selectedDesigner;
  @override
  void initState() {
    super.initState();
    _fetchDesigners();
    displayDesignerInfo(); // Fetch designer details on page load
  }
  void _fetchDesigners() async {
    designers = await _designerController.getDesigners();
    setState(() {
      isLoading = false;
    });
  }
  // Function to display the specific designer's information in a ListTile format
  Future<void> displayDesignerInfo() async {
    String userId = 'sDl8DYgRX3SHQYTXbhftOxNBR1W2';
    try {
      Map<String, String> designerInfo = await _designerController.getDesignerById(userId);
      setState(() {
        selectedDesigner = designerInfo;
      });
    } catch (e) {
      print('Error fetching designer info: $e');
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
            selectedDesigner != null
                ? ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(selectedDesigner!['profileImage']!),
              ),
              title: Text(
                selectedDesigner!['fullName'] ?? 'No Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                selectedDesigner!['phone'] ?? 'No Phone',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              trailing: Icon(Icons.arrow_forward, color: Color(0xFFE47F46)),
            )
                : Text(
              'Loading designer details...',
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: designers.length,
                itemBuilder: (context, index) {
                  final designer = designers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DesignerDetail(),
                          ),
                        );
                      },
                      child: Container(
                        height: 90.0,
                        child: Card(
                          shadowColor: Color(0xFF8F9CD6).withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.transparent, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(designer['image']!),
                            ),
                            title: Text(
                              '${designer['name']} (Designer)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              designer['phone']!,
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            trailing: Icon(Icons.arrow_forward, color: Color(0xFFE47F46)),
                          ),
                        ),
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