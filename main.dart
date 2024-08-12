import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mirea_messenger/features/Classes/authentication_cheker.dart';
import 'package:mirea_messenger/features/conection_check.dart';
import 'package:mirea_messenger/themes/theme_provider.dart';
import 'package:mirea_messenger/themes/themes.dart';
import 'package:provider/provider.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDCSAbFngGfYE6bUE4l7m4whBLBByF_YxY",
       appId: "1:383731607038:android:0e2cb24b7d3088fc3a8caf",
        messagingSenderId:"383731607038",
         projectId:  "mireamess",
         storageBucket: "mireamess.appspot.com")
  )
  :await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: "AIzaSyDCSAbFngGfYE6bUE4l7m4whBLBByF_YxY",
       appId: "1:383731607038:android:0e2cb24b7d3088fc3a8caf",
        messagingSenderId:"383731607038",
         projectId:  "mireamess")
  );
  GetIt.I.registerFactory(() => ConectionCheck());
  runApp(ChangeNotifierProvider(create: 
      (context)=>ThemeProvider(),

       child: const MyApp()
    )
  );
}

//TODO: зарегать гетит ,сделать тем провайдер
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ThemeProvider>(context,listen: false).initTheme();
  }
  ThemeData Changer(){
    if(Provider.of<ThemeProvider>(context).themeData == false){
      return LightThemeMod;
    }
    else{
      return DarkThemeModes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMess',
      theme: Changer(),
      home: CheckAuth(),
    );
  }
}
