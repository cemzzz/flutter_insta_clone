import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instgram_clone/exceptions/exception.dart';
import 'package:instgram_clone/providers/auth_provider.dart';
import 'package:instgram_clone/providers/auth_state.dart';
import 'package:instgram_clone/screens/sign.dart';import 'package:instgram_clone/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../widgets/errorDialog.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> _globalKey =  GlobalKey<FormState>();
  //검증 로직을 위한거
  TextEditingController _emailConfirm = TextEditingController(); //이메일 확인용
  TextEditingController _pwdConfirm = TextEditingController(); //비밀번호 확인용

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled; //첫 검증은 우선 off

  bool _isEnabled = true;

  @override
  void dispose(){
    _emailConfirm.dispose();
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
                    //로그인 버튼
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

                        //로그인 로직
                        try{
                          logger.d(context.read<AuthState>().authStatus);
                          await context.read<AuthProviders>().logIn(
                              email: _emailConfirm.text,
                              password: _pwdConfirm.text
                          );

                          logger.d(context.read<AuthState>().authStatus);
                        } on CustomException catch (e){
                          setState(() {
                            _isEnabled = true;
                          });
                          errorDialog(context, e);
                        }
                      } : null,
                      child: Text('로그인'),
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
                            MaterialPageRoute(builder: (context) => SignUp())
                        ) : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('회원이 아니신가요? ' , style: TextStyle(fontSize: 15),),
                            Text(' 회원가입', style: TextStyle(color: Colors.blue, fontSize: 15),)
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

