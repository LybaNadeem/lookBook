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
    'assets/images/picture2.jpg',
    'assets/images/picture3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
            // Image Carousel with Positioned Dots
            Stack(
              children: [
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
                Positioned(
                  bottom: 50, // Slightly above the button
                  left: 10,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
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
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/login'); // Navigate to the next screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Color(0xFFE47F46), // Orange button color
                      padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

            // "Continue" button at the bottom-right corner


    );
  }
}