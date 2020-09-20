import 'package:bloc/bloc.dart';
import 'package:builders/builders.dart';
import 'package:builders/src/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders_test.dart';

class MyCubit extends Cubit<int> {
  MyCubit() : super(0);

  void increment() => emit(state + 1);
}

class MyBloc2 extends Cubit<int> {
  MyBloc2() : super(0);

  void increment() => emit(state + 1);
}

main() {
  MyCubit cubit;
  SystemInjector si;

  setUp(() {
    cubit = MyCubit();
    si = SystemInjector();
    si.register(cubit);
    Builders.systemInjector(si.get);
  });

  tearDown(() {
    si.dispose();
    Builders.systemInjector(null);
  });

  testWidgets('should increment number and change text to 1 and 2',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocConsumer<MyCubit, int>(
          stream: cubit,
          builder: (context, state) {
            return Text("$state");
          },
        ),
      ),
    );
    cubit.increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    cubit.increment();
    await tester.pump(Duration(milliseconds: 800));
    expect(find.text('2'), findsOneWidget);
  });
  testWidgets(
      'should increment number and change text to 1 with Injection System Injector',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocConsumer<MyCubit, int>(
          builder: (context, state) {
            return Text("$state");
          },
        ),
      ),
    );
    cubit.increment();
    await tester.pump();
    final number1 = find.text('1');
    expect(number1, findsOneWidget);
  });
  testWidgets('should throw error if value gonna be null', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocConsumer<MyBloc2, int>(
            builder: (context, value) {
              return Text("$value");
            },
          ),
        ),
      );
    });

    expect(tester.takeException(), isInstanceOf<BlocError>());
  });
}
