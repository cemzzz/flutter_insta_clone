import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instgram_clone/models/feedModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/widgets/avatarWidget.dart';

class FeedWidget extends StatefulWidget {
  final FeedModel feedModel;

  const FeedWidget({super.key, required this.feedModel});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final CarouselController carouselController = CarouselController();
  int _indicatorIndex = 0;

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

      return Stack(
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
          )
        ],
      );
    }


  @override
  Widget build(BuildContext context) {
    FeedModel feedModel = widget.feedModel;
    UserModel userModel = feedModel.writer;

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
                Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
                SizedBox(width: 5,),
                Text(
                  feedModel.likeCount.toString(),
                  style: TextStyle(fontSize: 16),
                ),

                SizedBox(width: 10,),

                Icon(
                  Icons.comment_outlined,
                  color: Colors.white,
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
