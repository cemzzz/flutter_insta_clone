import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/providers/feed/feedProvider.dart';
import 'package:instgram_clone/providers/feed/feedState.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:provider/provider.dart';

class FeedUpload extends StatefulWidget {
  final VoidCallback onFeedUploaded;

  const FeedUpload({super.key, required this.onFeedUploaded});

  @override
  State<FeedUpload> createState() => _FeedUploadState();
}

class _FeedUploadState extends State<FeedUpload> {

  final TextEditingController _postCtrl = TextEditingController();
  final List<String> _files = [];

  Future<List<String>> selectImage() async{
    List<XFile> images = await ImagePicker().pickMultiImage(
      maxWidth: 1024,
      maxHeight: 1024
    );
    return images.map((e) => e.path).toList();
  }

  List<Widget> selectedImageList() {
    final feedStatus = context.watch<FeedState>().feedStatus;

    return _files.map((data) {
      return Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(File(data),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.3,
              width: 200,),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: InkWell(
                onTap: feedStatus == FeedStatus.submitting ? null :  (){
                  setState(() {
                    _files.remove(data);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(60),
                  ),
                
                  height: 30,
                  width: 30,
                  child: Icon(
                    color: Colors.black.withOpacity(0.6),
                    size: 30,
                    Icons.highlight_remove_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  void dispose(){
    _postCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feedStatus = context.watch<FeedState>().feedStatus;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: (_files.length == 0 || feedStatus == FeedStatus.submitting) ? null : () async{
                try{
                  FocusScope.of(context).unfocus();

                  await context.read<FeedProvider>().uploadFeed(
                    files: _files,
                    post: _postCtrl.text, //게시글
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('게시글을 등록했습니다.')),
                  );

                  widget.onFeedUploaded();
                } on CustomException catch (e){
                  errorDialog(context, e);
                }

              },
              child: Text('게시하기')
          )
        ],
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  value: feedStatus == FeedStatus.submitting ? null : 1,
                  color : feedStatus == FeedStatus.submitting ? Colors.blue : Colors.transparent
                ),
                Column(
                    children: [
                      InkWell(
                        onTap: feedStatus == FeedStatus.submitting ? null : () async{
                          final images = await selectImage();
                          setState(() {
                            _files.addAll(images);
                          });
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.upload),
                        ),
                      ),
                      SizedBox(height: 20,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ...selectedImageList(),
                          ],
                        ),
                      )
                    ],
                  ),
                SizedBox(height: 20,),
                if(_files.isNotEmpty)
                  TextFormField(
                    controller: _postCtrl,
                    decoration: const InputDecoration(
                      hintText: '내용을 입력하세요',
                      border: InputBorder.none,
                    ),
                    maxLines: 6,
                  ),
              ],
            
            ),
          ),
        ),
      ),
    );
  }
}

