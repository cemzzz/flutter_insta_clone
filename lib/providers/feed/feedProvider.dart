import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/repositories/feed_repository.dart';

class FeedProvider extends StateNotifier<FeedState> with LocatorMixin{
  FeedProvider(): super(FeedState.init());

  Future<void >uploadFeed({
    required List<String> files,
    required String post, // 게시글

  }) async{
    String uid = read<User>().uid;
    await read<FeedRepository>().uploadFeed(
        files: files,
        post: post,
        uid: uid
    );
  }
}