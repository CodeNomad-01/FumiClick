import 'package:flutter/material.dart';
import 'package:fumi_click/features/admin/agenda/presentation/tecnico_appointments_screen.dart';
import 'package:fumi_click/features/admin/home/admin_home_screen.dart';
import 'package:fumi_click/features/admin/profile/presentation/admin_profile_screen.dart';
import 'package:fumi_click/features/admin/presentation/technical_account_manager_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key}) : super(key: key);

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    AdminAppointmentsScreen(),
    TechnicalAccountManagerScreen(),
    AdminProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminHomeScreen(
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
