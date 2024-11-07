import 'package:flutter/material.dart';

import '../main.dart';

extension BuildContextExtension on BuildContext {
  Color get black => themeLight ? Colors.black : Colors.white;

  double get height => size.height;
  // Color get primaryColor => const Color.fromARGB(255, 0, 64, 80);
  //#2707fb
  Color get primaryColor => const Color.fromARGB(255, 39, 7, 251);
  //secondary color:  #f07464
  Color get secondaryColor => const Color.fromARGB(255, 240, 116, 100);
  Size get size => MediaQuery.of(this).size;
  Color get thirdColor => const Color.fromARGB(255, 0, 64, 80);
  Color get white => themeLight ? Colors.white : Colors.black;
  double get width => size.width;
}
