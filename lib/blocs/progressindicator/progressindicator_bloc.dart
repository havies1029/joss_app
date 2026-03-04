import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'progressindicator_event.dart';
part 'progressindicator_state.dart';

class ProgressIndicatorBloc
    extends Bloc<ProgressIndicatorEvents, ProgressIndicatorState> {
  ProgressIndicatorBloc() : super(const ProgressIndicatorState()) {
    on<EndProcessEvent>(onEnded);
    on<UpdateProgressEvent>(onUpdateProgress);
  }

  Future<void> onEnded(
      EndProcessEvent event, Emitter<ProgressIndicatorState> emit) async {
    emit(state.copyWith(
        downloading: false, downloaded: true, progressName: event.progressName, progressPercent: 1.0));
  }

  Future<void> onUpdateProgress(
      UpdateProgressEvent event, Emitter<ProgressIndicatorState> emit) async {

    bool downloading = event.progress < 1;

    emit(state.copyWith(downloading: downloading, progressPercent: event.progress));
  }
}
