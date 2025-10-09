import 'package:flutter/material.dart';
import 'package:fumi_click/utils/whatsapp_util.dart';
import 'package:fumi_click/config/app_config.dart';

class TecnicoHomeScreen extends StatelessWidget {
  final List<Widget> pages;
  final int currentIndex;
  final ValueChanged<int> onTap;
  const TecnicoHomeScreen({
    Key? key,
    required this.pages,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio Técnico'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () async {
              try {
                await WhatsAppUtil.openWhatsAppSupport(
                  phoneNumber: AppConfig.whatsappSupportNumber,
                  defaultMessage: AppConfig.defaultMessages['tecnico']!,
                );
              } catch (e) {
                // Note: We can't use ScaffoldMessenger here since this is a StatelessWidget
                // The error will be handled by the WhatsAppUtil itself
                print('Error opening WhatsApp: $e');
              }
            },
            tooltip: 'Contactar por WhatsApp',
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
