// regmv_upload_foto_acc_bloc.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../models/gen_regmv/regmv7upload_model.dart';
import '../../repositories/gen_regmv/regmv7picker_repository.dart';
import '../../repositories/gen_regmv/regmv_upload_foto_acc_repository.dart';
import '../gen_regmv/regmv7form_bloc.dart';

part 'regmv_upload_foto_acc_event.dart';
part 'regmv_upload_foto_acc_state.dart';

class RegmvUploadFotoAccBloc
    extends Bloc<Regmv7UploadFotoObjectEvent, Regmv7UploadFotoObjectState> {
  final RegmvUploadFotoAccRepository repository;
  final Regmv7PickerRepository pickerRepository;
  final Regmv7FormBloc regmv7formBloc;

  final Map<String, CancelToken> _cancelTokens = {};
  final Uuid _uuid = const Uuid();

  RegmvUploadFotoAccBloc({
    required this.repository,
    required this.pickerRepository,
    required this.regmv7formBloc,
  }) : super(const Regmv7UploadFotoObjectState()) {
    on<Regmv7StoragePickImageFromCamera>(_onPickCamera);
    on<Regmv7StoragePickFilesFromStorage>(_onPickFiles);

    on<Regmv7UploadFotoObjectSelected>(_onSelectedOne);
    on<Regmv7UploadFotoObjectSelectedList>(_onSelectedList);

    on<Regmv7UploadFotoObjectResetPreview>(_onResetPreview);

    on<Regmv7UploadFotoObjectBatchSubmit>(_onBatchSubmit);
    on<Regmv7UploadFotoObjectSubmitted>(_onSubmittedUploadAll);

    on<Regmv7StorageUploadMany>(_onUploadMany);
    on<Regmv7UploadFotoObjectUploadOne>(_onUploadOne);

    on<Regmv7StorageRemoveAttachment>(_onRemove);
  }

  static const int _maxItems = 10;

  bool get _isMaxReached => state.items.length >= _maxItems;

  static const String _lockedMsg =
      "Sedang menghitung premi, foto tidak bisa diubah dulu.";

  bool get _isActionLocked => state.isUploadingAll || state.isClearing;

  void _emitLockedToast(Emitter<Regmv7UploadFotoObjectState> emit) {
    _emitToast(emit, _lockedMsg);
  }

  void _emitToast(Emitter<Regmv7UploadFotoObjectState> emit, String msg) {
    emit(state.copyWith(toast: msg));
    emit(state.copyWith(clearToast: true));
  }

  void _emitMaxToast(Emitter<Regmv7UploadFotoObjectState> emit) {
    _emitToast(emit, "Maksimal $_maxItems file.");
  }

  void _emitOverPickedToast(Emitter<Regmv7UploadFotoObjectState> emit) {
    _emitToast(emit, "Maksimal foto $_maxItems. Sisanya tidak ditambahkan.");
  }

  // ================= PICKERS =================

  Future<void> _onPickCamera(
      Regmv7StoragePickImageFromCamera event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (_isActionLocked) {
      _emitLockedToast(emit);
      return;
    }

    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final item = await pickerRepository.pickFromCamera();
    if (item == null) return;

    emit(state.copyWith(items: [...state.items, item]));
  }

  Future<void> _onPickFiles(
      Regmv7StoragePickFilesFromStorage event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (_isActionLocked) {
      _emitLockedToast(emit);
      return;
    }

    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final picked = await pickerRepository.pickFiles();
    if (picked.isEmpty) return;

    final remaining = _maxItems - state.items.length;
    final accepted = picked.take(remaining).toList();

    emit(state.copyWith(items: [...state.items, ...accepted]));

    if (picked.length > accepted.length) {
      _emitOverPickedToast(emit);
    }
  }

  // ================= MANUAL SELECT (PATH/NAME) =================

  Future<void> _onSelectedOne(
      Regmv7UploadFotoObjectSelected event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final model = await _modelFromPath(event.filePath, event.fileName);
    if (model == null) return;

    emit(state.copyWith(items: [...state.items, model]));
  }

  Future<void> _onSelectedList(
      Regmv7UploadFotoObjectSelectedList event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final pairs = _zipPathsNames(event.filePaths, event.fileNames);
    if (pairs.isEmpty) return;

    final remaining = _maxItems - state.items.length;
    final accepted = pairs.take(remaining).toList();

    final models = <Regmv7UploadModel>[];
    for (final pair in accepted) {
      final m = await _modelFromPath(pair.$1, pair.$2);
      if (m != null) models.add(m);
    }

    if (models.isEmpty) return;

    emit(state.copyWith(items: [...state.items, ...models]));

    if (pairs.length > accepted.length) {
      _emitOverPickedToast(emit);
    }
  }

  // ================= RESET =================

  Future<void> _onResetPreview(
      Regmv7UploadFotoObjectResetPreview event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    emit(state.copyWith(isClearing: true, items: const []));
    emit(state.copyWith(isClearing: false));
  }

  // ================= REMOVE =================

  Future<void> _onRemove(
      Regmv7StorageRemoveAttachment event,
      Emitter<Regmv7UploadFotoObjectState> emit,
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

    final serverId = (current.serverId ?? '');
    if (serverId.isNotEmpty) {
      regmv7formBloc.add(Regmv7FormHapusEvent(recordId: serverId));
    }

    final newItems = state.items.where((e) => e.localId != localId).toList();
    emit(state.copyWith(items: newItems));
  }

  // ================= SUBMIT HELPERS =================

  Future<void> _onBatchSubmit(
      Regmv7UploadFotoObjectBatchSubmit event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    // if (event.filePaths.isEmpty || event.names.isEmpty) {
    //   _emitToast(emit, "Minimal pilih 1 file atau foto");
    //   return;
    // } //opsional

    final pairs = _zipPathsNames(event.filePaths, event.names);
    if (pairs.isEmpty) {
      _emitToast(emit, "Data file tidak valid");
      return;
    }

    if (_isMaxReached) {
      _emitMaxToast(emit);
      return;
    }

    final remaining = _maxItems - state.items.length;
    final accepted = pairs.take(remaining).toList();

    final newModels = <Regmv7UploadModel>[];
    for (final pair in accepted) {
      final m = await _modelFromPath(pair.$1, pair.$2);
      if (m != null) newModels.add(m);
    }

    if (newModels.isNotEmpty) {
      emit(state.copyWith(items: [...state.items, ...newModels]));
    }

    if (pairs.length > accepted.length) {
      _emitOverPickedToast(emit);
    }

    final localIds = newModels.map((e) => e.localId).toList();
    if (localIds.isEmpty) return;

    add(Regmv7StorageUploadMany(regmv1Id: event.regmv1Id, localIds: localIds));
  }

  Future<void> _onSubmittedUploadAll(
      Regmv7UploadFotoObjectSubmitted event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (state.items.isEmpty) {
      _emitToast(emit, "Minimal pilih 1 file atau foto");
      return;
    }

    final pendingLocalIds = state.items
        .where((e) => (e.serverId ?? '').isEmpty)
        .map((e) => e.localId)
        .toList();

    if (pendingLocalIds.isEmpty) {
      _emitToast(emit, "Semua file sudah ter-upload.");
      return;
    }

    emit(state.copyWith(isUploadingAll: true, uploadAllDone: false));

    for (final localId in pendingLocalIds) {
      await _uploadOneInternalAwait(
        localId: localId,
        regmv1Id: event.regmv1Id,
        caption: event.caption,
        emit: emit,
      );
      await Future.delayed(const Duration(milliseconds: 150));
    }

    emit(state.copyWith(isUploadingAll: false, uploadAllDone: true));
  }

  // ================= UPLOAD MANY =================

  Future<void> _onUploadMany(
      Regmv7StorageUploadMany event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    if (event.localIds.isEmpty) {
      _emitToast(emit, "Minimal pilih 1 file atau foto");
      return;
    }

    emit(state.copyWith(isUploadingAll: true, uploadAllDone: false));

    for (final localId in event.localIds) {
      await _uploadOneInternalAwait(
        localId: localId,
        regmv1Id: event.regmv1Id,
        caption: "",
        emit: emit,
      );
      await Future.delayed(const Duration(milliseconds: 150));
    }

    emit(state.copyWith(isUploadingAll: false, uploadAllDone: true));
  }

  // ================= UPLOAD ONE =================

  Future<void> _onUploadOne(
      Regmv7UploadFotoObjectUploadOne event,
      Emitter<Regmv7UploadFotoObjectState> emit,
      ) async {
    final idx = state.items.indexWhere((e) => e.localId == event.localId);
    if (idx < 0) {
      final m = await _modelFromPath(
        event.filePath,
        event.fileName,
        localId: event.localId,
      );
      if (m != null) {
        emit(state.copyWith(items: [...state.items, m]));
      }
    }

    await _uploadOneInternalAwait(
      localId: event.localId,
      regmv1Id: event.regmv1Id,
      caption: event.caption,
      emit: emit,
      overridePath: event.filePath,
      overrideName: event.fileName,
    );
  }

  // ================= CORE UPLOAD =================

  Future<void> _uploadOneInternalAwait({
    required String localId,
    required String regmv1Id,
    required String caption,
    required Emitter<Regmv7UploadFotoObjectState> emit,
    String? overridePath,
    String? overrideName,
  }) async {
    final idx = state.items.indexWhere((e) => e.localId == localId);
    if (idx < 0) return;

    final current = state.items[idx];

    if ((current.serverId ?? '').isNotEmpty) return;
    if (current.status == UploadStatus.uploading) return;

    final path = (overridePath ?? current.path);
    final name = (overrideName ?? current.name);

    if (path.isEmpty || name.isEmpty) {
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

    final token = CancelToken();
    _cancelTokens[localId]?.cancel("Replaced");
    _cancelTokens[localId] = token;

    try {
      // NOTE: agar cancelToken/progress beneran jalan,
      // api/repo perlu menerima cancelToken & onSendProgress.
      final returnData = await repository.uploadFotoAccByPath(
        regmv1Id,
        caption,
        path,
        name,
      );

      if (returnData.success == true) {
        final serverId = returnData.data.toString();
        _updateItem(emit, localId, (x) => x.copyWith(
          status: UploadStatus.success,
          progress: 1.0,
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
    } finally {
      _cancelTokens.remove(localId);
    }
  }

  // ================= HELPERS =================

  void _updateItem(
      Emitter<Regmv7UploadFotoObjectState> emit,
      String localId,
      Regmv7UploadModel Function(Regmv7UploadModel) map,
      ) {
    final updated =
    state.items.map((e) => e.localId == localId ? map(e) : e).toList();
    emit(state.copyWith(items: updated));
  }

  List<(String, String)> _zipPathsNames(List<String> paths, List<String> names) {
    final n = paths.length < names.length ? paths.length : names.length;
    if (n <= 0) return [];
    return List.generate(n, (i) => (paths[i], names[i]));
  }

  Future<Regmv7UploadModel?> _modelFromPath(
      String filePath,
      String fileName, {
        String? localId,
      }) async {
    if (filePath.isEmpty) return null;

    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final size = await file.length();
      final mime = lookupMimeType(filePath);

      final isImage = (mime?.startsWith('image/') ?? false) ||
          ['.jpg', '.jpeg', '.png', '.heic']
              .contains(p.extension(filePath).toLowerCase());

      return Regmv7UploadModel(
        localId: localId ?? _uuid.v4(),
        name: fileName.isNotEmpty ? fileName : p.basename(filePath),
        path: filePath,
        size: size,
        mime: mime,
        isImage: isImage,
      );
    } catch (_) {
      return null;
    }
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