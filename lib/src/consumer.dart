import 'package:flutter/widgets.dart';

import '../builders.dart';
import 'errors.dart';

class Consumer<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T? value) builder;
  final T? value;

  const Consumer({Key? key, required this.builder, this.value})
      : super(key: key);

  @override
  _ConsumerState<T> createState() => _ConsumerState<T>();
}

class _ConsumerState<T extends ChangeNotifier> extends State<Consumer<T>> {
  T? _value;

  void _listener() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? Builders.si?.call<T>();
    if (_value == null) {
      throw ConsumerError(
        'Value (${T.toString()}) not found or Not found in System Injector. Please register your object in System Injector',
      );
    }
    _value?.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    _value?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _value);
  }
}
