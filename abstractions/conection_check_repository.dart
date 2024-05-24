import 'package:mirea_messenger/features/Classes/response_class.dart';

abstract class AbstractConectionRepository {
  Future<FireAuthRespose> GetConnectionAnswer();
}