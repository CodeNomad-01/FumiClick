import 'package:flutter/material.dart';
import 'package:fumi_click/features/usuario/home/widgets/custom_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final List<Widget> pages;
  const HomeScreen({super.key, required this.pages});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
      body: widget.pages[_currentIndex],
    );
  }
}
