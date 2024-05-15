import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/auth/auth_provider.dart';
import 'package:instgram_clone/providers/profile/profile_provider.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/screens/feedView.dart';
import 'package:instgram_clone/screens/profilePostView.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:instgram_clone/widgets/postWidget.dart';
import 'package:provider/provider.dart';
import 'package:extended_image/extended_image.dart';


class profileView extends StatefulWidget {
  final String uid;

  const profileView({super.key, required this.uid});
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
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      try{
        await profileProvider.getProfile(uid: widget.uid);
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

  Widget _customButtonWidget({
    required String text,
    required AsyncCallback asyncCallback,
  }) {
    return TextButton(
      onPressed: () async {
        try{
          await asyncCallback();
        } on CustomException catch(e){
          errorDialog(context, e);
        }
      },
      child: Text(text),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(
            color: Colors.grey
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ProfileState profileState = context.watch<ProfileState>();
    // 프로필을 확인하려는 유저의 정보
    UserModel userModel = profileState.userModel;
    List<FeedModel> feedList = profileState.feedList;

    //현재 접속중인 유저의 정보
    UserModel currentUserModel = context.read<UserState>().userModel;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
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
                        _profileInfo(num: userModel.feedCount, label: '게시물'),
                        _profileInfo(num: userModel.followers.length, label: '팔로워'),
                        _profileInfo(num: userModel.following.length, label: '팔로잉'),
                      ],
                    ),
                  ),
                ],
              ),
              currentUserModel.uid == userModel.uid
                  ? _customButtonWidget(
                    text: '로그아웃',
                    asyncCallback: () async {
                      context.read<AuthProviders>().logOut();
                    }
                  )
                  : _customButtonWidget(
                    asyncCallback: () async {
                      await context.read<ProfileProvider>().followUser(
                          currentUserId: currentUserModel.uid,
                          followId: userModel.uid,
                      );
                    },
                    text : userModel.followers.contains(currentUserModel.uid) ? '언팔로우' : '팔로우')

              ,
              Expanded(  // 추가된 부분
                child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: feedList.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) =>
                                ProfilePostView(index: index),
                          ),
                        );
                      },
                      child: ExtendedImage.network(
                          feedList[index].imageUrls[0],
                          fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
