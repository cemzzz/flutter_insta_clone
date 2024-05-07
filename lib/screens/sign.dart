import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instgram_clone/providers/auth_provider.dart';
import 'package:instgram_clone/screens/login.dart';
import 'package:instgram_clone/widgets/errorDialog.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../exceptions/exception.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});



  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> _globalKey =  GlobalKey<FormState>();
  //검증 로직을 위한거
  TextEditingController _emailConfirm = TextEditingController(); //이메일 확인용
  TextEditingController _nameConfirm = TextEditingController(); //이름 확인용
  TextEditingController _pwdConfirm = TextEditingController(); //비밀번호 확인용

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled; //첫 검증은 우선 off
  //갤러리에서 사진가져오기 위한 거
  Uint8List? _image;
  bool _isEnabled = true;

  Future<void> selectImage() async{
    ImagePicker imagePicker = new ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );

    if(file != null) {
      Uint8List unit8list = await file.readAsBytes();
      setState(() {
        _image = unit8list;
      });
    }
  }

  @override
  void dispose(){
    _emailConfirm.dispose();
    _nameConfirm.dispose();
    _pwdConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=> FocusScope.of(context).unfocus(),
        child :Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true, // listview 공간 정리
                  reverse: true,
                  children: [
                    //인스타 그램 로고
                    SvgPicture.asset(
                      'assets/instaSvg.svg',
                      height: 64,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    SizedBox(height: 20),
                    //프로필 사진
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          _image == null ?
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profileBasic.png'),
                          ) :
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                          ),
                          Positioned(
                            left: 60,
                            bottom: -10,
                            child: IconButton(
                              onPressed: _isEnabled ?  () async {
                                await selectImage();
                              } : null,
                              icon: Icon(Icons.add_a_photo),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //이메일
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _emailConfirm, // 이메일 확인
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '이메일',
                        prefix: Icon(Icons.email),
                        filled: true,
                      ),
                      //이메일 검증
                      validator: (value) {
                        // 미입력, 공백 입력, 이메일 형식이 아닌 경우 확인
                        if(value == null || value.trim().isEmpty || !isEmail(value.trim())){
                          return '이메일을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    //이름
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _nameConfirm, // 이름
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '이름',
                        prefix: Icon(Icons.account_circle),
                        filled: true,
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return '이름을 입력해주세요';
                        }
                        if (value.length < 2 || value.length > 10){
                          return '이름은 최소 2글자, 최대 10글자 내에서 입력해주세요. ';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    //패스워드
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _pwdConfirm, //비빌번호 확인용
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호',
                        prefix: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value){
                        if(value == null || value.trim().isEmpty){
                          return '비밀번호를 입력해주세요.';
                        }
                        if (value.length < 6){
                          return '비밀번호는 최소 6글자 이상 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    //패스워드 확인
                    TextFormField(
                      enabled: _isEnabled,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '비밀번호 확인',
                        prefix: Icon(Icons.lock),
                        filled: true,
                      ),
                      validator: (value){
                        if(_pwdConfirm.text != value){
                          return '패스워드가 일치하지 않습니다.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40,),
                    //회원가입
                    ElevatedButton(
                      onPressed: _isEnabled ? () async {
                        final form = _globalKey.currentState;

                        if(form == null || !form.validate()){
                          return;
                        }
                        setState(() {
                          _isEnabled = false;
                          _autovalidateMode = AutovalidateMode.always; // 버튼 누르는 순간 검증 로직 항상 실행
                        });
                        //회원 가입 성공 시
                        try{
                          await context.read<AuthProviders>().signUp(
                            email: _emailConfirm.text,
                            name: _nameConfirm.text,
                            password: _pwdConfirm.text,
                            profileImage: _image,
                          );
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LogIn())
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('인증 메일을 전송했습니다.'),
                              duration: Duration(seconds: 60),
                            ),
                          );
                        } on CustomException catch (e){
                          setState(() {
                            _isEnabled = true;
                          });
                          errorDialog(context, e);
                        }
                      } : null,
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20),
                        padding: EdgeInsets.all(15),
                      ),
                    ),
                    SizedBox(height: 10,),
                    //로그인 화면 이동
                    TextButton(
                        onPressed: _isEnabled ? () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => LogIn())
                        ) : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('계정이 있으신가요? ' , style: TextStyle(fontSize: 15),),
                            Text(' 로그인', style: TextStyle(color: Colors.blue, fontSize: 15),)
                          ],
                        )
                    )

                  ].reversed.toList(),
                ),
              ),
            ),
          ),
        )
    );

  }
}
