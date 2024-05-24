import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{

  var _themeData;
  bool get themeData => _themeData??false;

  set themeData(bool themeData){
    _themeData = themeData;
    notifyListeners();
  }
  var BoolTheme;
  Future setTheme() async{
    var preferences = await SharedPreferences.getInstance();
    debugPrint(_themeData.toString());
    preferences.setBool("Theme", _themeData);
}

Future<bool?> GetTheme()async{
 var preferences = await SharedPreferences.getInstance();
 debugPrint(preferences.getBool("Theme").toString());
 if(preferences.getBool("Theme")!=null){
  return preferences.getBool("Theme");
 }
 else{
  return false;
 }
 
}


Future initTheme()async{
  themeData = (await GetTheme())!;
  
}
  void toggleTheme(){
    if (_themeData == true){
      themeData = false;
    }
    else{
      themeData = true;
    }
  }
}