import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirea_messenger/abstractions/conection_check_repository.dart';
import 'package:mirea_messenger/features/Classes/response_class.dart';
class ConectionCheck implements AbstractConectionRepository{


  @override

    Future<FireAuthRespose> GetConnectionAnswer() async{
        try {
          final result = await InternetAddress.lookup('example.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            return FireAuthRespose(StatusCode: 100);
          }
        } on SocketException catch (_) {
          return FireAuthRespose(StatusCode: 0);
        }
      debugPrint("you got exception of App");
      return FireAuthRespose(StatusCode: 404);
      
  }
}