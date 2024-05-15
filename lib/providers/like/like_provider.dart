import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/providers/like/like_state.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/repositories/like_repository.dart';

class LikeProvider extends StateNotifier<LikeState> with LocatorMixin {
  LikeProvider() : super(LikeState.init());

  void likeFeed({
    required FeedModel newFeedModel,
  }) {
    state = state.copyWith(likeStatus: LikeStatus.submitting);

    try{
      List<FeedModel> newLikeList = [];

      int index = state.likeList.indexWhere(
              (feedModel) => feedModel.feedId == newFeedModel.feedId
      );

      if(index == -1) {
        newLikeList = [newFeedModel, ...state.likeList];
      } else {
        state.likeList.removeAt(index);
        newLikeList = state.likeList.toList();
      }

      state = state.copyWith(
        likeStatus: LikeStatus.success,
        likeList: newLikeList,
      );
    }  on CustomException catch(_) {
      state = state.copyWith(likeStatus : LikeStatus.error);
      rethrow;
    }


  }

  Future<void> getLikeList() async{
    state = state.copyWith(likeStatus: LikeStatus.fetching);

    try {
      String uid = read<UserState>().userModel.uid;
      List<FeedModel> likeList = await read<LikeRepository>().getLikeList(uid: uid);

      state = state.copyWith(
        likeStatus: LikeStatus.success,
        likeList: likeList,
      );
    } on CustomException catch(_) {
      state = state.copyWith(likeStatus : LikeStatus.error);
      rethrow;
    }

  }
}