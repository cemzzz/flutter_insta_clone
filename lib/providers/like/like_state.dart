import 'package:instgram_clone/models/feedModel.dart';

enum LikeStatus {
  init,
  submitting,
  fetching,
  success,
  error,
}

class LikeState {
  final LikeStatus likeStatus;
  final List<FeedModel> likeList;

  const LikeState({
    required this.likeStatus,
    required this.likeList,
  });
  
  factory LikeState.init(){
    return LikeState(
        likeStatus: LikeStatus.init,
        likeList: [],
    );
  }

  LikeState copyWith({
    LikeStatus? likeStatus,
    List<FeedModel>? likeList,
  }) {
    return LikeState(
      likeStatus: likeStatus ?? this.likeStatus,
      likeList: likeList ?? this.likeList,
    );
  }

  @override
  String toString() {
    return 'LikeState{likeStatus: $likeStatus, likeList: $likeList}';
  }

}