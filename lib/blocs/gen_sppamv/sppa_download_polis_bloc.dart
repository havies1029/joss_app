
import 'package:joss_app/repositories/gen_sppamv/download_polis_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'sppa_download_polis_state.dart';
part 'sppa_download_polis_event.dart';

class SppaDownloadPolisBloc extends Bloc<SppaDownloadPolisEvent, SppaDownloadPolisState> {
  final DownloadPolisRepository repository;

  SppaDownloadPolisBloc({required this.repository}) : super(DownloadInitial()) {
    on<DownloadFileEvent>((event, emit) async {
      emit(DownloadLoading());
      try {
        final filePath = await repository.downloadPolis(event.ePolisId);
        emit(DownloadSuccess(filePath, event.cob));
      } catch (e) {
        emit(DownloadFailure(e.toString()));
      }
    });
  }
}
