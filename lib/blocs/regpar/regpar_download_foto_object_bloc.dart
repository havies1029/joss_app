
import 'package:joss_app/blocs/regpar/regpar_download_foto_object_event.dart';
import 'package:joss_app/repositories/regpar/regpar_download_fotoobject_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'regpar_download_foto_object_state.dart';

class RegparDownloadFotoObjectBloc extends Bloc<RegparDownloadFotoObjectEvent, RegparDownloadFotoObjectState> {
  final RegparDownloadFotoObjectRepository repository;

  RegparDownloadFotoObjectBloc({required this.repository}) : super(DownloadInitial()) {
    on<DownloadFileEvent>((event, emit) async {
      emit(DownloadLoading());
      try {
        final filePath = await repository.downloadFotoObject(event.regpar6Id);
        emit(DownloadSuccess(filePath));
      } catch (e) {
        emit(DownloadFailure(e.toString()));
      }
    });
  }
}
