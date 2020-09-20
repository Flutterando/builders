import 'package:builders/builders.dart';
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
  MyMockChangeNotifier counterValue;
  SystemInjector si;

  setUp(() {
    counterValue = MyMockChangeNotifier();
    si = SystemInjector();
    si.register(counterValue);
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
        home: Selector<MyMockChangeNotifier, int>(
          value: counterValue,
          selector: (value) => value.counter,
          builder: (context, selector) {
            return Text("$selector");
          },
        ),
      ),
    );
    counterValue.increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    counterValue.increment();
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
    counterValue.counter = 2;
    counterValue.notifyListeners();
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });
  testWidgets(
      'should increment number and change text to 1 with Injection System Injector',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Selector<MyMockChangeNotifier, int>(
          selector: (value) => value.counter,
          builder: (context, selector) {
            return Text("$selector");
          },
        ),
      ),
    );
    counterValue.increment();
    await tester.pump();
    final number1 = find.text('1');
    expect(number1, findsOneWidget);
  });
  testWidgets('should throw error if value gonna be null', (tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Selector<MyMockChangeNotifier2, int>(
            selector: (value) => value.counter,
            builder: (context, value) {
              return Text("$value");
            },
          ),
        ),
      );
    });

    expect(tester.takeException(), isInstanceOf<SelectorError>());
  });
}
