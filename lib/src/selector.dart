import 'package:flutter/widgets.dart';

import '../builders.dart';
import 'errors.dart';

class Selector<T extends ChangeNotifier, D> extends StatefulWidget {
  final Widget Function(BuildContext context, D value) builder;
  final D Function(T value) selector;
  final T value;

  const Selector(
      {Key key, this.value, @required this.builder, @required this.selector})
      : super(key: key);

  @override
  _SelectorState<T, D> createState() => _SelectorState<T, D>();
}

class _SelectorState<T extends ChangeNotifier, D>
    extends State<Selector<T, D>> {
  T _value;
  D _selector;
  void _listener() {
    var newSelector = widget.selector(_value);
    if (newSelector != _selector) {
      setState(() {
        _selector = newSelector;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _value = widget.value ?? Builders?.si?.call<T>();
    if (_value == null) {
      throw SelectorError(
        'Value (${T.toString()}) not found or Not found in System Injector. Please register your object in System Injector',
      );
    }
    _selector = widget.selector(_value);
    _value.addListener(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    _value.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selector);
  }
}
