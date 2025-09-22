import 'package:flutter/material.dart';
import 'package:fumi_click/features/tecnico/home/tecnico_home_screen.dart';
import '../agenda/presentation/tecnico_appointments_screen.dart';
import '../profile/presentation/tecnico_profile_screen.dart';

class TecnicoMainScreen extends StatefulWidget {
  const TecnicoMainScreen({Key? key}) : super(key: key);

  @override
  State<TecnicoMainScreen> createState() => _TecnicoMainScreenState();
}

class _TecnicoMainScreenState extends State<TecnicoMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TecnicoAppointmentsScreen(),
    TecnicoProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return TecnicoHomeScreen(
      pages: _pages,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
