import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onTap;
  const AdminHomeScreen({
    Key? key,
    required this.pages,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Técnicos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
