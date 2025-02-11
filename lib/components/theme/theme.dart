import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/constant/app_colors.dart';
import '../../core/utils/app_util.dart';

class AppTheme {
  AppTheme();

  static ThemeData light() => ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColor.whiteFAFAFA,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            disabledForegroundColor: AppColor.greyD2D2D2,
            shadowColor: AppColor.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                4.sp,
              ),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            minimumSize: Size(
              double.minPositive,
              34.sp,
            ),
            elevation: 0,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shadowColor: AppColor.transparent,
            foregroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                4.sp,
              ),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            minimumSize: Size(
              double.minPositive,
              34.sp,
            ),
            elevation: 0,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 10.sp,
            vertical: 10.sp,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          fillColor: AppColor.transparent,
          errorStyle: GoogleFonts.inter(
            fontWeight: FontWeight.normal,
            color: AppColor.redCF1322,
            fontSize: 10.sp,
          ),
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.normal,
            color: AppColor.grey,
            fontSize: 10.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
            borderSide: BorderSide(
              color: AppColor.greyD2D2D2,
              style: BorderStyle.solid,
              width: 1.sp,
            ),
          ),
          outlineBorder: BorderSide(
            color: AppColor.greyD2D2D2,
            style: BorderStyle.solid,
            width: 1.sp,
          ),
          errorMaxLines: 3,
          filled: true,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            elevation: 0,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            disabledForegroundColor: AppColor.greyD2D2D2,
            shadowColor: AppColor.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                4.sp,
              ),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
            minimumSize: Size(
              double.minPositive,
              34.sp,
            ),
            elevation: 0,
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          confirmButtonStyle: ElevatedButton.styleFrom(
            backgroundColor: AppColor.blue0C5697,
            shadowColor: AppColor.transparent,
            foregroundColor: AppColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                100.sp,
              ),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            minimumSize: Size(
              double.minPositive,
              24.sp,
            ),
            elevation: 0,
          ),
          cancelButtonStyle: TextButton.styleFrom(
            disabledForegroundColor: AppColor.greyD2D2D2,
            shadowColor: AppColor.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                100.sp,
              ),
            ),
            textStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            minimumSize: Size(
              double.minPositive,
              24.sp,
            ),
            elevation: 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              4.sp,
            ),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: MaterialColor(
            AppColor.orangeEC6B0C.value,
            AppColor.lightSwatch,
          ),
          backgroundColor: AppColor.white,
        ).copyWith(surface: AppColor.white).copyWith(error: AppColor.redCF1322),
        drawerTheme: DrawerThemeData(
          endShape: const RoundedRectangleBorder(),
          shape: const RoundedRectangleBorder(),
          backgroundColor: AppColor.white,
          elevation: 0,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.inter(
            color: AppColor.black1C1C1C,
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
          backgroundColor: AppColor.white,
          toolbarHeight: AppUtil.appBarTH(),
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(
            color: AppColor.black1C1C1C,
            size: 20.sp,
          ),
          centerTitle: true,
          titleSpacing: 0,
          elevation: 0,
        ),
        tabBarTheme: TabBarTheme(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return AppColor.blueDEE8F2;
              }
              return null;
            },
          ),
          indicatorColor: AppColor.blue436BDE,
          labelColor: AppColor.black,
          dividerHeight: 0,
          unselectedLabelColor: AppColor.grey,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColor.white, // Set background color to white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.sp), // Set border radius to 8.0
          ),
        ),
      );
}
