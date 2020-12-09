import 'package:builders/builders.dart';
import 'package:builders/src/consumer.dart';
import 'package:builders/src/errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../builders_test.dart';

class MyMockChangeNotifier extends ChangeNotifier {
  int counter = 0;

  increment() {
    counter++;
    notifyListeners();
  }
}

class MyMockChangeNotifier2 extends ChangeNotifier {
  int counter = 0;

  increment() {
    counter++;
    notifyListeners();
  }
}

main() {
  MyMockChangeNotifier? counterValue;
  SystemInjector? si;

  setUp(() {
    counterValue = MyMockChangeNotifier();
    si = SystemInjector();
    si?.register(counterValue);
    Builders.systemInjector(si?.get);
  });

  tearDown(() {
    si?.dispose();
    Builders.systemInjector(null);
  });

  testWidgets('should increment number and change text to 1 and 2',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Consumer<MyMockChangeNotifier>(
          value: counterValue,
          builder: (context, value) {
            return Text("${value?.counter}");
          },
        ),
      ),
    );
    counterValue?.increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    counterValue?.increment();
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
  testWidgets(
      'should increment number and change text to 1 with Injection System Injector',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Consumer<MyMockChangeNotifier>(
          builder: (context, value) {
            return Text("${value?.counter}");
          },
        ),
      ),
    );
    counterValue?.increment();
    await tester.pump();
    final number1 = find.text('1');
    expect(number1, findsOneWidget);
  });
  testWidgets('should throw error if value gonna be null', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Consumer<MyMockChangeNotifier2>(
            builder: (context, value) {
              return Text("$value");
            },
          ),
        ),
      );
    });

    expect(tester.takeException(), isInstanceOf<ConsumerError>());
  });
}
