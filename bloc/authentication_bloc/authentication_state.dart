part of 'authentication__bloc.dart';

abstract class AuthenticationState extends Equatable{}

class AuthenticationInitial extends AuthenticationState{
  @override
  
  List<Object?> get props => [];
}

class RegistartionState extends AuthenticationState {
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}

class AuthoLogPassednState extends AuthenticationState {
  AuthoLogPassednState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  // TODO: implement props
  List<Object?> get props => [responseFire];
}

class AuthoLogState extends AuthenticationState{
  AuthoLogState({required this.responseFire});
  final FireAuthRespose responseFire;
  @override
  List<Object?> get props => [responseFire];
}
class ForgotPasswordState extends AuthenticationState{

  @override
  List<Object?> get props => [];
}

class LoginFailedState extends AuthenticationState{

  @override
  List<Object?> get props => [];
}

class RegistrationFaildState extends AuthenticationState{
  RegistrationFaildState({
    this.exception,
  });
  final Object? exception;
   @override
  List<Object?> get props => [exception];
}

class ConectionLostState extends AuthenticationState{

  @override
  List<Object?> get props => [];
}