import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:uuid/uuid.dart';


class FeedRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const FeedRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<void> uploadFeed({
    required List<String> files,
    required String post, // 게시글
    required String uid,
  }) async {
    String feedId = Uuid().v1();

    //firestore 문서 참조
    DocumentReference<Map<String, dynamic>> feedDocRef = firebaseFirestore.collection('feeds').doc(feedId);

    //fireStorage 참조하여 child()에 적힌 파일명에 생성
    Reference StorageRef = firebaseStorage.ref().child('feeds').child('feedId');

    List<String> imageUrl = await Future.wait(files.map((e) async {
      String imageId = Uuid().v1();
      TaskSnapshot taskSnapshot = await StorageRef.child(imageId).putFile(File(e));
      return await taskSnapshot.ref.getDownloadURL(); //이미지 접근할 수 있는 경로를 문자열로 반환
    }).toList());
    logger.d(imageUrl);
  }

}