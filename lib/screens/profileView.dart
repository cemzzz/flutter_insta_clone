import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/auth/auth_provider.dart';
import 'package:instgram_clone/providers/profile/profile_provider.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
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
      try{
        await profileProvider.getProfile(uid: uid);
      } on CustomException catch(e){
        errorDialog(context, e);
      }
    });

  }

  //게시물 위젯
  Widget _profileInfo({
    required int num,
    required String label,
  }) {
    return Column(
      children: [
        Text(num.toString(), style: TextStyle(
            fontSize: 24, fontWeight:FontWeight.bold),
        ),
        Text(label, style: TextStyle(
            color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel  userModel = context.read<ProfileState>().userModel;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(height: 20,),
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: userModel.profileImage == null
                        ? AssetImage('assets/profileBasic.png') as ImageProvider
                        : NetworkImage(userModel.profileImage!),
                    radius: 40,
                  ),
                  SizedBox(height: 5,),
                  Text(userModel.name),
                ],
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _profileInfo(num : userModel.feedCount, label: '게시물'),
                    _profileInfo(num : userModel.followers.length, label: '팔로워'),
                    _profileInfo(num : userModel.following.length, label: '팔로잉'),
                  ],
                ),
              ),

            ],
          ),
          TextButton(
              onPressed: () async{
                await context.read<AuthProviders>().logOut();
              },
              child: Text('로그아웃'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.grey
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
          ),
        ],
      ),
    );
  }

}
