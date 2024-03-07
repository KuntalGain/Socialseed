import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextConst {
  static TextStyle headingStyle(double size, Color? color) {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color,
    ));
  }

  static TextStyle MediumStyle(double size, Color? color) {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
    ));
  }

  static TextStyle RegularStyle(double size, Color? color) {
    return GoogleFonts.montserrat(
        textStyle: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
    ));
  }
}
