import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/providers/auth_state.dart';
import 'package:instgram_clone/repositories/auth_repository.dart';
import 'package:provider/provider.dart';


class AuthProviders extends StateNotifier<AuthState> with LocatorMixin{
  AuthProviders() : super(AuthState.init());


  @override
  void update(Locator watch) {
    final user = watch<User?>();

    if(user != null && !user.emailVerified){
      return;
    }

    if(user == null && state.authStatus == AuthStatus.unauthenticated){
      return;
    }

    if(user != null){
      //로그인이 된 상태
      state = state.copyWith(
        authStatus: AuthStatus.authenticated,
      );
    } else {
      //로그아웃이 된 상태
      state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> logOut() async{
    await read<AuthRepository>().logOut();

    state = state.copyWith(
        authStatus: AuthStatus.unauthenticated,
    );
  }
  
  Future<void> signUp({
    required String email,
    required String name,
    required String password,
    required Uint8List? profileImage,
}) async{
    try {
      await read<AuthRepository>().signUp(
          email: email,
          name: name,
          password: password,
          profileImage: profileImage
      );
    } on CustomException catch (_){
      rethrow;
    }
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async{
    try{
      await read<AuthRepository>().logIn(
          email: email,
          password: password
      );

    } on CustomException catch (_){
      rethrow;
    }
  }

}