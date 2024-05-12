import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instgram_clone/exceptions/exception.dart';

class AuthRepository{
  final FirebaseAuth firebaseAuth;
  final FirebaseStorage firebaseStorage;
  final FirebaseFirestore firebaseFirestore;

  const AuthRepository({
    required this.firebaseAuth,
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  Future<void> logOut() async{
    await firebaseAuth.signOut();
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async{
    try{
      UserCredential userCredentialr =  await firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      //인증메일 확인 여부에 따른 로그인 가능 여부
      bool isVerified = userCredentialr.user!.emailVerified;
      if(!isVerified){
        await userCredentialr.user!.sendEmailVerification();
        await firebaseAuth.signOut();
        throw CustomException(
          code: 'Exception',
          message: '인증되지 않은 이메일',
        );
      }
    } on FirebaseException catch(e){
      throw CustomException(
          code: e.code,
          message: e.message!,
      );
    } catch (e){
      throw CustomException(
        code: 'Exception',
        message: e.toString(),
      );
    }
    
  }

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required Uint8List? profileImage,
  }) async{
    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      //유저 고유 uid값 부여
      String uid = userCredential.user!.uid;

      //메일 인증
      await userCredential.user!.sendEmailVerification();

      //프로필 이미지 저장
      String? downloadURL;

      if(profileImage != null){
        Reference ref = firebaseStorage.ref().child('profile').child(uid);
        TaskSnapshot snapshot = await ref.putData(profileImage);
        downloadURL = await snapshot.ref.getDownloadURL();
      }

      await firebaseFirestore.collection('users').doc(uid).set(
          {
            'uid' : uid,
            'email' : email,
            'name' : name,
            'profileImage' : downloadURL,
            'feedCount' : 0,
            'likes' : [],
            'followers' : [],
            'following' : [],
          }
      );
      firebaseAuth.signOut();
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

}