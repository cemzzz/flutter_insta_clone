import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instgram_clone/models/userModel.dart';


class ProfileRepository{
  final FirebaseFirestore firebaseFirestore;

  const ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<UserModel> getProfile({
    required String uid,
  }) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await firebaseFirestore.collection('users').doc(uid).get();
    return UserModel.fromMap(snapshot.data()!);
  }

}