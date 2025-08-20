import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/presentation/login_screen.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';
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
    final userAsyncValue = ref.watch(userAuthProvider);

    TextTheme textTheme = createTextTheme(context, "Inter", "Roboto Flex");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fumi Click',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),

      home: userAsyncValue.when(
        data: (user) {
          return user == null
              ? const LoginScreen()
              : HomeScreen(pages: const [Placeholder(), ProfileScreen()]);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
