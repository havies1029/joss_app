import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportHelper {
  static Widget buildFlow<BlocT extends Bloc<EventT, StateT>, EventT, StateT, ModelT, IdT>({
    required BlocT bloc,
    required IdT id,
    required EventT Function(IdT id) fetchEvent,
    required void Function(BlocT bloc, EventT event) dispatch,
    required bool Function(StateT state) isReady,
    required ModelT? Function(StateT state) pickModel,
    required void Function(BuildContext context, StateT state, ModelT model) onReady,
    required Widget child,

    void Function(BuildContext context, StateT state)? onError,
  }) {
    return _ExportFlowHost<BlocT, EventT, StateT, ModelT, IdT>(
      bloc: bloc,
      id: id,
      fetchEvent: fetchEvent,
      dispatch: dispatch,
      isReady: isReady,
      pickModel: pickModel,
      onReady: onReady,
      onError: onError,
      child: child,
    );
  }
}

class _ExportFlowHost<BlocT extends Bloc<EventT, StateT>, EventT, StateT, ModelT, IdT>
    extends StatefulWidget {
  final BlocT bloc;
  final IdT id;

  final EventT Function(IdT id) fetchEvent;
  final void Function(BlocT bloc, EventT event) dispatch;

  final bool Function(StateT state) isReady;
  final ModelT? Function(StateT state) pickModel;

  final void Function(BuildContext context, StateT state, ModelT model) onReady;
  final void Function(BuildContext context, StateT state)? onError;

  final Widget child;

  const _ExportFlowHost({
    required this.bloc,
    required this.id,
    required this.fetchEvent,
    required this.dispatch,
    required this.isReady,
    required this.pickModel,
    required this.onReady,
    required this.child,
    this.onError,
  });

  @override
  State<_ExportFlowHost<BlocT, EventT, StateT, ModelT, IdT>> createState() => _ExportFlowHostState();
}

class _ExportFlowHostState<BlocT extends Bloc<EventT, StateT>, EventT, StateT, ModelT, IdT>
    extends State<_ExportFlowHost<BlocT, EventT, StateT, ModelT, IdT>> {
  @override
  void initState() {
    super.initState();

    final ev = widget.fetchEvent(widget.id);
    widget.dispatch(widget.bloc, ev);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlocT, StateT>(
      bloc: widget.bloc,
      listener: (context, state) {
        if (widget.isReady(state)) {
          final model = widget.pickModel(state);
          if (model != null) {
            widget.onReady(context, state, model);
          }
        } else {
          widget.onError?.call(context, state);
        }
      },
      child: widget.child,
    );
  }
}
