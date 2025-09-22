import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/agenda/presentation/appointment_form_screen.dart';
import 'package:fumi_click/features/agenda/presentation/appointment_history_screen.dart';
import 'package:fumi_click/features/auth/presentation/login_screen.dart';
import 'package:fumi_click/features/auth/provider/user_with_role_provider.dart';
import 'package:fumi_click/features/chatbot/presentation/chatbot_screen.dart';
import 'package:fumi_click/features/home/home.dart';
import 'package:fumi_click/features/profile/presentation/profile_screen.dart';
import 'package:fumi_click/firebase_options.dart';
import 'package:fumi_click/utils/material-theme/lib/theme.dart';
import 'package:fumi_click/utils/material-theme/lib/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
  final userWithRole = ref.watch(userWithRoleProvider);

    TextTheme textTheme = createTextTheme(context, "Inter", "Roboto Flex");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fumi Click',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: _buildHome(userWithRole),
    );
  }

  Widget _buildHome(UserWithRoleState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.firebaseUser == null) {
      return const LoginScreen();
    }
    if (state.role == 'tecnico') {
      return const Scaffold(
        body: Center(child: Text('Bienvenido técnico', style: TextStyle(fontSize: 24))),
      );
    }
    // Usuario normal
    return HomeScreen(
      pages: const [
        AppointmentFormScreen(),
        ChatbotScreen(),
        AppointmentHistoryScreen(),
        ProfileScreen(),
      ],
    );
  }
  }

