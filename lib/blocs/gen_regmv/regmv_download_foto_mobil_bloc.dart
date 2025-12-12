import 'package:joss_app/repositories/gen_regmv/regmv_download_fotomobil_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'regmv_download_foto_mobil_event.dart';
import 'regmv_download_foto_mobil_state.dart';

class RegmvDownloadFotoMobilBloc extends Bloc<RegmvDownloadFotoMobilEvent, RegmvDownloadFotoMobilState> {
  final RegmvDownloadFotoMobilRepository repository;

  RegmvDownloadFotoMobilBloc({required this.repository}) : super(DownloadInitial()) {
    on<DownloadFileEvent>((event, emit) async {
      emit(DownloadLoading());
      try {
        final filePath = await repository.downloadFotoMobil(event.regmv5Id);
        emit(DownloadSuccess(filePath));
      } catch (e) {
        emit(DownloadFailure(e.toString()));
      }
    });
  }
}
