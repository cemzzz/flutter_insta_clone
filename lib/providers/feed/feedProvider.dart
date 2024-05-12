import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/repositories/feed_repository.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin{
  FeedProvider(): super(FeedState.init());

  Future<void> getFeedList() async {
    try {
      state = state.copyWith(feedStatus: FeedStatus.fetching);
      List<FeedModel> feedList = await read<FeedRepository>().getFeedList();
      state = state.copyWith(
          feedList: feedList,
          feedStatus: FeedStatus.success
      );
    } on CustomException catch (_) {
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