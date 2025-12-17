import 'package:joss_app/repositories/gen_regmv/regmv_download_fotoacc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'regmv_download_foto_acc_event.dart';
import 'regmv_download_foto_acc_state.dart';

class RegmvDownloadFotoAccBloc extends Bloc<RegmvDownloadFotoAccEvent, RegmvDownloadFotoAccState> {
  final RegmvDownloadFotoAccRepository repository;

  RegmvDownloadFotoAccBloc({required this.repository}) : super(DownloadInitial()) {
    on<DownloadFileEvent>((event, emit) async {
      emit(DownloadLoading());
      try {
        final filePath = await repository.downloadFotoAcc(event.regmv7Id);
        emit(DownloadSuccess(filePath));
      } catch (e) {
        emit(DownloadFailure(e.toString()));
      }
    });
  }
}
