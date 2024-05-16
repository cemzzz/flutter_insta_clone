import 'package:flutter/material.dart';
import 'package:instgram_clone/models/commentModel.dart';
import 'package:instgram_clone/models/userModel.dart';
import 'package:instgram_clone/widgets/avatarWidget.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel commentModel;

  const CommentWidget({
    super.key,
    required this.commentModel,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    CommentModel commentModel = widget.commentModel;
    UserModel writer = commentModel.writer;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          AvatarWidget(userModel: writer),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text : writer.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  WidgetSpan(child: SizedBox(width: 15,)),
                  TextSpan(
                    text : commentModel.comment,
                  ),
                ]
              )),
              SizedBox(height: 7,),
              Text(
                commentModel.createdAt.toDate().toString().split(' ')[0],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
