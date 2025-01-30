// burada temalandirma + renkler + ... yazicaz.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'constants.dart';

// theme_provider.dart
class ThemeProvider with ChangeNotifier {
  bool _isDark = true;
  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

const colors = {
  "primary": Color.fromARGB(255, 65, 159, 217),
  "onPrimary": Color.fromARGB(255, 255, 255, 255),
  "secondary": Color.fromARGB(255, 241, 241, 241),
  "onSecondary": Color.fromARGB(255, 82, 76, 100),
  "surface": Color.fromARGB(255, 255, 255, 255),
  "onSurface": Color.fromARGB(255, 82, 76, 100),
  "success": Colors.green,
  "error": Colors.red,
  "onError": Colors.white,
};

const darkColors = {
  "primary": Color.fromARGB(255, 43, 82, 120),
  "onPrimary": Color.fromARGB(255, 241, 241, 241),
  "secondary": Color.fromARGB(255, 32, 43, 54),
  "onSecondary": Color.fromARGB(255, 241, 241, 241),
  "surface": Color.fromARGB(255, 23, 33, 43),
  "onSurface": Color.fromARGB(255, 245, 245, 245),
  "success": Colors.green,
  "error": Colors.red,
  "onError": Colors.white,
};

final lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: colors["primary"]!,
    onPrimary: colors["onPrimary"]!,
    secondary: colors["secondary"]!,
    onSecondary: colors["onSecondary"]!,
    error: colors["error"]!,
    onError: colors["onError"]!,
    surface: colors["surface"]!,
    onSurface: colors["onSurface"]!,
  ),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(
        // fontSize: 32,
        ),
    bodyMedium: GoogleFonts.roboto(),
    bodyLarge: GoogleFonts.roboto(),
    labelSmall: GoogleFonts.roboto(),
    labelMedium: GoogleFonts.roboto(),
    labelLarge: GoogleFonts.roboto(),
    titleSmall: GoogleFonts.roboto(),
    titleMedium: GoogleFonts.roboto(),
    titleLarge: GoogleFonts.roboto(),
    headlineSmall: GoogleFonts.aBeeZee(),
    headlineMedium: GoogleFonts.aBeeZee(),
    headlineLarge: GoogleFonts.aBeeZee(),
    displaySmall: GoogleFonts.abrilFatface(),
    displayMedium: GoogleFonts.abrilFatface(),
    displayLarge: GoogleFonts.abrilFatface(),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    brightness: Brightness.dark,
    primary: darkColors["primary"]!,
    onPrimary: darkColors["onPrimary"]!,
    secondary: darkColors["secondary"]!,
    onSecondary: darkColors["onSecondary"]!,
    error: darkColors["error"]!,
    onError: darkColors["onError"]!,
    surface: darkColors["surface"]!,
    onSurface: darkColors["onSurface"]!,
  ),
  textTheme: TextTheme(
    bodySmall: GoogleFonts.roboto(
        // fontSize: 30,
        ),
    bodyMedium: GoogleFonts.roboto(),
    bodyLarge: GoogleFonts.roboto(),
    labelSmall: GoogleFonts.roboto(),
    labelMedium: GoogleFonts.roboto(),
    labelLarge: GoogleFonts.roboto(),
    titleSmall: GoogleFonts.roboto(),
    titleMedium: GoogleFonts.roboto(),
    titleLarge: GoogleFonts.roboto(),
    headlineSmall: GoogleFonts.aBeeZee(),
    headlineMedium: GoogleFonts.aBeeZee(),
    headlineLarge: GoogleFonts.aBeeZee(),
    displaySmall: GoogleFonts.abrilFatface(),
    displayMedium: GoogleFonts.abrilFatface(),
    displayLarge: GoogleFonts.abrilFatface(),
  ),
);

// final lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primarySwatch: Colors.blue,
//   visualDensity: VisualDensity.adaptivePlatformDensity,
//   textTheme: GoogleFonts.latoTextTheme().copyWith(
//     titleSmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     titleMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     titleLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     bodySmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     bodyMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     bodyLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     headlineSmall: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     headlineMedium: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     headlineLarge: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     displaySmall: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     displayMedium: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     displayLarge: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     labelSmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     labelMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//     labelLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: colors["onSurface"],
//       ),
//     ),
//   ),
// );

// final darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.blue,
//   textTheme: GoogleFonts.latoTextTheme().copyWith(
//     titleSmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     titleMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     titleLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     bodySmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     bodyMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     bodyLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     headlineSmall: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     headlineMedium: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     headlineLarge: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     displaySmall: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     displayMedium: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     displayLarge: GoogleFonts.bebasNeue(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     labelSmall: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     labelMedium: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//     labelLarge: GoogleFonts.raleway(
//       textStyle: TextStyle(
//         color: darkColors["onSurface"],
//       ),
//     ),
//   ),
// );
