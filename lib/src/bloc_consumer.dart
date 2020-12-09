import 'dart:async';

import 'package:flutter/widgets.dart';

import '../builders.dart';
import 'package:bloc/bloc.dart';

import 'bloc_builder.dart';
import 'bloc_listener.dart';
import 'errors.dart';

/// {@template bloc_consumer}
/// [BlocConsumer] exposes a [builder] and [listener] in order react to new
/// states.
/// [BlocConsumer] is analogous to a nested `BlocListener`
/// and `BlocBuilder` but reduces the amount of boilerplate needed.
/// [BlocConsumer] should only be used when it is necessary to both rebuild UI
/// and execute other reactions to state changes in the [cubit].
///
/// [BlocConsumer] takes a required `BlocWidgetBuilder`
/// and `BlocWidgetListener` and an optional [stream/cubit],
/// `BlocBuilderCondition`, and `BlocListenerCondition`.
///
/// If the [stream] parameter is omitted, [BlocConsumer] will automatically
/// perform a lookup using `Builders.systemInjector` defined on `MainApp`.
///
/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
///
/// An optional [listenWhen] and [buildWhen] can be implemented for more
/// granular control over when [listener] and [builder] are called.
/// The [listenWhen] and [buildWhen] will be invoked on each [cubit] `state`
/// change.
/// They each take the previous `state` and current `state` and must return
/// a [bool] which determines whether or not the [builder] and/or [listener]
/// function will be invoked.
/// The previous `state` will be initialized to the `state` of the [cubit] when
/// the [BlocConsumer] is initialized.
/// [listenWhen] and [buildWhen] are optional and if they aren't implemented,
/// they will default to `true`.
///
/// ```dart
/// BlocConsumer<BlocA, BlocAState>(
///   listenWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to invoke listener with state
///   },
///   listener: (context, state) {
///     // do stuff here based on BlocA's state
///   },
///   buildWhen: (previous, current) {
///     // return true/false to determine whether or not
///     // to rebuild the widget with state
///   },
///   builder: (context, state) {
///     // return widget here based on BlocA's state
///   }
/// )
/// ```
/// {@endtemplate}
///
class BlocConsumer<S extends Cubit<V>, V> extends StatefulWidget {
  final Widget Function(BuildContext context, V? state) builder;
  final S? stream;

  /// Takes the `BuildContext` along with the [cubit] `state`
  /// and is responsible for executing in response to `state` changes.
  final BlocWidgetListener<V>? listener;

  /// Takes the previous `state` and the current `state` and is responsible for
  /// returning a [bool] which determines whether or not to trigger
  /// [builder] with the current `state`.
  final BlocBuilderCondition<V>? buildWhen;

  /// Takes the previous `state` and the current `state` and is responsible for
  /// returning a [bool] which determines whether or not to call [listener] of
  /// [BlocConsumer] with the current `state`.
  final BlocListenerCondition<V>? listenWhen;

  const BlocConsumer({
    Key? key,
    required this.builder,
    this.listener,
    this.stream,
    this.buildWhen,
    this.listenWhen,
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
    return BlocBuilder<S, V>(
      cubit: _stream,
      builder: widget.builder,
      buildWhen: (previous, current) {
        if (widget.listenWhen?.call(previous, current) ?? true) {
          widget.listener?.call(context, current);
        }
        return widget.buildWhen?.call(previous, current) ?? true;
      },
    );
  }
}
