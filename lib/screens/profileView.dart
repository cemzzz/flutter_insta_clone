import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/providers/profile/profile_provider.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:provider/provider.dart';

class profileView extends StatefulWidget {
  const profileView({super.key});

  @override
  State<profileView> createState() => _profileViewState();
}

class _profileViewState extends State<profileView> {
  late final ProfileProvider profileProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileProvider = context.read<ProfileProvider>();
    _getProfile();
  }

  void _getProfile() {
    String uid = context.read<User>().uid;
    WidgetsBinding.instance.addPersistentFrameCallback((_) async{
      await profileProvider.getProfile(uid: uid);
    });

  }

  @override
  Widget build(BuildContext context) {
    logger.d(context.watch<ProfileState>().userModel);
    return const Placeholder();
  }
}
