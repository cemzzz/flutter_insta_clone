import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/providers/auth/auth_provider.dart';  // 별칭 없이 여기에 정의된 AuthProvider 사용
import 'package:instgram_clone/providers/auth/auth_state.dart';
import 'package:instgram_clone/providers/comment/comment_provider.dart';
import 'package:instgram_clone/providers/comment/comment_state.dart';
import 'package:instgram_clone/providers/feed/feedProvider.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/providers/like/like_provider.dart';
import 'package:instgram_clone/providers/like/like_state.dart';
import 'package:instgram_clone/providers/profile/profile_provider.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/providers/user/user_provider.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/repositories/auth_repository.dart';
import 'package:instgram_clone/repositories/comment_repository.dart';
import 'package:instgram_clone/repositories/feed_repository.dart';
import 'package:instgram_clone/repositories/like_repository.dart';
import 'package:instgram_clone/repositories/profile_repository.dart';
import 'package:instgram_clone/screens/login.dart';
import 'package:instgram_clone/screens/mainView.dart';
import 'package:instgram_clone/screens/splash.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.signOut();
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
            create: (context) => AuthRepository(
                firebaseAuth: FirebaseAuth.instance,
                firebaseStorage: FirebaseStorage.instance,
                firebaseFirestore: FirebaseFirestore.instance,
            )
        ),
        Provider<FeedRepository>(
          create: (context) => FeedRepository(
            firebaseStorage: FirebaseStorage.instance,
            firebaseFirestore: FirebaseFirestore.instance,
          )
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
              firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<LikeRepository>(
          create: (context) => LikeRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        Provider<CommentRepository>(
          create: (context) => CommentRepository(
            firebaseFirestore: FirebaseFirestore.instance,
          ),
        ),
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StateNotifierProvider<AuthProviders, AuthState>(
         create: (context) => AuthProviders(),
        ),
        StateNotifierProvider<UserProvider, UserState>(
          create: (context) => UserProvider(),
        ),
        StateNotifierProvider<FeedProvider, FeedState>(
          create: (context) => FeedProvider(),
        ),
        StateNotifierProvider<ProfileProvider, ProfileState>(
          create: (context)=> ProfileProvider(),
        ),
        StateNotifierProvider<LikeProvider, LikeState>(
          create: (context)=> LikeProvider(),
        ),
        StateNotifierProvider<CommentProvider, CommentState>(
          create: (context)=> CommentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}

