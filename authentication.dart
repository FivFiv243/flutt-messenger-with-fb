import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mirea_messenger/bloc/authentication_bloc/authentication__bloc.dart';
import 'package:mirea_messenger/features/animations/animated_autho_widget.dart';
import 'package:mirea_messenger/features/conection_check.dart';
import 'package:mirea_messenger/features/Classes/firebase_logic.dart';

class Registartion extends StatefulWidget {
  const Registartion({super.key});

  @override
  State<Registartion> createState() => _RegistartionState();
}

class _RegistartionState extends State<Registartion> {
  var tog = true;
  final _MailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _PasswordConfirmingController = TextEditingController();
  final _secretWordController = TextEditingController();
  final AuthenticationFeatchures Logger = AuthenticationFeatchures();
  late Timer _timer;
  late var WorkCheck ;


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


String ButtonText(bool tog){
  if(tog == true){
    return "Login";
  }
  else{
    return "Registrate";
  }
}
var forgotter = false;
dynamic EventPusher(){
  if(forgotter == false){
    return AuthoLogEvent();
  }
  else{
    return ForgotPasswordEvent();
  }
}

_userReggister()async{
  try {
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'mail': _MailController.text.trim(),
      'name': _MailController.text[0]+_MailController.text[2]+_MailController.text[3]+_MailController.text[5]+_MailController.text[7],
      'avatareURI': 'https://i.ytimg.com/vi/o1WdXILi2K4/hqdefault.jpg',
    },SetOptions(merge: true));
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('chats');
  } catch (e) {
    debugPrint(e.toString()); 
  }

}


