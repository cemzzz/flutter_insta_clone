import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instgram_clone/providers/auth_provider.dart';  // 별칭 없이 여기에 정의된 AuthProvider 사용
import 'package:instgram_clone/providers/auth_state.dart';
import 'package:instgram_clone/repositories/auth_repository.dart';
import 'package:instgram_clone/screens/mainView.dart';
import 'package:instgram_clone/screens/sign.dart';
import 'package:instgram_clone/screens/splash.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/login.dart';


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
        StreamProvider<User?>(
          create: (context) => FirebaseAuth.instance.authStateChanges(),
          initialData: null,
        ),
        StateNotifierProvider<AuthProviders, AuthState>(
         create: (context) => AuthProviders(),
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
    return mainView();
  }
}

