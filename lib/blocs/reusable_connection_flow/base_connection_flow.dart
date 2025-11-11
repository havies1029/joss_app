import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/reusable_connection_flow/reusable_connection_flow_state.dart';

abstract class BaseConnectionFlow<TState extends ReusableConnectionFlowState>
    extends Cubit<TState> {
  BaseConnectionFlow(TState initialState) : super(initialState);

  void moveTo(String stage, {String? id, List<String>? data}) {
    emit(state.copyWith(
      activeStage: stage,
      activeId: id ?? state.activeId,
      sharedData: data ?? state.sharedData,
      isTransitioning: true,
    ) as TState);

    Future.delayed(const Duration(milliseconds: 250), () {
      emit(state.copyWith(isTransitioning: false) as TState);
    });
  }

  void setError(String message) {
    emit(state.copyWith(hasError: true, errorMessage: message) as TState);
  }

  void reset() {
    emit(createInitialState());
  }

  // setiap subclass wajib kasih initialState default
  TState createInitialState();
}
