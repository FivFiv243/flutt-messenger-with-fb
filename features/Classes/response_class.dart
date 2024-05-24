import 'package:equatable/equatable.dart';

class FireAuthRespose extends Equatable{
  const FireAuthRespose({
    required this.StatusCode,
  });

  final int StatusCode;

  @override
  List<Object?> get props => [StatusCode];
}