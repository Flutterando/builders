import 'package:bloc/bloc.dart';

class CounterBloc extends Cubit<int> {
  CounterBloc() : super(0);

  increment() => emit(state + 1);
}
