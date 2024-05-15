import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/providers/like/like_provider.dart';
import 'package:instgram_clone/providers/like/like_state.dart';
import 'package:instgram_clone/screens/feedView.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:instgram_clone/widgets/postWidget.dart';
import 'package:provider/provider.dart';

class LikeView extends StatefulWidget {
  const LikeView({super.key});

  @override
  State<LikeView> createState() => _LikeViewState();
}

class _LikeViewState extends State<LikeView> with AutomaticKeepAliveClientMixin<LikeView>{
  late final LikeProvider likeProvider;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likeProvider = context.read<LikeProvider>();
    _getLikeList();
  }

  void _getLikeList() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await likeProvider.getLikeList();
      } on CustomException catch(e){
        errorDialog(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final likeState = context.watch<LikeState>();
    List<FeedModel> likeList = likeState.likeList;

    if(likeState.likeStatus == LikeStatus.fetching ){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if(likeState.likeList == LikeStatus.success && likeList.length == 0) {
      return Center(
        child: Text('좋아요를 누른 게시물이 존재하지 않습니다.') ,
      );
    }


    return SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _getLikeList();
          }, child: ListView.builder(
            itemCount: likeList.length,
            itemBuilder: (context, index){
              return FeedWidget(
                  feedModel: likeList[index],
              );
            }
          ),
        ),
    );
  }

}
