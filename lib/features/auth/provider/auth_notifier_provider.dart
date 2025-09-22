import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fumi_click/features/auth/infrastructure/repository/auth_repository.dart';
import 'package:fumi_click/features/auth/provider/auth_provider.dart';

final authNotifierProvider = AsyncNotifierProvider<AsyncAuthNotifier, void>(() {
  return AsyncAuthNotifier();
});

class AsyncAuthNotifier extends AsyncNotifier {
  late final AuthRepository _authRepository;

  @override
  FutureOr build() async {
    _authRepository = ref.read(authRepositoryProvider);
  }

  User? get currentUser => _authRepository.currentUser;

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(
      () => _authRepository.createUserWithEmailAndPassword(email, password),
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authRepository.login(email, password),
    );
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_authRepository.logout);
  }
}