final _AuthoBloc = AuthenticationBloc(GetIt.I<ConectionCheck>());
@override
  void initState() {
     _AuthoBloc.add(EventPusher());
    Timer.periodic(Duration(seconds: 2), (timer) { _AuthoBloc.add(EventPusher());});
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await FirebaseAuth.instance.currentUser?..reload();
      if(FirebaseAuth.instance.currentUser?.emailVerified == true){
        _timer.cancel();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ThemeInst = Theme.of(context);
    final QueryWidth = MediaQuery.of(context).size.width; //width for adaptive screen 
    final QueryHight = MediaQuery.of(context).size.height; // height for adaptive screen
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState> (
      bloc: _AuthoBloc,
      builder: (context, state){
        if(state is AuthoLogState){
          return SafeArea(
            child: SingleChildScrollView( 
            reverse: true,
            child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, QueryHight/25, QueryWidth/12, QueryHight/50),
                    child: Row(
                      children: [InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                        onTap: () {
                          if(tog == true){ setState(() {tog = !tog;});} 
                                    else{setState(() {tog = !tog;});}
                        },
                        onLongPress: ()=>null,
                        onSecondaryTapCancel: () => null,

                        child: SwitcherAutho(toggle: tog,),)],
                    )
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, QueryHight/20, 0, 0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Container(
                      width: QueryWidth/1.3,
                      child:
                        TextField(
                          style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color),
                          decoration: InputDecoration(
                            icon: Icon(Icons.mail, color: ThemeInst.iconTheme.color),
                            labelText: 'Your mail',
                            labelStyle: TextStyle(color: Theme.of(context).primaryTextTheme.bodySmall!.color!.withOpacity(0.5)),
                            border: OutlineInputBorder(),
                            disabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width:1,
                                style: BorderStyle.solid
                              )
                            ),
                        ),
                          controller: _MailController,maxLength: 254,onChanged: (value) => _MailController.text,
                        ),
                      ),
                      Container(
                        width: QueryWidth/1.3,
                        child:
                        TextField(
                          style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color),
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: ThemeInst.iconTheme.color,),
                            labelText: 'Your password',
                            labelStyle: TextStyle(color: Theme.of(context).primaryTextTheme.bodySmall!.color!.withOpacity(0.5)),
                            border: OutlineInputBorder(),
                            disabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width:1,
                                style: BorderStyle.solid,
                              )
                            ),
                          ),
                        controller: _PasswordController,maxLength: 64, onChanged: (value) => _PasswordController.text,),
                      ),
                      //Tween Animation to confirming password Text Field
                      TweenAnimationBuilder(
                        tween: Tween(
                          begin: tog? QueryWidth/QueryWidth : QueryWidth+1,
                        end: tog? QueryWidth+1 : QueryWidth/QueryWidth,),
                        duration: Duration(seconds: 1),
                          builder:(BuildContext contextW,double value1, _){
                            return  Container(

                                margin: EdgeInsets.fromLTRB(value1, 0, 0, 0),
                                width: QueryWidth/1.3,
                                child: TextField(
                              style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock_person_outlined, color: ThemeInst.iconTheme.color,),
                                labelText: 'Confirm your password',
                                labelStyle: TextStyle(color: Theme.of(context).primaryTextTheme.bodySmall!.color!.withOpacity(0.5)),
                                border: OutlineInputBorder(),
                                disabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width:1,
                                    style: BorderStyle.solid,
                                  )
                                ),
                              ),
                            enabled: !tog,
                            controller: _PasswordConfirmingController,maxLength: 64,
                            onChanged: (value) => _PasswordConfirmingController.text,),
                              );
                          }
                          ,),
                      OutlinedButton(
                        onPressed: ()async{
                          if(tog == false){
                            if(_PasswordConfirmingController.text.trim() == _PasswordController.text.trim()){
                                Logger.RegisterWithEmailAndPassword(_MailController.text.trim(), _PasswordController.text.trim()).whenComplete(() {
                                if(FirebaseAuth.instance.currentUser?.emailVerified == true){
                                  showDialog(
                                    context: context,
                                     builder: (context)=> new AlertDialog(
                                      backgroundColor: Colors.green,
                                      title: Text('You already confirmed yor mail,you can Login'),
                                    )
                                  );
                                }
                                if(FirebaseAuth.instance.currentUser?.emailVerified == false && FirebaseAuth.instance.currentUser !=null){
                                  Logger.ConfirmMail();
                                  _userReggister();
                                  showDialog(
                                    context: context,
                                     builder: (context)=> new AlertDialog(
                                      backgroundColor: Colors.green,
                                      title: Text('please go to your mail and cofirm, and Login'),
                                    )
                                  );
                                }
                                if(FirebaseAuth.instance.currentUser ==null){
                                  showDialog(
                                    context: context,
                                     builder: (context)=> new AlertDialog(
                                      backgroundColor: Colors.red,
                                      title: Text('your data huewo'),
                                    )
                                  );
                                }
                                }
                              );
                            }
                            else{
                              showDialog(
                                    context: context,
                                     builder: (context)=> new AlertDialog(
                                      backgroundColor: Colors.red,
                                      title: Text('Your passwords not equal'),
                                    )
                                  );
                            }
                          }
                          else{
                            Logger.LogInWithEmailANdPassword(_MailController.text.trim(), _PasswordController.text.trim()).whenComplete(() {
                              if(FirebaseAuth.instance.currentUser == null || FirebaseAuth.instance.currentUser?.emailVerified == false){
                                  showDialog(
                                        context: context,
                                        builder: (context)=> new AlertDialog(
                                          backgroundColor: Colors.red,
                                          title: Text('we have no user with your data'),
                                        )
                                      );
                                }
                              }
                            );
                            Logger.SignOutAcc();
                          }
                        }, 
                        child: Text("start chatting!")),
                        TextButton(
                          onPressed: (){forgotter = !forgotter; _AuthoBloc.emit(ForgotPasswordState());},
                          child: Text("forgot my password!"))
                      ],
                      )
                ],
              ),
            )
        );
      }
      if(state is ForgotPasswordState){
        return SafeArea(
          child: SingleChildScrollView( 
            reverse: true,
            child: Column(
              children:[
                Center(),
                Center(child:
                Container(
                  padding: EdgeInsets.fromLTRB(0, QueryHight/6, 0, 0),
                        width: QueryWidth/1.3,
                        child:
                          TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.mail),
                              labelText: 'Your mail',
                              border: OutlineInputBorder(),
                              disabledBorder:OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width:1,
                                  style: BorderStyle.solid
                                )
                              ),
                          ),
                            controller: _MailController,maxLength: 254,onChanged: (value) => _MailController.text,
                          ),
                        ),
                ),
                        OutlinedButton(
                        onPressed: (){
                          Logger.ForgotPassword(_MailController.text.trim());
                          showDialog(
                                    context: context,
                                     builder: (context)=> new AlertDialog(
                                      backgroundColor: Colors.green,
                                      title: Text('Check your email'),
                                    )
                                  );
                          },
                        child: Text("send me a messge!")),
                TextButton(
                          onPressed: (){forgotter = !forgotter; _AuthoBloc.add(EventPusher());},
                          child: Text("back to authentication!"))
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ) 
          )
        );
      }
      else{return Center(child:CircleAvatar());}
      }
    )
    );
  }
}
