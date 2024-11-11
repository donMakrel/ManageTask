import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final basicStyle = GoogleFonts.karla(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF080A38),
  );

  static final titleStyle = GoogleFonts.karla(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF080A38),
  );

  static final subtitleStyle = GoogleFonts.karla(
    fontSize: 16,
    color: const Color(0xFF555555),
  );

  static final taskStatusStyle = GoogleFonts.karla(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.green,
  );
}
