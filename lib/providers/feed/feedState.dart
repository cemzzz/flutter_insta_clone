import 'package:instgram_clone/models/feedModel.dart';

enum FeedStatus{
  init, // FeedState 최초 객체 생성
  submitting, // 게시글을 등록하는 도중 상태
  fetching, // 게시글 목록을 가져오고 있는 도중
  success, // 작업 성공 상태
  error, // 업로드 에러 상태
}

//게시글 상태 관리
class FeedState{
  final FeedStatus feedStatus;
  final List<FeedModel> feedList;

  const FeedState({
    required this.feedStatus,
    required this.feedList,
  });

  factory FeedState.init() {
    return FeedState(
        feedStatus: FeedStatus.init,
        feedList: [],
    );
  }

  FeedState copyWith({
    FeedStatus? feedStatus,
    List<FeedModel>? feedList,
  }) {
    return FeedState(
      feedStatus: feedStatus ?? this.feedStatus,
      feedList: feedList ?? this.feedList,
    );
  }
}