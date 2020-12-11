import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../builders.dart';
import 'bloc_listener.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [state] and is responsible for returning a widget which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef BlocWidgetBuilder<S> = Widget Function(BuildContext context, S state);

/// Signature for the `buildWhen` function which takes the previous `state` and
/// the current `state` and is responsible for returning a [bool] which
/// determines whether to rebuild [BlocBuilder] with the current `state`.
typedef BlocBuilderCondition<S> = bool Function(S previous, S current);

/// {@endtemplate}
class BlocBuilder<C extends Cubit<S>, S> extends BlocBuilderBase<C, S> {
  /// {@macro bloc_builder}
  const BlocBuilder({
    Key? key,
    required this.builder,
    C? cubit,
    BlocBuilderCondition<S>? buildWhen,
  }) : super(key: key, cubit: cubit, buildWhen: buildWhen);

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `state` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final BlocWidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context, S? state) => builder(context, state!);
}

/// {@template bloc_builder_base}
/// Base class for widgets that build themselves based on interaction with
/// a specified [cubit].
///
/// A [BlocBuilderBase] is stateful and maintains the state of the interaction
/// so far. The type of the state and how it is updated with each interaction
/// is defined by sub-classes.
/// {@endtemplate}
abstract class BlocBuilderBase<C extends Cubit<S>, S> extends StatefulWidget {
  /// {@macro bloc_builder_base}
  const BlocBuilderBase({Key? key, this.cubit, this.buildWhen})
      : super(key: key);

  /// The [cubit] that the [BlocBuilderBase] will interact with.
  /// If omitted, [BlocBuilderBase] will automatically perform a lookup using
  /// [BlocProvider] and the current `BuildContext`.
  final C? cubit;

  /// {@macro bloc_builder_build_when}
  final BlocBuilderCondition<S>? buildWhen;

  /// Returns a widget based on the `BuildContext` and current [state].
  Widget build(BuildContext context, S? state);

  @override
  State<BlocBuilderBase<C, S>> createState() => _BlocBuilderBaseState<C, S>();
}

class _BlocBuilderBaseState<C extends Cubit<S>, S>
    extends State<BlocBuilderBase<C, S>> {
  C? _cubit;
  S? _state;

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit ?? Builders.si?.call<C>();
    _state = _cubit!.state;
  }

  @override
  void didUpdateWidget(BlocBuilderBase<C, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldCubit = oldWidget.cubit ?? Builders.si?.call<C>();
    final currentCubit = widget.cubit ?? oldCubit;
    if (oldCubit != currentCubit) {
      _cubit = currentCubit;
      _state = _cubit?.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<C, S>(
      cubit: _cubit,
      listenWhen: widget.buildWhen,
      listener: (context, state) => setState(() => _state = state),
      child: widget.build(context, _state),
    );
  }
}
