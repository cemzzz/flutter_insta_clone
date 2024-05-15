import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/feed/feedProvider.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:instgram_clone/widgets/postWidget.dart';
import 'package:provider/provider.dart';


import '../utils/logger.dart';
import '../widgets/avatarWidget.dart';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> with AutomaticKeepAliveClientMixin<FeedView>{
  late final FeedProvider feedProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedProvider = context.read<FeedProvider>();
    _getFeedList();
  }

  void _getFeedList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await feedProvider.getFeedList();
      } on CustomException catch(e){
        errorDialog(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FeedState feedState = context.watch<FeedState>();
    List<FeedModel> feedList = feedState.feedList;

    if(feedState.feedStatus == FeedStatus.fetching){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if(feedState.feedStatus == FeedStatus.success && feedList.length == 0){
      return Center(
        child: Text('게시글이 존재하지 않습니다.'),
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async{
          _getFeedList();
        },
        child: ListView.builder(
            itemCount: feedList.length,
            itemBuilder: (context, index){
              return FeedWidget(feedModel: feedList[index]);
            }
        ),
      ),
    );

  }

}

