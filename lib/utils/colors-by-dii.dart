import 'package:flutter/material.dart';

// ignore: use_full_hex_values_for_flutter_colors
Color primary = const Color(0xff578585);

// ignore: use_full_hex_values_for_flutter_colors
Color primary1 = const Color(0xff242037);

// ignore: use_full_hex_values_for_flutter_colors
Color secondary = const Color(0xffCAC4CE);

// ignore: use_full_hex_values_for_flutter_colors
Color secondary1 = const Color(0xffF1F7F7);
// ignore: use_full_hex_values_for_flutter_colors
Color secondary2 = const Color(0xffF36A44);
// ignore: use_full_hex_values_for_flutter_colors
Color secondary3 = const Color(0xffF7ECE2);
// ignore: use_full_hex_values_for_flutter_colors
Color secondary4 = const Color(0xffC5D6D5);
Color btnColor = const Color(0xff0EC4E0);

// ignore: use_full_hex_values_for_flutter_colors
Color rouge = const Color(0xff9D0208);
// ignore: use_full_hex_values_for_flutter_colors
Color blanc = const Color(0xffffffff);
// ignore: use_full_hex_values_for_flutter_colors
Color meuveFonce = const Color(0xFFC22AF4);
Color jaune = const Color(0xFFf2aa02);
Color jauneVoiture = const Color(0xFFeca400);
Color vertFonce = const Color(0xFF2E8C1F);
Color vert = const Color(0xFF3bb628);
Color jauneLogement = const Color(0xFFffd60a);

// ignore: use_full_hex_values_for_flutter_colors
Color meuveClair = const Color(0xFFFBF4FE);

// ignore: use_full_hex_values_for_flutter_colors
Color gris = const Color(0xFFE7E7E7);
// ignore: use_full_hex_values_for_flutter_colors
Color noir = const Color(0xFF000000);
Color bleu = const Color(0xFF072ac8);
Color vertVoiture = const Color(0xFF06a77d);
Color orange = const Color.fromARGB(195, 251, 147, 11);

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
