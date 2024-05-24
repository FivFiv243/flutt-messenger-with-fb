part of 'messege_menu_bloc.dart';

abstract class ScreenMessState extends Equatable{}

class ScreenMessInitial extends ScreenMessState{
  @override
  
  List<Object?> get props => [];
}

class ChatState extends ScreenMessState{
  ChatState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  //TODO: Implement functions
  List<Object?> get props =>[responseFire];
}

class ChatsState extends ScreenMessState{
  ChatsState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  //TODO: Implement functions
  List<Object?> get props =>[responseFire];
}

class SettingsState extends ScreenMessState{
  SettingsState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  //TODO: Implement functions
  List<Object?> get props =>[responseFire];
}


class ProfileState extends ScreenMessState{
  ProfileState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  //TODO: Implement functions
  List<Object?> get props =>[responseFire];
}

class ConectionLostState extends ScreenMessState{

  @override
  //TODO: Implement functions
  List<Object?> get props =>[];
}