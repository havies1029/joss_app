
import 'package:flutter/cupertino.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaim5upload_repository.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaimmvdoccrud_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/models/perbaruiklaimmv/klaim5cari_model.dart';
import 'package:joss_app/repositories/perbaruiklaimmv/klaim5cari_repository.dart';

part 'klaim5cari_event.dart';
part 'klaim5cari_state.dart';

class Klaim5cariBloc extends Bloc<Klaim5cariEvents, Klaim5cariState> {
	Klaim5cariBloc() : super(const Klaim5cariState()) {
		on<FetchKlaim5cariEvent>(onFetchKlaim5cari);
		on<RefreshKlaim5cariEvent>(onRefreshKlaim5cari);
    on<Klaim5LocalFileSetEvent>(onKlaim5LocalFileSet);
    on<Klaim5DeleteRequestedEvent>(onKlaim5DeleteRequested);
    on<Klaim5UploadRequestedEvent>(onKlaim5UploadRequested);
    on<Klaim5ValidateDocumentsEvent>(onValidateDocuments);
	}

  Future<void> onValidateDocuments(
      Klaim5ValidateDocumentsEvent event,
      Emitter<Klaim5cariState> emit,
      ) async {
    final List<String> emptyIds = [];

    for (final e in state.items) {
      final hasLocal = (e.localPath ?? '').isNotEmpty;
      final hasUrl = (e.fileUrl ?? '').isNotEmpty;
      final hasFile = hasLocal || hasUrl;

      if (!hasFile) {
        if (e.klaim5Id.isNotEmpty) {
          emptyIds.add(e.klaim5Id);
        } else if (e.mjenisdocId.isNotEmpty) {
          emptyIds.add(e.mjenisdocId);
        } else {
          emptyIds.add(e.jenisDocLain);
        }
      }
    }

    emit(state.copyWith(
      emptyDocumentIds: emptyIds,
      isComplete: emptyIds.isEmpty,
    ));
  }

  Future<void> onRefreshKlaim5cari(
      RefreshKlaim5cariEvent event,
      Emitter<Klaim5cariState> emit,
      ) async {
    final repo = Klaim5cariRepository();

    emit(state.copyWith(
      isRefreshing: true,
      klaim1Id: event.klaim1Id,
    ));

    try {
      final items = await repo.getKlaim5cari(event.klaim1Id);

      emit(state.copyWith(
        klaim1Id: event.klaim1Id,
        items: items,
        status: ListStatus.success,
        hasReachedMax: true,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        klaim1Id: event.klaim1Id,
        errorMessage: e.toString(),
        isRefreshing: false,
      ));
    }
  }

  Future<void> onFetchKlaim5cari(
      FetchKlaim5cariEvent event, Emitter<Klaim5cariState> emit) async {
    if (state.hasReachedMax) return;

    Klaim5cariRepository repo = Klaim5cariRepository();
    if (state.status == ListStatus.initial) {
      List<Klaim5cariModel> items = await repo.getKlaim5cari(state.klaim1Id);
      return emit(state.copyWith(
        items: items,
        hasReachedMax: true,
        status: ListStatus.success,
        ));
      }
    }

