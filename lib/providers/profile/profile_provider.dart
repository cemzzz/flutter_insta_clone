import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/repositories/profile_repository.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin{
  ProfileProvider() : super(ProfileState.init());

  Future<void> getProfile({
   required String uid
  }) async {
    state = state.copyWith(profileStatus: ProfileStatus.fetching);

    UserModel userModel = await read<ProfileRepository>().getProfile(uid: uid);

    state = state.copyWith(
        profileStatus: ProfileStatus.success,
        userModel: userModel,
    );
  }

}