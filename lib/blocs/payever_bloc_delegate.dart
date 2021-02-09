import 'package:flutter_bloc/flutter_bloc.dart';

class PayeverBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);

    assert(() {
      print(event);
      return true;
    }());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    assert((){
      print(transition);
      return true;
    }());
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    assert((){
      print(error);
      return true;
    }());
  }
}