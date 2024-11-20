import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:untitled/views/customer/customer_home.dart';

class BarcodeScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (BarcodeCapture capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                if (code != null) {
                  print('Scanned Code: $code');
                  Navigator.pop(context, code); // Return the scanned code
                } else {
                  print('No valid barcode detected.');
                }
              }
            },
          ),
          // Optional: Add an SVG or overlay for visual guidance
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.03,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/barcode.svg',
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Scanner Example'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Navigate to the BarcodeScannerPage and await the scanned result
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BarcodeScannerPage(),
              ),
            );
            if (result != null) {
              // Show the scanned barcode result
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Scanned Barcode'),
                  content: Text(result),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            } else {
              print('No barcode returned.');
            }
          },
          child: Text('Scan Barcode'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CustomerHomePage(),
  ));
}
