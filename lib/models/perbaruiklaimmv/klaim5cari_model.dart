import 'package:joss_app/common/app_data.dart';
class Klaim5cariModel {
  String klaim1Id;
  String jenisDocLain;
  String klaim5Id;
  String mjenisdocId;
  String jenisNama;
  String? fileUrl;
  String? fileName;
  String? mimeType;
  int? fileSizeBytes;
  DateTime? uploadedAt;
  // ===== local UI fields (optional, JANGAN dikirim ke server) =====
  String? localPath;
  double uploadProgress;
  String uploadStatus; // idle|uploading|success|failed
  String? errorMessage;

  Klaim5cariModel({required this.jenisDocLain, required this.klaim1Id, required this.klaim5Id, 		required this.mjenisdocId,
    required this.jenisNama,
    this.fileUrl,
    this.fileName,
    this.mimeType,
    this.fileSizeBytes,
    this.uploadedAt,
    this.localPath,
    this.uploadProgress = 0.0,
    this.uploadStatus = 'idle',
    this.errorMessage,
  });

  factory Klaim5cariModel.fromJson(Map<String, dynamic> data) {
    return Klaim5cariModel(
      jenisDocLain: data['jenisDocLain']??'',
      klaim1Id: data['klaim1Id']??'',
      klaim5Id: data['klaim5Id']??'', 			mjenisdocId: data['mjenisdocId']??'',
      jenisNama: data['jenisNama']??'',
      fileUrl: data['fileUrl'] == null
          ? null
          : '${AppData.apiDomain}${data['fileUrl'].toString()}',
      fileName: data['fileName']?.toString(),
      mimeType: data['mimeType']?.toString(),
      fileSizeBytes: data['fileSizeBytes'] is int
          ? data['fileSizeBytes'] as int
          : int.tryParse('${data['fileSizeBytes']}'),
      uploadedAt: data['uploadedAt'] != null
          ? DateTime.tryParse('${data['uploadedAt']}')
          : null,
    );

  }

  Map<String, dynamic> toJson() =>
      {
        'jenisDocLain': jenisDocLain,		'klaim1Id': klaim1Id,
        'klaim5Id': klaim5Id,
        'mjenisdocId': mjenisdocId,
        'jenisNama': jenisNama,
        'fileUrl': fileUrl,
        'fileName': fileName,
        'mimeType': mimeType,
        'fileSizeBytes': fileSizeBytes,
        'uploadedAt': uploadedAt?.toIso8601String(),
      };

  Klaim5cariModel copyWith({
    String? jenisDocLain,
    String? klaim5Id,
    String? klaim1Id,
    String? jenisNama,
    String? localPath,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    double? uploadProgress,
    String? uploadStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return Klaim5cariModel(
      jenisDocLain: jenisDocLain ?? this.jenisDocLain,
      klaim5Id: klaim5Id ?? this.klaim5Id,
      // mjenisdocId: mjenisdocId ?? mjenisdocId,
      mjenisdocId: mjenisdocId ?? mjenisdocId,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      jenisNama: jenisNama ?? this.jenisNama,
      localPath: localPath ?? this.localPath,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );

  }
}