import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/feed/feedProvider.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/providers/like/like_provider.dart';
import 'package:instgram_clone/providers/profile/profile_provider.dart';
import 'package:instgram_clone/providers/user/user_provider.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/screens/commentView.dart';
import 'package:instgram_clone/widgets/avatarWidget.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:instgram_clone/widgets/heartAnimation.dart';
import 'package:provider/provider.dart';

class FeedWidget extends StatefulWidget {
  final FeedModel feedModel;
  final bool isProfile;

  const FeedWidget({
    super.key,
    required this.feedModel,
    this.isProfile = false,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}


class _FeedWidgetState extends State<FeedWidget> {
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;
  bool isAnimating = false;

  Widget _imageZoomInOut(String imageUrl){
    return GestureDetector(
      onTap: (){
        showGeneralDialog(
            context: context,
            pageBuilder: (context, _, __) {
              return InteractiveViewer(
                  child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.network(imageUrl)
                  ),
              );
            },
        );
      },
      child: Image.network(
        imageUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _imageSliderWidget(List<String> imageUrls) {

      return GestureDetector(
        onDoubleTap: () async {
          await _likeFeed();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            CarouselSlider(
              carouselController: carouselController,
              items: imageUrls.map((url) => _imageZoomInOut(url)).toList(),
              options: CarouselOptions(
                  viewportFraction: 1.0,
                  height: MediaQuery.of(context).size.height * 0.35,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _indicatorIndex = index;
                    });
                  }
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageUrls
                        .asMap()
                        .keys
                        .map((e) {
                      return Container(
                        width: 10,
                        height: 10,
                        margin: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(_indicatorIndex == e
                              ? 0.9
                              : 0.4),
                        ),
                      );
                    }).toList()
                ),
              ),
            ),
            Opacity(
              opacity: isAnimating ? 1 : 0,
              child: HeartAnimation(
                isAnimating: isAnimating,
                child: Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 100,
                ),
                onEnd: () => setState(() {
                  isAnimating = false;
                }),
              ) ,
            ),
          ],
        ),
      );
    }

   Future<void> _likeFeed() async {
    if (context.read<FeedState>().feedStatus == FeedStatus.submitting){
      return;
    }
    try {
      isAnimating = true;
      FeedModel NewFeedModel = await context.read<FeedProvider>().likeFeed(
        feedId: widget.feedModel.feedId,
        feedLikes: widget.feedModel.likes,
      );
      if(widget.isProfile){
        context.read<ProfileProvider>().likeFeed(newFeedModel: NewFeedModel);
      }
      context.read<LikeProvider>().likeFeed(newFeedModel: NewFeedModel);

      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch (e) {
      errorDialog(context, e);
    }
   }

  @override
  Widget build(BuildContext context) {
    String currentUserId = context.read<UserState>().userModel.uid;

    FeedModel feedModel = widget.feedModel;
    UserModel userModel = feedModel.writer;
    bool isLike = feedModel.likes.contains(currentUserId);

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                AvatarWidget(userModel: userModel),
                SizedBox(width: 10,),
                Expanded(
                    child: Text(
                      userModel.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          _imageSliderWidget(feedModel.imageUrls),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async{
                    await _likeFeed();
                  },
                  child: HeartAnimation(
                    isAnimating: isAnimating,
                    child: isLike
                        ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                        : Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        ),
                  )
                ),
                SizedBox(width: 5,),
                Text(
                  feedModel.likeCount.toString(),
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(width: 10,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CommnetView(feedId: feedModel.feedId),
                        ));
                  },
                  child: Icon(
                    Icons.comment_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  feedModel.commentCount.toString(),
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text(
                  feedModel.CreateAt.toDate().toString().split(' ')[0],
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              feedModel.post,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
