import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mirea_messenger/abstractions/conection_check_repository.dart';
import 'package:mirea_messenger/features/Classes/response_class.dart';

//parts
part 'messege_menu_event.dart';
part 'messege_menu_state.dart';

//bloc (for main screen of app)

class ScreenMessBloc extends Bloc<ScreenMessEvent, ScreenMessState> {
  ScreenMessBloc(this.responseFire) : super(ScreenMessInitial()) {
    on<ChatActivityEvent>((event, emit) async{
      try{
        final ResponseCheck = await responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());
        emit(ChatsState(responseFire:ResponseCheck));
         if(ResponseCheck.StatusCode == 0){
          emit(ConectionLostState());
      }
    }catch(e){
      debugPrint(e.toString());
    }
    });
  on<ProfileActivityEvent>((event, emit) async{
    try{
        final ResponseCheck = await responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());  
        emit(ProfileState(responseFire:ResponseCheck));
         if(ResponseCheck.StatusCode == 0){
          emit(ConectionLostState());
      }
    }catch(e){
      debugPrint(e.toString());
    }
    });
    on<SettingsActivityEvent>((event, emit) async{
      try{
        final ResponseCheck = await responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());
        emit(SettingsState(responseFire:ResponseCheck));
         if(ResponseCheck.StatusCode == 0){
          emit(ConectionLostState());
      }
    }catch(e){
      debugPrint(e.toString());
    }
    });
    on<ChatConnectEvent>((event, emit) async{
      try{
        final ResponseCheck = await responseFire.GetConnectionAnswer();
        debugPrint(ResponseCheck.toString());
        emit(ChatState(responseFire:ResponseCheck));
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


