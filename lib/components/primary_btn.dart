import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
  });
  final Function onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: black2,
        surfaceTintColor: black2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        onPressed();
      },
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: getScreenWidth(context) * 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}