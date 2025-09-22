import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/user_profile.dart';
import '../infrastructure/user_profile_repository.dart';

final userProfileByEmailProvider = FutureProvider.family<UserProfile?, String>((ref, email) async {
  return await ref.read(userProfileRepositoryProvider).loadUserProfileByEmail(email);
});

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  return ref.watch(userProfileRepositoryProvider).watchCurrentUserProfile();
});

final saveUserProfileProvider = FutureProvider.family<void, UserProfile>((
  ref,
  profile,
) async {
  await ref.read(userProfileRepositoryProvider).saveCurrentUserProfile(profile);
});
