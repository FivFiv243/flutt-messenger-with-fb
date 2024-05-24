import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController GetRiveController(Artboard artboard, {StateMachineName = "state_machine_1"}){
    StateMachineController? controller = 
    StateMachineController.fromArtboard(artboard, StateMachineName);
    artboard.addController(controller!);
    return controller;
  }
}