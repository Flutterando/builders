import 'package:builders/builders.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('test inject system', () {
    final si = SystemInjector();
    si.register('Test');
    si.register(1.0);

    expect(si.get<String>(), 'Test');
    expect(si.get<double>(), 1.0);
  });

  test('should configure injection delegate', () {
    final si = SystemInjector();
    si.register('Test');
    si.register(1.0);
    Builders.systemInjector(si.get);
    expect(Builders.si<String>(), 'Test');
    expect(Builders.si<double>(), 1.0);
  });
}

class SystemInjector {
  Map<Type, dynamic> _injection = {};

  void register(value) {
    _injection[value.runtimeType] = value;
  }

  void dispose() {
    _injection.clear();
  }

  T get<T>() {
    return _injection[T];
  }
}
