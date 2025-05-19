import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
bool isDark =false;
Brightness _brightness = Brightness.light ;

  Brightness get brightness => (isDark)?Brightness.dark:Brightness.light;

  bool get isDarkMode => _brightness == Brightness.dark;

  void toggleTheme() {
    isDark=!isDark;
    notifyListeners();
  }
}
