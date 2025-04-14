import 'package:beauty_center_frontend/screen/main_screen/MainScaffold.dart';
import 'package:beauty_center_frontend/utils/app_colors.dart';
import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/BookServiceModalBottomSheet.dart';
import 'package:beauty_center_frontend/widget/modal-bottom-sheet/CustomModalBottomSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'route_generator.dart';

void main() {

  runApp(
    ProviderScope(
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,

        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: AppColors.primary,
        ),

        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.light,
          accentColor: AppColors.black,
          primarySwatch: const MaterialColor(
              0xFFD3B6F9,
              <int, Color>{
                50: Color(0xFFF3EAFE),
                100: Color(0xFFE3CCFB),
                200: Color(0xFFD3B6F9),
                300: Color(0xFFBE98F3),
                400: Color(0xFFAB7DED),
                500: Color(0xFFD3B6F9), // Valore principale
                600: Color(0xFF9C6EE0),
                700: Color(0xFF8656D1),
                800: Color(0xFF7243C2),
                900: Color(0xFF5525A7),
              },
          ),
          errorColor: AppColors.red,
        ),
        iconTheme: IconThemeData(
          size: 24,
          color: AppColors.black
        ),
        shadowColor: AppColors.black.withOpacity(0.1),
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: GoogleFonts.quicksandTextTheme().copyWith(

        // labelLarge – bianco, grande
        labelLarge: GoogleFonts.quicksand(
          decoration: TextDecoration.none,
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.normal,
        ),

        // labelMedium – bottoni principali
        labelMedium: GoogleFonts.quicksand(
          decoration: TextDecoration.none,
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),

        // labelSmall – testi per azioni
        labelSmall: GoogleFonts.quicksand(
          decoration: TextDecoration.none,
          color: AppColors.white.withOpacity(0.5),
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),

        // displayLarge – testi generici
        displayLarge: GoogleFonts.quicksand(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),

        // displayMedium – input field
        displayMedium: GoogleFonts.quicksand(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),

        // displaySmall – input field
        displaySmall: GoogleFonts.quicksand(
          color: AppColors.black,
          fontWeight: FontWeight.normal,
          fontSize: 10,
        ),

        // headlineLarge – titoli
        headlineLarge: GoogleFonts.quicksand(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),


      inputDecorationTheme: InputDecorationTheme(
          errorMaxLines: 10,
          contentPadding: const EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withOpacity(0.1)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.black.withAlpha((255* 0.1).toInt())),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5)
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.red, width: 1.5),
          ),
          prefixIconColor: AppColors.black,
          labelStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontWeight: FontWeight.normal),
          hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.5), fontWeight: FontWeight.normal),
          errorStyle: TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.normal, overflow: TextOverflow.visible)
        ),

        useMaterial3: true,
      ),


      darkTheme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
          accentColor: AppColors.white,
          primarySwatch: const MaterialColor(
            0xFFD3B6F9,
            <int, Color>{
              50: Color(0xFFF3EAFE),
              100: Color(0xFFE3CCFB),
              200: Color(0xFFD3B6F9),
              300: Color(0xFFBE98F3),
              400: Color(0xFFAB7DED),
              500: Color(0xFFD3B6F9), // Valore principale
              600: Color(0xFF9C6EE0),
              700: Color(0xFF8656D1),
              800: Color(0xFF7243C2),
              900: Color(0xFF5525A7),
            },
          ),

          errorColor: AppColors.red,
        ),
        iconTheme: IconThemeData(
          size: 24,
          color: AppColors.white
        ),
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: GoogleFonts.quicksandTextTheme().copyWith(
          // labelLarge – bottoni secondari (scuro: nero)
          labelLarge: GoogleFonts.quicksand(
            decoration: TextDecoration.none,
            color: AppColors.black,
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),

          // labelMedium – bottoni principali (scuro: bianco)
          labelMedium: GoogleFonts.quicksand(
            decoration: TextDecoration.none,
            color: AppColors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),

          // labelSmall – testi per azioni (scuro: nero opaco)
          labelSmall: GoogleFonts.quicksand(
            decoration: TextDecoration.none,
            color: AppColors.black.withOpacity(0.5),
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),

          // displayLarge – testi generici (scuro: bianco)
          displayLarge: GoogleFonts.quicksand(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),

          // displayMedium – input field (scuro: bianco)
          displayMedium: GoogleFonts.quicksand(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),

          // displaySmall – input field (scuro: bianco)
          displaySmall: GoogleFonts.quicksand(
            color: AppColors.white,
            fontWeight: FontWeight.normal,
            fontSize: 10,
          ),

          // headlineLarge – titoli (scuro: bianco)
          headlineLarge: GoogleFonts.quicksand(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),


        inputDecorationTheme: InputDecorationTheme(
            errorMaxLines: 10,
            contentPadding: const EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5)
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.red, width: 1.5),
            ),
            prefixIconColor: AppColors.white,
            labelStyle: TextStyle(fontSize: 12, color: AppColors.white.withOpacity(0.5), fontWeight: FontWeight.normal),
            hintStyle: TextStyle(fontSize: 12, color: AppColors.white.withOpacity(0.5), fontWeight: FontWeight.normal),
            errorStyle: TextStyle(fontSize: 12, color: AppColors.red, fontWeight: FontWeight.normal, overflow: TextOverflow.visible)
        ),

        useMaterial3: true,
      ),
      //home: const MainScaffold(),
      home: Container(
        color: Colors.red,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Builder(
            builder: (context) => CustomButton(
                onPressed: () => CustomModalBottomSheet.show(child: BookServiceModalBottomSheet(), context: context),
                text: "premi"
            )
          )
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

