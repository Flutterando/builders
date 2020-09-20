library builders;

export 'src/consumer.dart';
export 'src/selector.dart';

typedef ProviderReturn<T> = T Function<T>();

class Builders {
  static ProviderReturn si;

  static void systemInjector(ProviderReturn _si) {
    si = _si;
  }
}
