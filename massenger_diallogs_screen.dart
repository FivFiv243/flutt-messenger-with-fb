
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mirea_messenger/bloc/messeges_menu_bloc/messege_menu_bloc.dart';
import 'package:mirea_messenger/features/Classes/UserClass.dart';
import 'package:mirea_messenger/features/Classes/firebase_logic.dart';
import 'package:mirea_messenger/features/conection_check.dart';
import 'package:mirea_messenger/features/rive_utils/rive_utils.dart';
import 'package:mirea_messenger/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';




class Dialogs extends StatefulWidget {
  const Dialogs({super.key});

  @override
  State<Dialogs> createState() => _DialogsState();
}

// var img;
// XFile profileImage = XFile('C:/mirea_messenger/assets/image_asset/0fda90726363d4713798a.png');



class _DialogsState extends State<Dialogs> {
  String selectedFileName = '';
  late XFile file;
  var tog = true;
  late SMITrigger profileTrigger;
  late SMITrigger settingsTrigger;
  late SMITrigger chatsTrigger;
  late SMITrigger SearchTrigger;
  late SMITrigger messSend;
  var ChooseViever = 1;
  final _MainScreenBloc = ScreenMessBloc(GetIt.I<ConectionCheck>());
  final _NameController = TextEditingController();
  final _search_user_controller = TextEditingController();
  final _message_typing_controller = TextEditingController();
  late Stream UserStream;
  late Stream chatStream;
  UserClass curUr =UserClass(avatareURI: '', mail: '', name: '', uid: '', added: false);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; //firestore instance
  late String ChatImg, Chatname, uidUser, nameResaver, groupName, ChatUid;
  late bool group;
  List<UserClass> addedInGroup = [];
  List<String> containChecker= [];

  Future setImageOnAvatre()async{
    try{
      file = (await ImagePicker().pickImage(source: ImageSource.gallery))!;
      selectedFileName = file.name;
    }catch(e){
      debugPrint('zers');
    }
  } //Firebase Function that I can't include in Firebase_logic.dart class

  OnSearching()async{
      UserStream = await AuthenticationFeatchures().
      getUserNameData(_search_user_controller.text.trim());
  }


  InChat()async{
    if(group == false){
      chatStream  = await AuthenticationFeatchures().
      getChatData(AuthenticationFeatchures().Combiner(uidUser, FirebaseAuth.instance.currentUser!.uid)
      .hashCode.toString());
    }else{
      chatStream  = await AuthenticationFeatchures().
      getChatData(ChatUid);
    }
    
  }

  bool ThemeChecker(){
    if(Provider.of<ThemeProvider>(context, listen: false).themeData == false){
      return false;
    }
    else{return true;}
  }


  _NameSetter()async{
    try {
      if(_NameController.text.trim() != ""){
        await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({'name':_NameController.text.trim()});
      }else{
        _NameController.text = curUr.name;
        return showDialog(
            context: context,
            builder: (context)=> new AlertDialog(
            backgroundColor: Colors.red,
            title: Text('Name cant be empty'),
          )
        );
      }
    }catch(e){
      debugPrint('sry we cant save it');
    }
  }//Firebase Function that I can't include in Firebase_logic.dart class

  //Image setter in firebase
  _setImageinFirebase()async{
    try{
      firebase_storage.UploadTask uploadTask;

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      .ref()
      .child('avatares')
      .child(FirebaseAuth.instance.currentUser!.uid)
      .child('avi');

    uploadTask = ref.putFile(File(file.path));
    await uploadTask.whenComplete(() => null);
    selectedFileName = await ref.getDownloadURL();
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'avatareURI':selectedFileName});
    }catch(e){
      debugPrint(e.toString());
    }
  }//Firebase Function that I can't include in Firebase_logic.dart class


