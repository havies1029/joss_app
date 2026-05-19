part of 'regpar_upload_foto_object_bloc.dart';

class RegParUploadFotoObjectState extends Equatable {
  final List<Regpar6UploadModel> items;
  final String? toast;
  final bool isClearing;
  final bool uploadAllDone;
  final bool isUploadingAll;
  final bool isActionLocked;

  const RegParUploadFotoObjectState({
    this.items = const [],
    this.toast,
    this.isClearing = false,
    this.uploadAllDone = false,
    this.isUploadingAll = false,
    this.isActionLocked = false,
  });

  bool get canModifyItems => !isActionLocked && !isUploadingAll && !isClearing;

  RegParUploadFotoObjectState copyWith({
    List<Regpar6UploadModel>? items,
    String? toast,
    bool clearToast = false,
    bool? isClearing,
    bool? uploadAllDone,
    bool? isUploadingAll,
    bool? isActionLocked,
  }) {
    return RegParUploadFotoObjectState(
      items: items ?? this.items,
      toast: clearToast ? null : (toast ?? this.toast),
      isClearing: isClearing ?? this.isClearing,
      uploadAllDone: uploadAllDone ?? false, // auto reset
      isUploadingAll: isUploadingAll ?? this.isUploadingAll,
      isActionLocked: isActionLocked ?? this.isActionLocked,
    );
  }

  @override
  List<Object?> get props => [
    items,
    toast,
    isClearing,
    uploadAllDone,
    isUploadingAll,
    isActionLocked,
  ];
}