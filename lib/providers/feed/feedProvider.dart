import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/repositories/feed_repository.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin{
  FeedProvider(): super(FeedState.init());

  Future<FeedModel> likeFeed({
    required String feedId,
    required List<String> feedLikes,
  }) async {
    state.copyWith(feedStatus: FeedStatus.submitting);

    try{
      UserModel userModel = read<UserState>().userModel;

      FeedModel feedModel = await read<FeedRepository>().likeFeed(
        feedId: feedId,
        feedLikes: feedLikes,
        uid: userModel.uid,
        userLikes: userModel.likes,
      );
      List<FeedModel> newFeedList = state.feedList.map((feed) {
        return feed.feedId == feedId ? feedModel : feed;
      }).toList();

      state = state.copyWith(
          feedStatus: FeedStatus.success,
          feedList: newFeedList
      );

      return feedModel;
    } on CustomException catch (_){
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }


  }

  Future<void> getFeedList() async {
    try {
      state = state.copyWith(feedStatus: FeedStatus.fetching);
      List<FeedModel> feedList = await read<FeedRepository>().getFeedList();

      // 로그 확인
      print("Fetched feed list: $feedList");
      state = state.copyWith(
          feedList: feedList,
          feedStatus: FeedStatus.success
      );
    } on CustomException catch (e) {
      print("Error fetching feed list: $e");
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }
  }

  Future<void >uploadFeed({
    required List<String> files,
    required String post, // 게시글
  }) async{
    try{
      state.copyWith(feedStatus: FeedStatus.submitting);

      String uid = read<User>().uid;
      FeedModel feedModel = await read<FeedRepository>().uploadFeed(
          files: files,
          post: post,
          uid: uid
      );

      state = state.copyWith(
          feedStatus: FeedStatus.success,
          feedList: [feedModel, ...state.feedList]
      );
    } on CustomException catch (_){
      state = state.copyWith(feedStatus: FeedStatus.error);
      rethrow;
    }

  }
}