import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:joss_app/blocs/regpar/regpar6form_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/regpar/regpar6upload_model.dart';
import '../../repositories/regpar/regpar6picker_repository.dart';
import '../../repositories/regpar/regpar_upload_fotoobject_repository.dart';

part 'regpar_upload_foto_object_event.dart';
part 'regpar_upload_foto_object_state.dart';

class RegparUploadFotoObjectBloc
    extends Bloc<RegparUploadFotoObjectEvent, RegParUploadFotoObjectState> {
  final RegparUploadFotoObjectRepository repository;
  final Regpar6PickerRepository regpar6pickerRepository;
  final Regpar6FormBloc regpar6formBloc;
  final Map<String, CancelToken> _cancelTokens = {};

  RegparUploadFotoObjectBloc({
    required this.repository,
    required this.regpar6pickerRepository,
    required this.regpar6formBloc,
  }) : super(const RegParUploadFotoObjectState()) {
    on<RegparStoragePickImageFromCamera>(_onPickCamera);
    on<RegparStoragePickFilesFromStorage>(_onPickFiles);
    on<RegparStorageUploadMany>(_onUploadMany);
    on<RegparUploadFotoObjectUploadOne>(_onUploadOne);
    on<RegparStorageRemoveAttachment>(_onRemove);
    on<RegparUploadReset>((event, emit) {
      emit(state.copyWith(items: [])); // atau state.initial()
    });
  }

  static const int _maxItems = 10;

  bool get _isMaxReached => state.items.length >= _maxItems;

  static const String _lockedMsg =
      "Sedang menghitung premi, foto tidak bisa diubah dulu.";

  bool get _isActionLocked => state.isUploadingAll || state.isClearing;

  void _emitToast(Emitter<RegParUploadFotoObjectState> emit, String msg) {
    emit(state.copyWith(toast: msg));
    emit(state.copyWith(clearToast: true));
  }

  void _emitLockedToast(Emitter<RegParUploadFotoObjectState> emit) {
    _emitToast(emit, _lockedMsg);
  }

  void _emitMaxToast(Emitter<RegParUploadFotoObjectState> emit) {
    _emitToast(emit, "Maksimal $_maxItems file.");
  }

  void _emitOverPickedToast(Emitter<RegParUploadFotoObjectState> emit) {
    _emitToast(emit, "Maksimal foto $_maxItems. Sisanya tidak ditambahkan.");
  }

  Future<void> _onPickCamera(
      RegparStoragePickImageFromCamera event,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    if (_isActionLocked) {
      _emitLockedToast(emit);
      return;
    }

    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final item = await regpar6pickerRepository.pickFromCamera();
    if (item == null) return;

    emit(state.copyWith(items: [...state.items, item]));
  }

  Future<void> _onPickFiles(
      RegparStoragePickFilesFromStorage event,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    if (_isActionLocked) {
      _emitLockedToast(emit);
      return;
    }

    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final picked = await regpar6pickerRepository.pickFiles();
    if (picked.isEmpty) return;

    final remaining = _maxItems - state.items.length;
    final accepted = picked.take(remaining).toList();

    emit(state.copyWith(items: [...state.items, ...accepted]));

    if (picked.length > accepted.length) {
      _emitOverPickedToast(emit);
    }
  }

  Future<void> _onRemove(
      RegparStorageRemoveAttachment event,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    if (_isActionLocked) {
      _emitLockedToast(emit);
      return;
    }

    final localId = event.localId;

    final idx = state.items.indexWhere((e) => e.localId == localId);
    if (idx < 0) return;

    final current = state.items[idx];

    _cancelTokens.remove(localId)?.cancel("Removed by user");

    if ((current.serverId ?? '').isNotEmpty) {
      regpar6formBloc.add(
        Regpar6FormHapusEvent(recordId: current.serverId!),
      );
    }

    final newItems = state.items.where((e) => e.localId != localId).toList();
    emit(state.copyWith(items: newItems));
  }

  Future<void> _onUploadMany(
      RegparStorageUploadMany event,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    if (event.localIds.isEmpty) {
      emit(state.copyWith(toast: "Minimal pilih 1 file atau foto"));
      emit(state.copyWith(clearToast: true));
      return;
    }

    for (final localId in event.localIds) {
      await _uploadOneInternalAwait(localId, event.regpar1Id, emit);
      await Future.delayed(const Duration(milliseconds: 150)); // optional, bantu server
    }
  }

  Future<void> _uploadOneInternalAwait(
      String localId,
      String regpar1Id,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    final idx = state.items.indexWhere((e) => e.localId == localId);
    if (idx < 0) return;

    final current = state.items[idx];

    if ((current.serverId ?? '').isNotEmpty) return;
    if (current.status == UploadStatus.uploading) return;

    // model kamu String non-null, tapi tetap aman
    if (current.path.isEmpty || current.name.isEmpty) {
      _updateItem(emit, localId, (x) => x.copyWith(
        status: UploadStatus.failed,
        errorMessage: "File path / fileName kosong",
      ));
      return;
    }

    _updateItem(emit, localId, (x) => x.copyWith(
      status: UploadStatus.uploading,
      progress: 0.0,
      errorMessage: null,
    ));

    try {
      final returnData = await repository.uploadFotoObjectByPath(
        regpar1Id,
        "", // caption
        current.path,
        current.name,
      );

      if (returnData.success == true) {
        final serverId = returnData.data.toString();
        _updateItem(emit, localId, (x) => x.copyWith(
          status: UploadStatus.success,
          progress: 1,
          serverId: serverId,
        ));
      } else {
        _updateItem(emit, localId, (x) => x.copyWith(
          status: UploadStatus.failed,
          errorMessage: "Upload gagal",
        ));
      }
    } catch (e) {
      _updateItem(emit, localId, (x) => x.copyWith(
        status: UploadStatus.failed,
        errorMessage: e.toString(),
      ));
    }
  }
  //
  // void _onRetry(RegStorageRetryUpload event, Emitter<RegStorageState> emit) {
  //   add(RegStorageUploadOne(localId: event.localId, regklaim1Id: event.regklaim1Id));
  // }
  //
  // void _onCancel(RegStorageCancelUpload event, Emitter<RegStorageState> emit) {
  //   _cancelTokens.remove(event.localId)?.cancel("Canceled by user");
  //   _updateItem(
  //     emit,
  //     event.localId,
  //         (x) => x.copyWith(status: UploadStatus.canceled, errorMessage: "Canceled"),
  //   );
  // }
  //
  // void _onProgressChanged(
  //     _RegStorageProgressChanged event,
  //     Emitter<RegStorageState> emit,
  //     ) {
  //   _updateItem(
  //     emit,
  //     event.localId,
  //         (x) => x.copyWith(
  //       status: UploadStatus.uploading,
  //       progress: event.progress,
  //     ),
  //   );
  // }

  void _updateItem(
      Emitter<RegParUploadFotoObjectState> emit,
      String localId,
      Regpar6UploadModel Function(Regpar6UploadModel) map,
      ) {
    final updated =
    state.items.map((e) => e.localId == localId ? map(e) : e).toList();
    emit(state.copyWith(items: updated));
  }

  @override
  Future<void> close() {
    for (final t in _cancelTokens.values) {
      t.cancel("Bloc disposed");
    }
    _cancelTokens.clear();
    return super.close();
  }

  Future<void> _onUploadOne(
      RegparUploadFotoObjectUploadOne event,
      Emitter<RegParUploadFotoObjectState> emit,
      ) async {
    final localId = event.localId;

    // 1) set uploading
    _updateItem(emit, localId, (x) => x.copyWith(
      status: UploadStatus.uploading,
      progress: 0,
      errorMessage: null,
      // kalau mau reset id lama saat retry:
      // clearServerId: true,
    ));

    try {
      // ⬇️ ubah repository supaya return returnData (success + data)
      final returnData = await repository.uploadFotoObjectByPath(
        event.regpar1Id,
        event.caption,
        event.filePath,
        event.fileName,
      );

      final success = returnData.success == true;
      if (success) {
        final serverId = returnData.data.toString(); // ✅ tangkap serverId

        _updateItem(emit, localId, (x) => x.copyWith(
          status: UploadStatus.success,
          progress: 1,
          serverId: serverId,
          // serverUrl: returnData.url?.toString(), // kalau ada
        ));

        // emit(state.copyWith(toast: "Upload berhasil cihuy"));
        emit(state.copyWith(clearToast: true));
      } else {
        _updateItem(emit, localId, (x) => x.copyWith(
          status: UploadStatus.failed,
          errorMessage: "Upload gagal atau URL tidak ditemukan.",
        ));
      }
    } catch (e) {
      _updateItem(emit, localId, (x) => x.copyWith(
        status: UploadStatus.failed,
        errorMessage: e.toString(),
      ));
    }
  }
}
