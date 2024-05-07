import 'package:flutter/material.dart';
import 'package:instgram_clone/exceptions/exception.dart';

void errorDialog(BuildContext context, CustomException e){
  showDialog(
    context: context,
    barrierDismissible: false, // 팝업 나올때 영역 외 다른 곳 터치 시 닫히지 않게 설정
    builder: (context){
      return AlertDialog(
        //에러코드 메시지
        title: Text(e.code),
        content: Text(e.message),
        actions: [
          TextButton(
              onPressed: ()=> Navigator.pop(context),
              child: Text('확인'),
          )
        ],
      );
    }
  );

}