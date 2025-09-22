import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/tecnico/agenda/presentation/tecnico_appointments_screen.dart';
import 'package:fumi_click/features/tecnico/home/tecnico_home_screen.dart';
import 'package:fumi_click/features/tecnico/home/tecnico_main_screen.dart';
import 'package:fumi_click/features/usuario/agenda/presentation/appointment_form_screen.dart';
import 'package:fumi_click/features/usuario/agenda/presentation/appointment_history_screen.dart';
import 'package:fumi_click/features/auth/presentation/login_screen.dart';
import 'package:fumi_click/features/auth/provider/user_with_role_provider.dart';
import 'package:fumi_click/features/usuario/chatbot/presentation/chatbot_screen.dart';
import 'package:fumi_click/features/usuario/home/home.dart';
import 'package:fumi_click/features/usuario/profile/presentation/profile_screen.dart';
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
      // Pantalla exclusiva para técnico
      return const TecnicoMainScreen();
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
