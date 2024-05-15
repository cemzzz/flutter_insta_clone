import 'package:flutter/material.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/providers/profile/profile_state.dart';
import 'package:instgram_clone/widgets/postWidget.dart';
import 'package:provider/provider.dart';

class ProfilePostView extends StatefulWidget {
  final int index;

  const ProfilePostView({
    super.key,
    required this.index,
  });

  @override
  State<ProfilePostView> createState() => _ProfilePostViewState();
}

class _ProfilePostViewState extends State<ProfilePostView> {
  @override
  Widget build(BuildContext context) {
    List<FeedModel> feedList = context.watch<ProfileState>().feedList;


    return Scaffold(
      body: SafeArea(
        child: FeedWidget(
          feedModel: feedList[widget.index],
          isProfile: true,
        ),
      ),
    );
  }
}
