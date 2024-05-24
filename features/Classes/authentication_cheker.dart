import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mirea_messenger/authentication.dart';
import 'package:mirea_messenger/massenger_diallogs_screen.dart';

class CheckAuth extends StatelessWidget {
  const CheckAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data?.emailVerified == true){
            return Dialogs();
          } else{
            return Registartion();
          }
        },
      ),
    );
  }
}