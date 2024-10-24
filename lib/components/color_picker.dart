import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerWidget extends StatefulWidget {
  final TextEditingController controller;

  ColorPickerWidget({Key? key, required this.controller}) : super(key: key);

  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  final List<Color> selectedColors = [];
  Color pickerColor = Colors.blue; // Default color

  void _addColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (Color color) {
              setState(() {
                pickerColor = color;
              });
            },
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Select'),
            onPressed: () {
              setState(() {
                selectedColors.add(pickerColor);
              });

              // Save the selected color's hex code in the controller
              widget.controller.text = pickerColor.value.toRadixString(16);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _removeColor(int index) {
    setState(() {
      selectedColors.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Wrap(
              spacing: 10,
              runSpacing: 2,
              children: [
                ...selectedColors.asMap().entries.map((entry) {
                  int index = entry.key;
                  Color color = entry.value;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Stack(
                      children: [
                        SizedBox(width: 50, height: 40),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(color: Colors.black),
                          ),
                        ),
                        Positioned(
                          left: 25,
                          child: GestureDetector(
                            onTap: () => _removeColor(index),
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                GestureDetector(
                  onTap: _addColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}