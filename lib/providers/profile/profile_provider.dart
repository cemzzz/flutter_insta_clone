import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/repositories/feed_repository.dart';
import 'package:instgram_clone/repositories/profile_repository.dart';

class ProfileProvider extends StateNotifier<ProfileState> with LocatorMixin{
  ProfileProvider() : super(ProfileState.init());

  likeFeed({
    required FeedModel newFeedModel,
  }) {
    state = state.copyWith(profileStatus: ProfileStatus.submitting);

    try {
      List<FeedModel> newFeedList = state.feedList.map((feed) {
        return feed.feedId == newFeedModel.feedId ? newFeedModel : feed;
      }).toList();

      state = state.copyWith(
          profileStatus: ProfileStatus.success,
          feedList: newFeedList
      );
    } on CustomException catch (_){
      state = state.copyWith(profileStatus: ProfileStatus.error);
    }

  }

  Future<void> followUser({
    required String currentUserId,
    required String followId,
  }) async{
    state = state.copyWith(profileStatus: ProfileStatus.submitting);
    try{
      UserModel userModel = await read<ProfileRepository>().followUser(currentUserId: currentUserId, followId: followId);

      state = state.copyWith(
        profileStatus: ProfileStatus.success,
        userModel: userModel,
      );
    } on CustomException catch (_){
      state = state.copyWith(profileStatus: ProfileStatus.error);
    }

  }

  Future<void> getProfile({
   required String uid
  }) async {
    state = state.copyWith(profileStatus: ProfileStatus.fetching);

    try{
      UserModel userModel = await read<ProfileRepository>().getProfile(uid: uid);
      List<FeedModel> feedList = await read<FeedRepository>().getFeedList(uid: uid);

      state = state.copyWith(
        profileStatus: ProfileStatus.success,
        feedList: feedList,
        userModel: userModel,
      );
    } on CustomException catch (_){
      state = state.copyWith(profileStatus: ProfileStatus.error);
    }

  }

}