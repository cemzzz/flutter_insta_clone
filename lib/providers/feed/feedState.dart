enum FeedStatus{
  init, // FeedState 최초 객체 생성
  submitting, // 게시글을 등록하는 도중 상태
  success, // 작업 성공 상태
  error, // 업로드 에러 상태
}

//게시글 상태 관리
class FeedState{
  final FeedStatus feedStatus;

  const FeedState({
    required this.feedStatus,
  });

  factory FeedState.init() {
    return FeedState(
        feedStatus: FeedStatus.init,
    );
  }

  FeedState copyWith({
    FeedStatus? feedStatus,
  }) {
    return FeedState(
      feedStatus: feedStatus ?? this.feedStatus,
    );
  }


}