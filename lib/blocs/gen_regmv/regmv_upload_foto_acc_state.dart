part of 'regmv_upload_foto_acc_bloc.dart';

class Regmv7UploadFotoObjectState extends Equatable {
  final List<Regmv7UploadModel> items;
  final String? toast;
  final bool isClearing;
  final bool uploadAllDone;
  final bool isUploadingAll;

  const Regmv7UploadFotoObjectState({
    this.items = const [],
    this.toast,
    this.isClearing = false,
    this.uploadAllDone = false,
    this.isUploadingAll = false,
  });

  Regmv7UploadFotoObjectState copyWith({
    List<Regmv7UploadModel>? items,
    String? toast,
    bool clearToast = false,
    bool? isClearing,
    bool? uploadAllDone,
    bool? isUploadingAll,
  }) {
    return Regmv7UploadFotoObjectState(
      items: items ?? this.items,
      toast: clearToast ? null : (toast ?? this.toast),
      isClearing: isClearing ?? this.isClearing,
      uploadAllDone: uploadAllDone ?? false, // auto reset
      isUploadingAll: isUploadingAll ?? this.isUploadingAll,
    );
  }

  @override
  List<Object?> get props => [
    items,
    toast,
    isClearing,
    uploadAllDone,
    isUploadingAll,
  ];
}