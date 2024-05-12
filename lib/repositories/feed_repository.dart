import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:uuid/uuid.dart';


class FeedRepository {
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const FeedRepository({
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  //게시글 리스트
  Future<List<FeedModel>> getFeedList() async {
    try{
      QuerySnapshot<Map<String, dynamic>> snapshot
      = await firebaseFirestore.collection('feeds').orderBy('CreateAt', descending: true).get();
      return await Future.wait(
          snapshot.docs.map((e) async{
            Map<String, dynamic> data = e.data();
            DocumentReference<Map<String, dynamic>> writerDocRef = data['writer'];
            DocumentSnapshot<Map<String, dynamic>> writerSnapshot = await writerDocRef.get();
            UserModel userModel = UserModel.fromMap(writerSnapshot.data()!);
            data['writer'] = userModel;
            return FeedModel.fromMap(data);
          }).toList()
      );
    } on FirebaseException catch (e){
      throw CustomException(
          code: e.code,
          message: e.message!
      );
    } catch (e){
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }


  Future<FeedModel> uploadFeed({
    required List<String> files,
    required String post, // 게시글
    required String uid,
  }) async {
    List<String> imageUrl = [];

    try{
      WriteBatch batch = firebaseFirestore.batch();

      String feedId = Uuid().v1();

      //firestore 문서 참조
      DocumentReference<Map<String, dynamic>> feedDocRef
      = firebaseFirestore.collection('feeds').doc(feedId);

      DocumentReference<Map<String, dynamic>> userDocRef
      = firebaseFirestore.collection('users').doc(uid);

      //fireStorage 참조하여 child()에 적힌 파일명에 생성
      Reference StorageRef = firebaseStorage.ref().child('feeds').child(feedId);

      imageUrl = await Future.wait(files.map((e) async {
        String imageId = Uuid().v1();
        TaskSnapshot taskSnapshot = await StorageRef.child(imageId).putFile(File(e));
        return await taskSnapshot.ref.getDownloadURL(); //이미지 접근할 수 있는 경로를 문자열로 반환
      }).toList());

      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userDocRef.get();
      UserModel userModel = UserModel.fromMap(userSnapshot.data()!);

      FeedModel feedModel = FeedModel.fromMap({
        'uid' : uid,
        'feedId' : feedId,
        'post' : post,
        'imageUrls' : imageUrl,
        'likes' : [],
        'likeCount' : 0,
        'commentCount' : 0,
        'createAt' : Timestamp.now(),
        'writer' : userModel,
      });

      batch.set(feedDocRef, feedModel.toMap(userDocRef: userDocRef));

      //게시글 등록 시 feed 수 증가
      batch.update(userDocRef, {
          'feedCount' : FieldValue.increment(1),
        });

      batch.commit();
      return feedModel;
    } on FirebaseException catch (e){
      _deleteImage(imageUrl);
      throw CustomException(
          code: e.code,
          message: e.message!
      );
    } catch (e){
      _deleteImage(imageUrl);
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }

  }
  //업로드 시 에러발생할 때 저장될 이미지 삭제
  void _deleteImage(List<String> imageUrl){
    imageUrl.forEach((element) async{
      await firebaseStorage.refFromURL(element).delete();
    });
  }

}