//get image from fb
_getAllFromFirebase()async{
  try{
    await _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
        nameResaver = value.data()!['name'].toString();
        curUr.name = value.data()!['name'].toString();
        curUr.uid =  value.data()!["uid"].toString();
        curUr.mail = value.data()!["mail"].toString();
        curUr.avatareURI = value.data()!["avatareURI"].toString();
        _NameController.text = curUr.name;
        selectedFileName = curUr.avatareURI;
        }
      ) ;
  }catch(e){
    debugPrint('Error in getting avatare from base');
  }
}//Firebase Function that I can't include in Firebase_logic.dart class


  dynamic EventPusher(){
  if(ChooseViever == 1){
    return ChatActivityEvent();
  }
  if(ChooseViever == 0){
    return ProfileActivityEvent();
  }
  if(ChooseViever==2){
    return SettingsActivityEvent();
  }
  if(ChooseViever == 3){
    return ChatConnectEvent();
  }
}
  @override


void initState() {
  _MainScreenBloc.add(EventPusher());
    Timer.periodic(Duration(seconds: 2), (timer) { _MainScreenBloc.add(EventPusher());});
    _NameSetter();
    _getAllFromFirebase();
    OnSearching();
    Timer.periodic(Duration(seconds: 1), (timer) { OnSearching();});
    AuthenticationFeatchures().GetChatsIds();
    super.initState();
  }


  Widget build(BuildContext context) {
    final ThemeInst = Theme.of(context);
    final toc = Theme.of(context);
    final QueryWidth = MediaQuery.of(context).size.width; //width for adaptive screen 
    final QueryHight = MediaQuery.of(context).size.height; // height for adaptive screen
    return Scaffold(
      
      bottomNavigationBar: ChooseViever<=2?
      
       SafeArea(child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: QueryWidth/110, vertical: 1),
          decoration: BoxDecoration(
            color: toc.bottomNavigationBarTheme.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Row(
            children: [
              Container(
                height: QueryHight/17.9,
                child:GestureDetector(
                  onTap: () {
                    profileTrigger.change(true);
                    ChooseViever = 0;
                    setState(() {});
                    _MainScreenBloc.add(EventPusher());
                  },
                  child:
                  Column(
                    children:[
                      SizedBox(
                        width: 30,
                        height: 30,
                      child: RiveAnimation.asset("assets/rive_assets/my_proj_mirea_icons.riv",
                        artboard: "Profile",
                        onInit: (artboard) {
                            StateMachineController controller = 
                            RiveUtils.GetRiveController(artboard, StateMachineName: "State Machine 1");
                            profileTrigger = controller.findSMI("Trigger 1");
                          },
                        )
                      ),
                      Text("profile", style:TextStyle(fontSize: QueryHight/69)),
                    ]
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(QueryWidth/3.11, 0, QueryWidth/3.11, 0),
                height: QueryHight/17.9,
                child:
                GestureDetector(
                  onTap:(){
                    ChooseViever = 1;
                    setState(() {});
                    _MainScreenBloc.add(EventPusher());
                    chatsTrigger.change(true);
                  },
                  child:Column(
                    children:[
                      SizedBox(
                        width: 30,
                        height: 30,
                      child: RiveAnimation.asset("assets/rive_assets/my_proj_mirea_icons.riv",
                        artboard: "Chats",
                        onInit: (artboard) {
                          StateMachineController controller = 
                            RiveUtils.GetRiveController(artboard, StateMachineName: "State Machine 2");
                            chatsTrigger = controller.findSMI("Trigger 2");
                        },
                        )
                      ),
                      Text("chats", style:TextStyle(fontSize: QueryHight/69)),
                    ]
                  ),
                ),
              ),
              Container(
                height: QueryHight/17.9,
                child:
                GestureDetector(
                  onTap: (){
                    ChooseViever = 2;
                    setState(() {});
                    _MainScreenBloc.add(EventPusher());
                    settingsTrigger.change(true);
                  },
                child:Column(
                  children:[
                    SizedBox(
                      width: 30,
                      height: 30,
                    child: RiveAnimation.asset("assets/rive_assets/my_proj_mirea_icons.riv",
                      artboard: "Settings",
                      onInit: (artboard){
                        StateMachineController controller = 
                            RiveUtils.GetRiveController(artboard, StateMachineName: "State Machine 1");
                            settingsTrigger = controller.findSMI("Trigger 1");
                      },
                      )
                    ),
                    Text("settings", style:TextStyle(fontSize: QueryHight/69)),
                  ]
                ),
                ),
              )
            ],
          ),
        )
      ):
      
      
      SafeArea(
              child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: QueryWidth/110, vertical: 1),
              decoration: BoxDecoration(
                color: toc.bottomNavigationBarTheme.backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
              child:ConstrainedBox(constraints: BoxConstraints(
        minHeight: 20,
          maxHeight: 180),
              
               child:Row(children:[
                Container(
                  width: QueryWidth/1.25,
                  child:
                    TextField(
                      onChanged: (value) { setState(() {}); },
                          controller: _message_typing_controller,
                          autocorrect: true,
                          minLines: 1,
                          maxLines: 20,
                          style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color, fontSize: 14),
                          decoration: InputDecoration(
                            counterText: '',
                          ),
                        ),
                      ),
                      Container(
                    height: QueryHight/17.9,
                    child:
                    GestureDetector(
                    onTap:(){
                      messSend.change(true);
                      if(_message_typing_controller.text.trim()!=""){
                        if(group == false){
                          AuthenticationFeatchures().sendMessage(uidUser
                          , FirebaseAuth.instance.currentUser!.uid
                          , _message_typing_controller.text.trim(), ChatImg, selectedFileName, _NameController.text.trim(), Chatname);
                        }else{
                          AuthenticationFeatchures().SendGroupMessage(ChatUid,
                           _message_typing_controller.text.trim(), 
                           Chatname, 
                           FirebaseAuth.instance.currentUser!.uid);
                        }
                      }
                      _message_typing_controller.text = "";
                    },
                        child: SizedBox(
                          width: 30,
                          height: 30,
                        child: RiveAnimation.asset("assets/rive_assets/my_proj_mirea_icons.riv",
                          artboard: "Mess throw",
                          onInit: (artboard) {
                            StateMachineController controller = 
                              RiveUtils.GetRiveController(artboard, StateMachineName: "State Machine 1");
                              messSend = controller.findSMI("Trigger 1");
                              },
                            )
                          ),
                        ),
                      )
                    ]
                  ) 
                ),
              )
              ),


      appBar: ChooseViever == 1?


      AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [InkWell(
          hoverDuration: Duration(milliseconds: 0),
          splashColor:Theme.of(context).appBarTheme.backgroundColor ,
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context)=> 
                      StatefulBuilder(
                      builder: (context, setState) { return
                      new AlertDialog(
                      backgroundColor: ThemeInst.scaffoldBackgroundColor,
                      title: Container(
                        width: QueryWidth/1.5,
                        height: QueryHight/1.5,
                        child: Column(
                          children: [
                            Container(
                              height: QueryHight/1.64,
                              child: StreamBuilder(
                                stream: UserStream,
                                builder: (context, snapshot){
                                  bool? groupChat;
                                  return snapshot.hasData? ListView.separated(
                                    itemCount: snapshot.data.docs.length,
                                    separatorBuilder: (context, index) {return groupChat == false?Divider(color: ThemeInst.dividerColor,indent: 20,endIndent: 20,):Container();},
                                    shrinkWrap: true,
                                    itemBuilder: (context, index){
                                      DocumentSnapshot DsU = snapshot.data.docs[index];
                                      String? ChatNameNullable,ChatImgNullable,LastMessageNullable,ActivityBy, ChatUidNullable;
                                          try{
                                            groupChat = DsU['group'];
                                            if(groupChat == false){
                                              ChatNameNullable = DsU[FirebaseAuth.instance.currentUser!.uid.toString()+'opp'];
                                              ChatImgNullable = DsU['img'+FirebaseAuth.instance.currentUser!.uid.toString()];
                                              LastMessageNullable = DsU['last'];
                                              ActivityBy = DsU['ActivityBy'];
                                              ChatUidNullable = DsU[FirebaseAuth.instance.currentUser!.uid.toString() + 'uid'];
                                            }
                                          }catch(e){
                                            debugPrint('nothing');
                                          }
                                      return Container(
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                                              ChatImgNullable!=null?
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(30), 
                                                child:Image.network(ChatImgNullable,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,),
                                              ):Container(child:null),
                                              Padding(padding: EdgeInsets.fromLTRB(QueryWidth/20, 0, 0, 0)),
                                              Row(children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                              ChatNameNullable!=null?  
                                              Text(
                                                style: TextStyle(fontSize: QueryWidth/25, color: ThemeInst.textTheme.bodyMedium?.color),
                                                ChatNameNullable):Container(child:null),
                                              LastMessageNullable!=null?Text(
                                                style: TextStyle(fontSize:  QueryWidth/25,color: ThemeInst.textTheme.bodyMedium?.color),
                                                ActivityBy == FirebaseAuth.instance.currentUser!.uid.toString()?
                                                ('You' +LastMessageNullable).length>15?
                                                ('You: '+LastMessageNullable).substring(0,15)+'...':'You: '+LastMessageNullable
                                                :(ChatNameNullable.toString()+LastMessageNullable).length>30?(ChatNameNullable!+': ' + LastMessageNullable).substring(0,30)+'...'
                                                :ChatNameNullable.toString()+': ' +LastMessageNullable
                                                ):Text(''),
                                                ]
                                              )
                                              ,
                                              Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0))
                                              ,
                                              groupChat == false?containChecker.contains(ChatUidNullable) == true?
                                              InkWell(
                                                    onTap: () {
                                                      addedInGroup.remove(UserClass(avatareURI: ChatImgNullable!, mail: '', name:ChatNameNullable!, uid: ChatUidNullable!, added: true));
                                                      containChecker.remove(ChatUidNullable);
                                                      setState(() {addedInGroup;containChecker;});
                                                    },
                                                    child:
                                                    Icon(Icons.delete_sharp) 
                                                  ):InkWell(
                                                    onTap: () {
                                                      addedInGroup.add(UserClass(avatareURI: ChatImgNullable!, mail: '', name:ChatNameNullable!, uid: ChatUidNullable!, added: true));
                                                      containChecker.add(ChatUidNullable);
                                                      setState(() {addedInGroup;containChecker;});
                                                    },
                                                    child:
                                                    Icon(Icons.add) 
                                                  ):Container()
                                              ]),
                                            ]
                                          )
                                        );
                                      
                                    },
                                  ) : Center(child: CircleAvatar(),);
                                }
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children:[OutlinedButton(onPressed:(){
                                Navigator.pop(context);
                                addedInGroup = [];
                                containChecker = [];
                              } , child: Text('cancel', style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color),)),OutlinedButton(onPressed: (){
                                AuthenticationFeatchures().createGroup(addedInGroup, nameResaver, FirebaseAuth.instance.currentUser!.uid, selectedFileName);
                                addedInGroup = [];
                                containChecker = [];
                              }, child: Text('add' , style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color),))]
                            )
                          ],
                        ),
                      ),
                      );
                      })
                    );
                  },
                  child: Icon(Icons.add,)),
                  Padding(padding: EdgeInsets.fromLTRB(QueryWidth/25, 0, 0, 0))
                    ],
                    title: TextField(
                      onChanged: (value) { OnSearching();setState(() {}); },
                      controller: _search_user_controller,
                      maxLength: 25,
                      autocorrect: false,
                      style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color, fontSize: 14),
                      decoration: InputDecoration(
                        counterText: '',
                        labelText: 'Search',
                      ),
                    ),
      ):
      
      
      ChooseViever == 2 || ChooseViever ==0?AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ):
      
      
      
      AppBar( 
        leading: InkWell(
          onTap: () {
            ChooseViever = 1;
            setState(() {});
            _MainScreenBloc.add(EventPusher());
            
          },
          child: Icon(Icons.arrow_back, color: ThemeInst.textTheme.bodyMedium!.color!.withOpacity(0.4)),),
          title: Container(
            width: 50+ Chatname.length*18,
            child: Row(children:[
                          ClipRRect(
                              borderRadius: BorderRadius.circular(30), 
                              child:Image.network(ChatImg,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                            Text(Chatname),
              ]
            ),
          ),
          centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
        body: BlocBuilder<ScreenMessBloc, ScreenMessState> (
        bloc: _MainScreenBloc,
        builder: (context, state){
          if(state is ChatsState){
            return _search_user_controller.text.trim().length!=0?StreamBuilder(
              stream: UserStream,
              builder: (context, snapshot){
                return snapshot.hasData? ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context, index) {return Divider(color: ThemeInst.dividerColor,indent: 20,endIndent: 20,);},
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    DocumentSnapshot DsU = snapshot.data.docs[index];
                    String? ChatNameNullable,ChatImgNullable,LastMessageNullable;
                        try{
                          ChatNameNullable = DsU['name'];
                          ChatImgNullable = DsU['avatareURI'];
                        }catch(e){
                          debugPrint('nothing');
                        }
                    return InkWell(
                      onTap: () {
                        Chatname = DsU['name'];
                        ChatImg = DsU['avatareURI'];
                        uidUser = DsU['uid'];
                        group = DsU['group'];
                        ChooseViever = 3;
                        InChat();
                        setState(() {});
                        _MainScreenBloc.add(EventPusher());
                        debugPrint("You Taped on dialog with your friend");
                      },
                      child:Container(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                            ChatImgNullable!=null?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30), 
                              child:Image.network(ChatImgNullable,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,),
                            ):Container(child:null),
                            Padding(padding: EdgeInsets.fromLTRB(QueryWidth/20, 0, 0, 0)),
                            Column(children: [
                            ChatNameNullable!=null?  
                            Text(ChatNameNullable):Container(child:null),
                            LastMessageNullable!=null?Text(LastMessageNullable):Text('')
                            ]),
                          ]
                        )
                      )
                    );
                  },
                ) : Center(child: CircleAvatar(),);
              }
            ):
            
            
            
            StreamBuilder(
              stream: UserStream,
              builder: (context, snapshot){
                return snapshot.hasData? ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  separatorBuilder: (context, index) {
                    return Divider(color: ThemeInst.dividerColor,indent: 20,endIndent: 20,);},
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    DocumentSnapshot DsU = snapshot.data.docs[index];
                    String? ChatNameNullable,ChatImgNullable,LastMessageNullable,ActivityBy;
                        try{
                          ChatNameNullable = DsU[FirebaseAuth.instance.currentUser!.uid.toString()+'opp'];
                          ChatImgNullable = DsU['img'+FirebaseAuth.instance.currentUser!.uid.toString()];
                          LastMessageNullable = DsU['last'];
                          ActivityBy = DsU['ActivityBy'];
                        }catch(e){
                          debugPrint('nothing');
                        }
                    return InkWell(
                      onTap: () {
                        Chatname = DsU[FirebaseAuth.instance.currentUser!.uid.toString()+'opp'];
                        ChatImg = DsU['img'+FirebaseAuth.instance.currentUser!.uid.toString()];
                        uidUser = DsU[FirebaseAuth.instance.currentUser!.uid.toString()+'uid'];
                        group = DsU['group'];
                        if(group == true){
                          ChatUid = DsU['ChatUID'];
                        }
                        ChooseViever = 3;
                        InChat();
                        setState(() {});
                        _MainScreenBloc.add(EventPusher());
                        debugPrint("You Taped on dialog with your friend");
                      },
                      child:Container(
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                            ChatImgNullable!=null?
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30), 
                              child:Image.network(ChatImgNullable,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,),
                            ):Container(child:null),
                            Padding(padding: EdgeInsets.fromLTRB(QueryWidth/20, 0, 0, 0)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            ChatNameNullable!=null?  
                            Text(ChatNameNullable):Container(child:null),
                            LastMessageNullable!=null?Text(
                              ActivityBy == FirebaseAuth.instance.currentUser!.uid.toString()?
                              ('You' +LastMessageNullable).length>30?
                              ('You: '+LastMessageNullable).substring(0,30)+'...':'You: '+LastMessageNullable
                              :(ChatNameNullable.toString()+LastMessageNullable).length>30?(ChatNameNullable!+': ' + LastMessageNullable).substring(0,30)+'...'
                              :ChatNameNullable.toString()+': ' +LastMessageNullable
                              ):Text('')
                            ]),
                          ]
                        )
                      )
                    );
                  },
                ) : Center(child: CircleAvatar(),);
              } //TODO:FINAL IT
            );//EmptyBuilder
          }




          if(state is ProfileState){
            return Column( 
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                color: ThemeInst.scaffoldBackgroundColor.withAlpha(255),
                child:Row(children: [
                  Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                  InkWell(
                    onTap: (){
                      setImageOnAvatre().whenComplete(() => _setImageinFirebase()).whenComplete(() => setState(() {}));
                    },
                  child:Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    height: QueryHight/5,
                    width: QueryHight/5,
                    child:ClipRRect(
                    borderRadius: BorderRadius.circular(30),  
                    child : Image.network(selectedFileName,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,),
                      )
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  Container(
                  child: Column(
                    children: [
                      Padding(padding:EdgeInsets.fromLTRB(0, 0, 0, 10),),
                      Container(
                      width: QueryWidth/2,
                      child: TextField(
                        maxLength: 25,
                        autocorrect: false,
                          style: TextStyle(color: ThemeInst.textTheme.bodyMedium?.color),
                          decoration: InputDecoration(
                            counterText: '',
                            labelText: 'Nick',
                            labelStyle: TextStyle(color: Theme.of(context).primaryTextTheme.bodySmall!.color!.withOpacity(0.5)),
                        ),
                          controller: _NameController,onChanged: (value) => _NameController.text,
                        ),
                      ),
                      OutlinedButton(onPressed: () {_NameSetter();_getAllFromFirebase();}, child: Text('Confirm name'))
                    ],
                    )
                  )
                ],
                )
              ),
              Row(children: [
                  Switch(value: ThemeChecker(),
               onChanged:(log) {Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
               
              Provider.of<ThemeProvider>(context,listen: false).setTheme();
              } ),
                  Padding(padding: EdgeInsets.fromLTRB(QueryWidth/4, 0, 0, 0)),
                  Text('Switch between dark and light theme'),
                ]
              ),
              MaterialButton(onPressed: (){
                  FirebaseAuth.instance.signOut();
                },
                child: Text('Log out'),
                color: Colors.red,
              ),
            ]
            );
          }




          if(state is SettingsState){
            return Text('Some Settings');
          }




          if(state is ConectionLostState){
           return Text('Conection Lost');
          }




          if(state is ChatState){
            return StreamBuilder(
              stream: chatStream,
              builder: (context, snapshot){
                String? _Sender;
                String? _Mess;
                return snapshot.hasData? ListView.separated(
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    DocumentSnapshot MessageInstance = snapshot.data.docs[index];
                    try{
                      _Sender =  MessageInstance['From'];
                      _Mess =  MessageInstance['Message'];
                    }catch(e){
                      debugPrint('qweqweq');
                    }
                    return Column( 
                      crossAxisAlignment: _Sender==FirebaseAuth.instance.currentUser!.uid?CrossAxisAlignment.end:CrossAxisAlignment.start ,
                    children: [
                      _Mess!=null?
                      Container(
                        decoration: BoxDecoration(
                          border: Border.fromBorderSide(BorderSide()),
                          borderRadius:  _Sender==FirebaseAuth.instance.currentUser!.uid?
                          BorderRadius.only(topLeft: Radius.circular(20),
                           topRight: Radius.circular(20),
                           bottomLeft: Radius.circular(20),
                           bottomRight: Radius.circular(5)
                           ):BorderRadius.only(topLeft: Radius.circular(20),
                           topRight: Radius.circular(20),
                           bottomLeft: Radius.circular(5),
                           bottomRight: Radius.circular(20)
                           ),
                          color: _Sender == FirebaseAuth.instance.currentUser!.uid?ThemeInst.indicatorColor:ThemeInst.secondaryHeaderColor
                        ),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(9, 5, 9, 5),
                          width: QueryWidth/1.25,
                          child:Text( _Mess! )),
                        ):Container(child:null)
                      ]
                    );
                },
                separatorBuilder: (context, index) {
                    return
                    _Sender==FirebaseAuth.instance.currentUser!.uid? Padding(padding: EdgeInsets.fromLTRB(30, 15, 0, 0)):Padding(padding: EdgeInsets.fromLTRB(0, 15, 10, 0));},
              ): Center(child: CircleAvatar(),);
              }
            ); 
          }




          else{
            return Text('You found an uncatched err pls write about it on mail Sorrybuthurt@gmail.com');
            }
        }
      )
    );
  }
}
