part of 'regmv_upload_foto_mobil_bloc.dart';

class Regmv5UploadFotoObjectState extends Equatable {
  final List<Regmv5UploadModel> items;
  final String? toast;
  final bool isClearing;
  final bool uploadAllDone;
  final bool isUploadingAll;
  final bool isActionLocked;

  const Regmv5UploadFotoObjectState({
    this.items = const [],
    this.toast,
    this.isClearing = false,
    this.uploadAllDone = false,
    this.isUploadingAll = false,
    this.isActionLocked = false,
  });

  bool get canModifyItems =>
      !isActionLocked && !isUploadingAll && !isClearing;

  Regmv5UploadFotoObjectState copyWith({
    List<Regmv5UploadModel>? items,
    String? toast,
    bool clearToast = false,
    bool? isClearing,
    bool? uploadAllDone,
    bool? isUploadingAll,
    bool? isActionLocked,
  }) {
    return Regmv5UploadFotoObjectState(
      items: items ?? this.items,
      toast: clearToast ? null : (toast ?? this.toast),
      isClearing: isClearing ?? this.isClearing,
      uploadAllDone: uploadAllDone ?? false, // auto reset (ONE SHOT FLAG)
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