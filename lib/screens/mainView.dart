import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/providers/user/user_provider.dart';
import 'package:instgram_clone/screens/feedUpload.dart';
import 'package:instgram_clone/screens/feedView.dart';
import 'package:instgram_clone/screens/likeView.dart';
import 'package:instgram_clone/screens/profileView.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:provider/provider.dart';


class mainView extends StatefulWidget {
  const mainView({super.key});

  @override
  State<mainView> createState() => _mainViewState();
}

class _mainViewState extends State<mainView> with SingleTickerProviderStateMixin{
  late TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    _getProfile();
  }

  void bottomNavigationItemOnTab(int index){
    setState(() {
      tabController.index = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  Future<void> _getProfile() async {
    try{
      await context.read<UserProvider>().getUserInfo();
    } on CustomException catch(e) {
      errorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          FeedView(),
          Center(child: Text('2'),),
          FeedUpload(
            onFeedUploaded: () {
              setState(() {
                tabController.index = 0;
              });
            },
          ),
          LikeView(),
          profileView(
            uid: context.read<User>().uid,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: tabController.index,
        onTap: bottomNavigationItemOnTab,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '피드'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '찾기'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: '업로드'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '좋아요'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '프로필'
          ),
        ],
      )
    );
  }
}

