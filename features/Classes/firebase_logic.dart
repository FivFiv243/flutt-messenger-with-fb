import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:mirea_messenger/features/Classes/UserClass.dart';
class AuthenticationFeatchures{
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  Combiner(String A, String B ){
    if(A.substring(0,1).codeUnitAt(0) > B.substring(0,1).codeUnitAt(0)){
      return "$B\_$A";
    }else{
      return "$A\_$B";
    }
  }


  Future LogInWithEmailANdPassword(String _email, String _password)async{
    try{
      await _auth.currentUser?.reload();
      await _auth.signInWithEmailAndPassword(email: _email, password: _password);
    }catch(e){
      debugPrint("Errr sing in");
      return null;
    }
  }


  Future<Stream<QuerySnapshot>> getUserNameData(String name)async{
    if(name.length>0){
      try{
        return FirebaseFirestore.instance.collection('users').
        where('name' , isGreaterThanOrEqualTo: name, isLessThan: name + 'z')
        .snapshots();
      }catch(e){
        return FirebaseFirestore.instance.collection('users').
        where('name' , isEqualTo: '')
        .snapshots();
      }
    }else{
    try{
        debugPrint(":((((");
        final my = FirebaseAuth.instance.currentUser!.uid;
        return FirebaseFirestore.instance.collection('chatrooms').
        where('img$my',isNull: false )
        .snapshots();
      }catch(e){
        final my = FirebaseAuth.instance.currentUser!.uid;
        return FirebaseFirestore.instance.collection('chatrooms').
        where('img$my', isNull: false)
        .snapshots();
      }
    }
  }


  Future ForgotPassword(String _email)async{
    try{
      _auth.sendPasswordResetEmail(email: _email);
    }catch(e){
      debugPrint('qweqwe123');
    }
  }


  Future RegisterWithEmailAndPassword(String _email, String _password)async{
    try{
    await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
    }catch(e){
      debugPrint("123123");
      return null;
    }
  }


  Future ConfirmMail()async{
    try{
      if(_auth.currentUser?.emailVerified == false){
        _auth.currentUser?.sendEmailVerification();
      }else{
        return null;
      }
    }catch(e){
      debugPrint('errrrrrrrrr');
    }
  }


  Future SignOutAcc()async{
    try{
      _auth.signOut();
    }catch(e){
      debugPrint('smtsmtsmt');
    }
  }


  Future CheckYouserExistence(String _email)async{
    await FirebaseFirestore.instance.collection('users').where('email',isEqualTo:_email).get();
  }

 Future sendMessage(String To, String From, String message, String ChatIMGTo,String ChatImgFrom, String NameMy, String NameOpp)async{ // To and from needs id of users
    try{
      var opposit;
      var my = FirebaseAuth.instance.currentUser!.uid;
      if(my == From){
        opposit = To;
      }else{
        opposit = From;
      }
      await FirebaseFirestore.instance.collection('chatrooms').doc((Combiner(From, To)).hashCode.toString())
      .set({'last':message,
            'ChatUID': Combiner(From, To).hashCode.toString(),
            '$opposit'+'uid': From,
            '$my' +'uid': To,
            'img$my': ChatIMGTo,
            'img$opposit': ChatImgFrom, 
            '$my'+'opp': NameOpp,
            '$opposit' +'opp': NameMy,
            'ActivityBy': my.toString(),
            'group': false
      });


      await FirebaseFirestore.instance.collection('chatrooms').doc((Combiner(From, To)).hashCode.toString())
      .collection('messages')
      .add({
        'From': From,
        'To': To,
        'Time': DateTime.now().toUtc(),
        'Message': message,
        },
      );

      


      await FirebaseFirestore.instance.collection('users')
      .doc(From)
      .collection('chats')
      .doc(Combiner(From,To).hashCode.toString(),).set({
        'chatID':Combiner(From,To).hashCode.toString(),
        'lastAct':message,
        'lastActFrom':From,
      });

      await FirebaseFirestore.instance.collection('users')
      .doc(To)
      .collection('chats')
      .doc(Combiner(From,To).hashCode.toString(),).set({
        'chatID':Combiner(From,To).hashCode.toString(),
        'lastAct':message,
        'lastActFrom':From,
      });

    }catch(e){
      debugPrint(e){
        print(':((');
      }
    }
  }
  

  Future createGroup(List<UserClass> qwe, String myName, String MyUid, myImg)async{ // To and from needs id of users
    try{
      await FirebaseFirestore.instance.collection('chatrooms').doc((Combiner(qwe[0].uid + qwe.last.uid,MyUid)).hashCode.toString())
      .set({'last':'',
            'ChatUID': (Combiner(qwe[0].uid + qwe.last.uid,MyUid)).hashCode.toString(),
            'ActivityBy': MyUid.toString(),
            'group': true,
            MyUid.toString() + 'uid': MyUid,
            'img'+ MyUid:'https://avatars.mds.yandex.net/get-entity_search/1220991/832980099/orig',
            MyUid.toString()+'opp': ('chatroom'+ Combiner(qwe[0].uid + qwe.last.uid,MyUid)).substring(0,15), 
      });
      

      for(int i = 0; i< qwe.length; i++){
        await FirebaseFirestore.instance.collection('chatrooms').doc((Combiner(qwe[0].uid + qwe.last.uid,MyUid)).hashCode.toString())
              .update({
                 qwe[i].uid.toString() + 'uid': qwe[i].uid,
                 qwe[i].uid+ 'opp': ('chatroom'+ Combiner(qwe[0].uid + qwe.last.uid,MyUid)).substring(0,15),
                 'img'+qwe[i].uid: 'https://avatars.mds.yandex.net/get-entity_search/1220991/832980099/orig',
              });
            }

    }catch(e){
      debugPrint('we cant add group chat');
    }
  }

  Future SendGroupMessage(String ChatUID, String Message, String groupName, String MyUid)async{
    try{
      await FirebaseFirestore.instance.collection('chatrooms').doc(ChatUID).update(
        {
          'last':Message,
          'ActivityBy':MyUid,
        }
      );
      await FirebaseFirestore.instance.collection('chatrooms').doc(ChatUID).collection('messages').add({
        'From': MyUid,
        'To': ChatUID,
        'Time': DateTime.now().toUtc(),
        'Message': Message,
      });
    }catch(e){
        debugPrint(e.toString());
    }
  }


  Future<Stream<QuerySnapshot>> getChatData(String chatID)async{
    try{
      return FirebaseFirestore.instance.collection('chatrooms').
      doc(chatID).collection('messages').orderBy('Time', descending: false ).snapshots();
    }catch(e){
      debugPrint(":((((");
      return FirebaseFirestore.instance.collection('chatrooms').
      doc(chatID).collection('messages').orderBy('Time', descending: false ).snapshots();
    }
  }

Future<Stream<QuerySnapshot>> GetChatsIds()async{
  try{
    return FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('chats')
    .snapshots(); 
  }catch(e){
    return FirebaseFirestore.instance.collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('chats')
    .snapshots();
  }
}
}