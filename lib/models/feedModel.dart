import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instgram_clone/models/userModel.dart';

class FeedModel{
  final String uid;
  final String feedId;
  final String post;
  final List<String> imageUrls;
  final List<String> likes;
  final int commentCount;
  final int likeCount;
  final Timestamp CreateAt;
  final UserModel writer;

  const FeedModel({
    required this.uid,
    required this.feedId,
    required this.post,
    required this.imageUrls,
    required this.likes,
    required this.commentCount,
    required this.likeCount,
    required this.CreateAt,
    required this.writer,
  });

  Map<String, dynamic> toMap({
    required DocumentReference<Map<String, dynamic>> userDocRef,
}) {
    return {
      'uid': this.uid,
      'feedId': this.feedId,
      'post': this.post,
      'imageUrls': this.imageUrls,
      'likes': this.likes,
      'commentCount': this.commentCount,
      'likeCount': this.likeCount,
      'CreateAt': this.CreateAt,
      'writer': userDocRef,
    };
  }

  factory FeedModel.fromMap(Map<String, dynamic> map) {
    return FeedModel(
      uid: map['uid'],
      feedId: map['feedId'],
      post: map['post'],
      imageUrls: List<String>.from(map['imageUrls']),
      likes: List<String>.from(map['likes']),
      commentCount: map['commentCount'] ?? 0,
      likeCount: map['likeCount'] ?? 0,
      CreateAt: map['CreateAt'] ?? Timestamp.now(),
      writer: map['writer'],
    );
  }

  @override
  String toString() {
    return 'FeedModel{'
        'uid: $uid,'
        ' feedId: $feedId,'
        ' post: $post,'
        ' imageUrls: $imageUrls,'
        ' likes: $likes,'
        ' commentCount: $commentCount,'
        ' likeCount: $likeCount,'
        ' CreateAt: $CreateAt,'
        ' writer: $writer'
        '}';
  }

}