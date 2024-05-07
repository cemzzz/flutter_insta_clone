

import 'package:flutter/material.dart';
import 'package:instgram_clone/providers/auth_state.dart';
import 'package:instgram_clone/screens/login.dart';
import 'package:instgram_clone/screens/mainView.dart';
import 'package:provider/provider.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthState>().authStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //authenticated 상태에 따른 화면 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => authStatus == AuthStatus.authenticated ? mainView() : LogIn()),
            (route) => route.isFirst,
      );
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
