abstract class Errors implements Exception {
  final String message;

  const Errors(this.message);

  @override
  String toString() {
    return '${runtimeType.toString()}: $message';
  }
}

class ConsumerError extends Errors {
  const ConsumerError(String message) : super(message);
}

class SelectorError extends Errors {
  const SelectorError(String message) : super(message);
}

class BlocError extends Errors {
  const BlocError(String message) : super(message);
}
