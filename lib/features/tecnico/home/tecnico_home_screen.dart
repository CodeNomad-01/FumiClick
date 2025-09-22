import 'package:flutter/material.dart';

class TecnicoHomeScreen extends StatelessWidget {
  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onTap;
  const TecnicoHomeScreen({Key? key, required this.pages, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio Técnico')),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
