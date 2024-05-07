import 'package:flutter/material.dart';

class FeedUpload extends StatefulWidget {
  const FeedUpload({super.key});

  @override
  State<FeedUpload> createState() => _FeedUploadState();
}

class _FeedUploadState extends State<FeedUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: (){

              },
              child: Text('feed')
          )
        ],
      ),
      body: Container(
        height: 100,
        width: 100,
        child: const Icon(Icons.upload),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10)
        ),
      ),
    );
  }
}
