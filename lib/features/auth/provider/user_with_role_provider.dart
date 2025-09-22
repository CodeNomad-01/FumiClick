import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fumi_click/features/profile/data/user_profile.dart';
import 'package:fumi_click/features/profile/infrastructure/user_profile_repository.dart';
import 'package:fumi_click/features/profile/provider/user_profile_provider.dart';

class UserWithRoleState {
  final User? firebaseUser;
  final UserProfile? profile;
  final bool isLoading;
  final Object? error;

  UserWithRoleState({
    this.firebaseUser,
    this.profile,
    this.isLoading = false,
    this.error,
  });

  String? get role => profile?.role;
}

class UserWithRoleNotifier extends StateNotifier<UserWithRoleState> {
  final FirebaseAuth _auth;
  final UserProfileRepository _profileRepo;

  UserWithRoleNotifier(this._auth, this._profileRepo)
      : super(UserWithRoleState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        state = UserWithRoleState(firebaseUser: null, profile: null, isLoading: false);
      } else {
        state = UserWithRoleState(firebaseUser: user, isLoading: true);
        try {
          final profile = await _profileRepo.loadCurrentUserProfile();
          state = UserWithRoleState(firebaseUser: user, profile: profile, isLoading: false);
        } catch (e) {
          state = UserWithRoleState(firebaseUser: user, profile: null, isLoading: false, error: e);
        }
      }
    });
  }

  Future<void> reloadProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    state = UserWithRoleState(firebaseUser: user, isLoading: true);
    try {
      final profile = await _profileRepo.loadCurrentUserProfile();
      state = UserWithRoleState(firebaseUser: user, profile: profile, isLoading: false);
    } catch (e) {
      state = UserWithRoleState(firebaseUser: user, profile: null, isLoading: false, error: e);
    }
  }
}

final userWithRoleProvider = StateNotifierProvider<UserWithRoleNotifier, UserWithRoleState>((ref) {
  final auth = FirebaseAuth.instance;
  final profileRepo = ref.read(userProfileRepositoryProvider);
  return UserWithRoleNotifier(auth, profileRepo);
});
