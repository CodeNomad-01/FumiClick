import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/agenda/data/appointment_repository.dart';
import 'features/agenda/presentation/agenda_controller.dart';
import 'features/agenda/presentation/agenda_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AppointmentRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgendaController(repository: repo)),
      ],
      child: MaterialApp(
        title: 'Fumi Click',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fumi Click'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Bienvenido a Fumi Click',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: const Text('Agendar fumigación (Chatbot)'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AgendaScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.list),
                label: const Text('Ver citas reservadas'),
                onPressed: () {
                  final repo = Provider.of<AgendaController>(context, listen: false).repository;
                  final booked = repo.getBookedAppointments();
                  final snackText = booked.isEmpty
                      ? 'No hay citas reservadas'
                      : 'Citas reservadas: ${booked.length}';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(snackText)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
