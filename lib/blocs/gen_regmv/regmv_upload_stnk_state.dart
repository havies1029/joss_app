part of 'regmv_upload_stnk_bloc.dart';

class Regmv4UploadFotoObjectState extends Equatable {
  final List<Regmv4UploadModel> items;
  final String? toast;
  final bool isClearing;
  final bool uploadAllDone;
  final bool isUploadingAll;
  final bool isActionLocked;

  const Regmv4UploadFotoObjectState({
    this.items = const [],
    this.toast,
    this.isClearing = false,
    this.uploadAllDone = false,
    this.isUploadingAll = false,
    this.isActionLocked = false,
  });

  bool get canModifyItems => !isActionLocked && !isUploadingAll && !isClearing;

  Regmv4UploadFotoObjectState copyWith({
    List<Regmv4UploadModel>? items,
    String? toast,
    bool clearToast = false,
    bool? isClearing,
    bool? uploadAllDone,
    bool? isUploadingAll,
    bool? isActionLocked,
  }) {
    return Regmv4UploadFotoObjectState(
      items: items ?? this.items,
      toast: clearToast ? null : (toast ?? this.toast),
      isClearing: isClearing ?? this.isClearing,
      uploadAllDone: uploadAllDone ?? false,
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