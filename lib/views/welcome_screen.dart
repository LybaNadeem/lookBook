import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

  final List<String> imgList = [
    'assets/images/picture 1.png',
    'assets/images/picture 2.png',
    'assets/images/picture 3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image Carousel
          CarouselSlider(
            items: imgList.map((imagePath) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: double.infinity,
              autoPlay: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),

          // Dots for Carousel
          Positioned(
            bottom: 40, // Same as the button
            left: 30, // Aligning the dots to the left side
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Aligning the dots to the start
              children: imgList.asMap().entries.map((entry) {
                int index = entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white // Highlight current index
                          : Colors.white.withOpacity(0.5), // Other dots
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Text Section
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FASHION',
                  style: TextStyle(
                    fontFamily: 'Agne',
                    fontSize: 54,
                    letterSpacing: 2.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height:0.5),
                Text(
                  'Discover the latest trends, styles, and exclusive collections.',
                  style: TextStyle(
                    fontFamily: 'TenorSans',
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Continue Button
          Positioned(
            bottom: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFE47F46), // Orange button color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Outfit_Variable_wght',
                  color: Colors.white, // Ensuring the text is white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
