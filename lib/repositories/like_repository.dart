import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';

class LikeRepository {
  final FirebaseFirestore firebaseFirestore;

  const LikeRepository({
    required this.firebaseFirestore,
  });

  Future<List<FeedModel>> getLikeList({
    required String uid,
  }) async{
    try{
      Map<String, dynamic> userMapData = await firebaseFirestore
          .collection('users')
          .doc(uid)
          .get()
          .then((value) => value.data()!);

      List<String> likes = List<String>.from(userMapData['likes']);

      List<FeedModel> likeList = await Future.wait(
          likes.map((feedId) async{
            DocumentSnapshot<Map<String, dynamic>> documentSnapshot
            = await firebaseFirestore
                .collection('feeds').doc(feedId).get();
            Map<String, dynamic> feedMapData = documentSnapshot.data()!;
            DocumentReference<Map<String,dynamic>> userDocRef = feedMapData['writer'];
            Map<String, dynamic> writerMapData = await userDocRef.get().then((value) => value.data()!);
            feedMapData['writer'] = UserModel.fromMap(writerMapData);
            return FeedModel.fromMap(feedMapData);
          }).toList()
      );
      return likeList;
    } catch (e) {
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
  }
}