  Future<void> onKlaim5LocalFileSet(
    Klaim5LocalFileSetEvent event, Emitter<Klaim5cariState> emit) async {
    // cari existing item
    final idx = state.items.indexWhere((x) =>
        ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
        ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

    // copy list dulu
    final newItems = List<Klaim5cariModel>.from(state.items);

    if (idx >= 0) {
      // ==== UPDATE ITEM YANG SUDAH ADA ====
      final oldItem = state.items[idx];

      final newItem = oldItem.copyWith(
        localPath: event.localPath,
        fileName: event.fileName,
        mimeType: event.mimeType,
        fileSizeBytes: event.fileSizeBytes,
        uploadProgress: 0.0,
        uploadStatus: 'idle',
        clearError: true,
      );

      newItems[idx] = newItem;
    }
    else {
      // ==== INSERT ITEM BARU (IDX TIDAK KETEMU) ====

      final newItem = Klaim5cariModel(
        klaim1Id: event.klaim1Id,
        jenisDocLain: event.jenisDocLain,            
        klaim5Id: '',    
        mjenisdocId: '', 
        jenisNama: '',                  
        fileUrl: '',
        fileName: event.fileName,
        mimeType: event.mimeType ?? '',
        fileSizeBytes: event.fileSizeBytes,
        uploadedAt: null,
        localPath: event.localPath,
        uploadProgress: 0.0,
        uploadStatus: 'idle',
        errorMessage: null,
      );

      // mau insert di awal atau akhir?
      // - kalau mau item baru muncul paling bawah dekat form: add()
      // - kalau mau muncul paling atas: insert(0, ...)
      newItems.add(newItem);
    }

    emit(state.copyWith(items: newItems));
  }

  Future<void> onKlaim5DeleteRequested(
      Klaim5DeleteRequestedEvent event,
      Emitter<Klaim5cariState> emit,
      ) async {
    debugPrint('=== onKlaim5DeleteRequested START ===');
    debugPrint('event.klaim5Id     : ${event.klaim5Id}');
    debugPrint('event.mjenisdocId  : ${event.mjenisdocId}');
    debugPrint('event.jenisDocLain : ${event.jenisDocLain}');
    debugPrint('state.klaim1Id     : ${state.klaim1Id}');
    debugPrint('state.items.length : ${state.items.length}');

    int idx = state.items.indexWhere((x) =>
    ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
        ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

    if (idx < 0) {
      debugPrint('DELETE ABORT: item tidak ditemukan di state');
      return;
    }

    final oldItem = state.items[idx];
    debugPrint('oldItem.klaim5Id   : ${oldItem.klaim5Id}');
    debugPrint('oldItem.fileName   : ${oldItem.fileName}');
    debugPrint('oldItem.fileUrl    : ${oldItem.fileUrl}');
    debugPrint('oldItem.localPath  : ${oldItem.localPath}');

    String klaim5Id = event.klaim5Id;
    final bool shouldClear = oldItem.mjenisdocId.isNotEmpty;

    // kalau klaim5Id kosong, refresh diam-diam dulu buat ambil id terbaru
    if (klaim5Id.isEmpty) {
      debugPrint('klaim5Id kosong, silent refresh dulu...');

      emit(state.copyWith(
        isRefreshing: true,
        klaim1Id: state.klaim1Id,
      ));

      try {
        final repo = Klaim5cariRepository();
        final freshItems = await repo.getKlaim5cari(state.klaim1Id);

        emit(state.copyWith(
          items: freshItems,
          klaim1Id: state.klaim1Id,
          status: ListStatus.success,
          hasReachedMax: true,
          isRefreshing: false,
        ));

        idx = freshItems.indexWhere((x) =>
        ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
            ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

        if (idx >= 0) {
          klaim5Id = freshItems[idx].klaim5Id;
          debugPrint('klaim5Id hasil refresh: $klaim5Id');
        } else {
          debugPrint('Item tidak ditemukan setelah refresh');
        }
      } catch (e) {
        emit(state.copyWith(isRefreshing: false));
        debugPrint('silent refresh gagal: $e');
      }
    }

    if (klaim5Id.isEmpty) {
      debugPrint('DELETE ABORT: klaim5Id masih kosong setelah refresh');
      return;
    }

    // cari lagi index berdasarkan state terbaru
    idx = state.items.indexWhere((x) =>
    ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
        ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

    if (idx < 0) {
      debugPrint('DELETE ABORT: item tidak ditemukan setelah refresh');
      return;
    }

    final currentItem = state.items[idx];
    final newItems = List<Klaim5cariModel>.from(state.items);

    // optimistic update
    if (shouldClear) {
      newItems[idx] = currentItem.copyWith(
        localPath: '',
        fileUrl: '',
        fileName: '',
        mimeType: '',
        fileSizeBytes: 0,
        uploadProgress: 0.0,
        uploadStatus: 'deleted',
        clearError: true,
      );
    } else {
      newItems.removeAt(idx);
    }

    emit(state.copyWith(items: newItems));
    debugPrint('Optimistic delete applied');

    // delete ke server
    try {
      final repository = KlaimmvdoccrudRepository();

      debugPrint('CALL DELETE SERVER => klaim5Id: $klaim5Id');
      final success = await repository.klaimmvdoccrudHapus(
        klaim5Id,
        event.mjenisdocId,
        event.jenisDocLain,
      );

      debugPrint('DELETE SERVER RESULT: $success');

      if (!success) {
        final rollbackItems = List<Klaim5cariModel>.from(state.items);

        final restoreIdx = rollbackItems.indexWhere((x) =>
        ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
            ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

        if (shouldClear) {
          if (restoreIdx >= 0) {
            rollbackItems[restoreIdx] = oldItem;
          }
        } else {
          rollbackItems.insert(idx, oldItem);
        }

        emit(state.copyWith(items: rollbackItems));
        debugPrint('Rollback karena delete server gagal');
        return;
      }

      // refresh akhir, tetap silent
      emit(state.copyWith(isRefreshing: true));

      final repo = Klaim5cariRepository();
      final latestItems = await repo.getKlaim5cari(state.klaim1Id);

      emit(state.copyWith(
        items: latestItems,
        klaim1Id: state.klaim1Id,
        status: ListStatus.success,
        hasReachedMax: true,
        isRefreshing: false,
      ));

      debugPrint('=== onKlaim5DeleteRequested DONE ===');
    } catch (e) {
      debugPrint('DELETE ERROR: $e');

      final rollbackItems = List<Klaim5cariModel>.from(state.items);

      final restoreIdx = rollbackItems.indexWhere((x) =>
      ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
          ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));

      if (shouldClear) {
        if (restoreIdx >= 0) {
          rollbackItems[restoreIdx] = oldItem;
        }
      } else {
        rollbackItems.insert(idx, oldItem);
      }

      emit(state.copyWith(
        items: rollbackItems,
        isRefreshing: false,
      ));
    }
  }

  Future<void> onKlaim5UploadRequested(Klaim5UploadRequestedEvent event, Emitter<Klaim5cariState> emit) async {
    final idx = state.items.indexWhere((x) =>
        ((x.mjenisdocId == event.mjenisdocId) && x.jenisDocLain.isEmpty) ||
        ((x.jenisDocLain == event.jenisDocLain) && x.mjenisdocId.isEmpty));
    if (idx < 0) return;

    final item = state.items[idx];
    if (item.localPath == '') return;

    final newItems = List<Klaim5cariModel>.from(state.items);

    // set status uploading
    var newItem = item.copyWith(
      uploadStatus: 'uploading',
      uploadProgress: 0.0,
      clearError: true,
    );
    newItems[idx] = newItem;
    emit(state.copyWith(items: newItems));

    // mulai upload
    Klaim5uploadRepository repository = Klaim5uploadRepository();
    try {
      await repository.uploadFile(state.klaim1Id, newItem);

      // jika sukses
      newItem = newItem.copyWith(
        uploadStatus: 'uploaded',
        uploadProgress: 1.0,
      );
      newItems[idx] = newItem;
      emit(state.copyWith(items: newItems));
    } catch (e) {
      // jika gagal
      newItem = newItem.copyWith(
        uploadStatus: 'error',
        clearError: false,
      );
      newItems[idx] = newItem;
      emit(state.copyWith(items: newItems));
    }
  }

}