import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/repositories/profile_repository.dart';

class UserProvider extends StateNotifier<UserState> with LocatorMixin{
  UserProvider(): super(UserState.init());

  Future<void> getUserInfo() async {
    try {
      String uid = read<User>().uid;
      UserModel userModel = await read<ProfileRepository>().getProfile(uid: uid);
      state = state.copyWith(userModel: userModel);
    } on CustomException catch(e){
      rethrow;
    }
  }

}