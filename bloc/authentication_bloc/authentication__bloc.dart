
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirea_messenger/abstractions/conection_check_repository.dart';
import 'package:mirea_messenger/features/Classes/response_class.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';


class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(this.responseFire) : super(AuthenticationInitial()) {
    on<AuthoLogEvent>((event, emit) async{
      try{
        final ResponseCheck = await  responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());
        if(ResponseCheck.StatusCode == 100){
          emit(AuthoLogState(responseFire: ResponseCheck));
        }
        if(ResponseCheck.StatusCode == 0){
          emit(ConectionLostState());
        }
      }catch(e){
        debugPrint(e.toString());
        emit(RegistrationFaildState(exception: e));
        //what to do if action was ruined (catching error)
      }
    
    });
  on<ForgotPasswordEvent>((event, emit) async{
    try{
        final ResponseCheck = await  responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());
        emit(ForgotPasswordState());
         if(ResponseCheck.StatusCode == 0){
          emit(ConectionLostState());
        }
    }catch(e){
      debugPrint(e.toString());
    }
  });
  }

  
  final AbstractConectionRepository responseFire;
}