import 'dart:async';

import 'package:flutter/widgets.dart';

import '../builders.dart';
import 'package:bloc/bloc.dart';

import 'errors.dart';

class BlocConsumer<S extends Cubit<V>, V> extends StatefulWidget {
  final Widget Function(BuildContext context, V? state) builder;
  final S? stream;

  const BlocConsumer({
    Key? key,
    required this.builder,
    this.stream,
  }) : super(key: key);

  @override
  _BlocConsumerState<S, V> createState() => _BlocConsumerState<S, V>();
}

class _BlocConsumerState<S extends Cubit<V>, V>
    extends State<BlocConsumer<S, V>> {
  S? _stream;
  V? _state;

  late StreamSubscription<V> _subscription;

  void _listener(V newState) {
    if (newState != _state) {
      setState(() {
        _state = newState;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _stream = widget.stream ?? Builders.si?.call<S>();
    if (_stream == null) {
      throw BlocError(
        'Value (${V.toString()}) not found or Not found in System Injector. Please register your object in System Injector',
      );
    }
    _state = _stream!.state;
    _subscription = _stream!.listen(_listener);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state);
  }
}
