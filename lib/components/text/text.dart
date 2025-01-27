import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static Text google({
    TextOverflow? overflow,
    Color? backgroundColor,
    TextAlign? textAlign,
    required String text,
    FontWeight? weight,
    bool? softWrap,
    int? maxLines,
    double? size,
    Color? color,
  }) =>
      Text(
        text.trim().isNotEmpty ? text.trim() : "...",
        style: GoogleFonts.poppins(
          backgroundColor: backgroundColor,
          fontWeight: weight,
          fontSize: size,
          color: color,
        ),
        textAlign: textAlign,
        maxLines: maxLines,
        softWrap: softWrap,
        overflow: overflow,
      );
}
