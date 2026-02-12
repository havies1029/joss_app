import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:joss_app/models/regklaim/attachment_item.dart';
import 'package:joss_app/repositories/regklaim/picker_repository.dart';
import 'package:joss_app/repositories/regklaim/upload_repository.dart';

part 'attach_event.dart';
part 'attach_state.dart';

class AttachBloc extends Bloc<AttachEvent, AttachState> {
  final PickerRepository pickerRepo;
  final UploadRepository uploadRepo;

  final Map<String, CancelToken> _cancelTokens = {};

  AttachBloc({required this.pickerRepo, required this.uploadRepo})
      : super(const AttachState()) {
    on<PickImageFromCamera>(_onPickCamera);
    on<PickFilesFromStorage>(_onPickFiles);
    on<RemoveAttachment>(_onRemove);

    on<UploadOne>(_onUploadOne);
    on<RetryUpload>(_onRetry);
    on<CancelUpload>(_onCancel);
    on<_ProgressChanged>(_onProgressChanged);
  }

  Future<void> _onPickCamera(
      PickImageFromCamera event,
      Emitter<AttachState> emit,
      ) async {
    debugPrint("=== EVENT: PickImageFromCamera triggered ===");

    final item = await pickerRepo.pickFromCamera();

    if (item == null) {
      debugPrint("PickImageFromCamera: item null (user cancel?)");
      return;
    }

    debugPrint("PickImageFromCamera: item picked -> ${item.name}");

    emit(state.copyWith(items: [...state.items, item]));

    debugPrint("PickImageFromCamera: total items now ${state.items.length + 1}");
  }


  Future<void> _onPickFiles(
      PickFilesFromStorage event,
      Emitter<AttachState> emit,
      ) async {
    debugPrint("=== EVENT: PickFilesFromStorage triggered ===");

    final picked = await pickerRepo.pickFiles();

    if (picked.isEmpty) {
      debugPrint("PickFilesFromStorage: no files selected");
      return;
    }

    debugPrint("PickFilesFromStorage: ${picked.length} file(s) selected");

    for (final file in picked) {
      debugPrint(" -> ${file.name}");
    }

    emit(state.copyWith(items: [...state.items, ...picked]));

    debugPrint("PickFilesFromStorage: total items now ${state.items.length + picked.length}");
  }

  void _onRemove(
      RemoveAttachment event,
      Emitter<AttachState> emit,
      ) {
    debugPrint("=== EVENT: RemoveAttachment triggered ===");
    debugPrint("Removing localId: ${event.localId}");

    _cancelTokens.remove(event.localId)?.cancel("Removed by user");

    final newItems =
    state.items.where((e) => e.localId != event.localId).toList();

    emit(state.copyWith(items: newItems));

    debugPrint("RemoveAttachment: total items now ${newItems.length}");
  }


  Future<void> _onUploadOne(
      UploadOne event,
      Emitter<AttachState> emit,
      ) async {
    debugPrint("=== EVENT: UploadOne triggered ===");
    debugPrint("localId: ${event.localId}");
    debugPrint("regklaim1Id: ${event.regklaim1Id}");

    final idx =
    state.items.indexWhere((e) => e.localId == event.localId);

    if (idx < 0) {
      debugPrint("UploadOne: item not found in state");
      return;
    }

    final current = state.items[idx];

    debugPrint("UploadOne: found item -> ${current.name}");
    debugPrint("Current status: ${current.status}");

    if (current.status == UploadStatus.uploading) {
      debugPrint("UploadOne: already uploading, skip");
      return;
    }

    debugPrint("UploadOne: set status to uploading");

    _updateItem(
      emit,
      event.localId,
          (x) => x.copyWith(
        status: UploadStatus.uploading,
        progress: 0.0,
        errorMessage: null,
      ),
    );

    final cancelToken = CancelToken();
    _cancelTokens[event.localId] = cancelToken;

    try {
      debugPrint("UploadOne: calling uploadRepo.uploadAttachment()");

      final res = await uploadRepo.uploadAttachment(
        regklaim1Id: event.regklaim1Id,
        item: current,
        cancelToken: cancelToken,
        onProgress: (p) {
          debugPrint("Upload progress: ${(p * 100).toStringAsFixed(0)}%");
          add(_ProgressChanged(event.localId, p));
        },
      );

      debugPrint("UploadOne: upload SUCCESS");
      debugPrint("serverId: ${res.serverId}");
      debugPrint("serverUrl: ${res.serverUrl}");

      _cancelTokens.remove(event.localId);

      _updateItem(
        emit,
        event.localId,
            (x) => x.copyWith(
          status: UploadStatus.success,
          progress: 1.0,
          serverId: res.serverId,
          serverUrl: res.serverUrl,
        ),
      );
    } catch (e, stack) {
      debugPrint("UploadOne: upload FAILED");
      debugPrint("Error: $e");
      debugPrint("Stack: $stack");

      _cancelTokens.remove(event.localId);

      _updateItem(
        emit,
        event.localId,
            (x) => x.copyWith(
          status: UploadStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }

    debugPrint("=== UploadOne finished ===");
  }

  void _onRetry(RetryUpload event, Emitter<AttachState> emit) {
    add(UploadOne(localId: event.localId, regklaim1Id: event.regklaim1Id));
  }

  void _onCancel(CancelUpload event, Emitter<AttachState> emit) {
    _cancelTokens.remove(event.localId)?.cancel("Canceled by user");
    _updateItem(
      emit,
      event.localId,
      (x) => x.copyWith(status: UploadStatus.canceled, errorMessage: "Canceled"),
    );
  }

  void _onProgressChanged(_ProgressChanged event, Emitter<AttachState> emit) {
    _updateItem(
      emit,
      event.localId,
      (x) => x.copyWith(status: UploadStatus.uploading, progress: event.progress),
    );
  }

  void _updateItem(
    Emitter<AttachState> emit,
    String localId,
    AttachmentItem Function(AttachmentItem) map,
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
}
