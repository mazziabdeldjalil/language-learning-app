import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _primaryColor = const Color(0xFFFF8A00);
  int _gradientIndex = 1;

  Color get primaryColor => _primaryColor;

  final List<List<Color>> _gradients = [
    [Color(0xFFFF6B6B), Color(0xB2F03535)],
    [Color(0xFFFF8A00), Color(0xA3E0892C)],
    [Color(0xFFF39C12), Color(0xC7F6E335)],
    [Color(0xFF2ECC71), Color(0xFF6EE5A2)],
    [Color(0xFF4ECDC4), Color(0xFF2AF991)],
    [Color(0xFF3498DB), Color(0xFF6308DA)],
    [Color(0xFF00B3FC), Color(0xFF33C4FF)],
    [Color(0xFF7C83FD), Color(0xFF3A43E5)],
    [Color(0xFF9B59B6), Color(0xFFAF7AC5)],
    [Color(0xFFC0C1FF), Color(0xFF5E61F5)],
    [Color(0xFFE74C3C), Color(0xFFEC7063)],
    [Color(0xFF1ABC9C), Color(0xFF48C9B0)],
  ];

  List<Color> get currentGradient =>
      _gradients[_gradientIndex % _gradients.length];

  void setColorByIndex(int index) {
    _gradientIndex = index % _gradients.length;
    _primaryColor = _gradients[_gradientIndex][0];
    notifyListeners();
  }

  void changePrimaryColor(Color newColor) {
    _primaryColor = newColor;
    notifyListeners();
  }
}