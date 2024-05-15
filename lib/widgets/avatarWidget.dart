import 'package:flutter/material.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/screens/profileView.dart';

class AvatarWidget extends StatelessWidget {
  final UserModel userModel;

  const AvatarWidget({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => profileView(
                uid: userModel.uid,
              ),
          ),
        );
      },
      child: CircleAvatar(
        backgroundImage: userModel.profileImage == null
            ? AssetImage('assets/profileBasic.png') as ImageProvider :
        NetworkImage(userModel.profileImage!),
        radius: 18,
      ),
    );
  }
}
