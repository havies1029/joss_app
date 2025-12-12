import 'package:joss_app/repositories/gen_regmv/regmv_download_stnk_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'regmv_download_foto_stnk_event.dart';
import 'regmv_download_foto_stnk_state.dart';

class RegmvDownloadFotoStnkBloc extends Bloc<RegmvDownloadFotoStnkEvent, RegmvDownloadFotoStnkState> {
  final RegmvDownloadStnkRepository repository;

  RegmvDownloadFotoStnkBloc({required this.repository}) : super(DownloadInitial()) {
    on<DownloadFileEvent>((event, emit) async {
      emit(DownloadLoading());
      try {
        final filePath = await repository.downloadStnk(event.regmv4Id);
        emit(DownloadSuccess(filePath));
      } catch (e) {
        emit(DownloadFailure(e.toString()));
      }
    });
  }
}
