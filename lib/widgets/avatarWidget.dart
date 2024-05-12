import 'package:flutter/material.dart';
import 'package:instgram_clone/models/userModel.dart';

class AvatarWidget extends StatelessWidget {
  final UserModel userModel;

  const AvatarWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: userModel.profileImage == null
          ? AssetImage('assets/profileBasic.png') as ImageProvider :
      NetworkImage(userModel.profileImage!),
      radius: 18,
    );
  }
}
