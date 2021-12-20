import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.title, required this.colour, required this.onPressed, required this.heightSize, required this.widthSize}) : super(key: key);

  final String title;
  final Color colour;
  final VoidCallback onPressed;
  final double heightSize;
  final double widthSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightSize == 0 ? 65.0 : heightSize,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Material(
          elevation: 5.0,
          color: colour,
          borderRadius: BorderRadius.circular(15.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: widthSize == 0 ? double.infinity : widthSize,
            height: 42.0,
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}