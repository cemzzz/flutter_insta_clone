import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/models/commentModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/providers/comment/comment_provider.dart';
import 'package:instgram_clone/providers/comment/comment_state.dart';
import 'package:instgram_clone/providers/user/user_state.dart';
import 'package:instgram_clone/utils/logger.dart';
import 'package:instgram_clone/widgets/avatarWidget.dart';
import 'package:instgram_clone/widgets/commentWidget.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class CommnetView extends StatefulWidget {
  final String feedId;

  const CommnetView({
    super.key,
    required this.feedId,
  });

  @override
  State<CommnetView> createState() => _CommnetViewState();
}

class _CommnetViewState extends State<CommnetView> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _commentCtrl = TextEditingController();
  late final CommentProvider commentProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentProvider = context.read<CommentProvider>();
    _getCommentList();
  }

  void _getCommentList(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await commentProvider.getCommentList(feedId: widget.feedId);
      } on CustomException catch (e) {
        errorDialog(context, e);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUserModel =  context.read<UserState>().userModel;
    CommentState commentState = context.watch<CommentState>();
    bool _isEnabled = commentState.commentStatus != CommentStatus.submitting;

    if(commentState.commentStatus == CommentStatus.fetching){
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: commentState.commentList.length,
          itemBuilder: (context, index) {
            return CommentWidget(commentModel: commentState.commentList[index]);
          },
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), //키보드가 열려도 댓글이 위로 올라오도록 하는 속성ㅏ
        color: Colors.black87,
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              AvatarWidget(userModel: currentUserModel,),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(9),
                    child: TextFormField(
                      controller: _commentCtrl,
                      enabled: _isEnabled,
                      decoration: InputDecoration(
                        hintText: '댓글을 입력해주세요..',
                        border: InputBorder.none,
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return '댓글을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
              ),
              IconButton(
                  onPressed: _isEnabled ? () async {
                    FocusScope.of(context).unfocus();

                    FormState? form = _formKey.currentState;

                    if(form == null || !form.validate()){
                      return;
                    }
                    try{
                      //댓글 등록 기능
                      await context.read<CommentProvider>().uploadComment(
                        feedId: widget.feedId,
                        uid: currentUserModel.uid,
                        comment: _commentCtrl.text,
                      );
                    } on CustomException catch (e) {
                      errorDialog(context, e);
                    }
                    _commentCtrl.clear();
                  } : null,
                  icon: Icon(Icons.comment)
              ),
            ],
          ),
        ),
      )
    );
  }
}
