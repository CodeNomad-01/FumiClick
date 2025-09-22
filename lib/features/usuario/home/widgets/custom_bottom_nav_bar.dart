import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "ChatBot",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Historial"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ],
    );
  }
}
