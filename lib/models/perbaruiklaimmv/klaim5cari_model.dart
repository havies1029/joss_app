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

  Klaim5cariModel({
    required this.jenisDocLain,
    required this.klaim1Id,
    required this.klaim5Id,
    required this.mjenisdocId,
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

  static String? _buildFileUrl(Map<String, dynamic> data) {
    final rawFileUrl = data['fileUrl']?.toString();
    if (rawFileUrl == null || rawFileUrl.isEmpty) return null;

    final baseUri = Uri.parse(AppData.apiDomain);
    final rawUri = Uri.parse(rawFileUrl);
    final fullUri = rawUri.hasScheme ? rawUri : baseUri.resolve(rawFileUrl);
    final klaim5Id = data['klaim5Id']?.toString() ?? '';

    if (fullUri.queryParameters.containsKey('klaim5Id')) {
      return fullUri.replace(queryParameters: {
        ...fullUri.queryParameters,
        'klaim5Id': fullUri.queryParameters['klaim5Id'] ?? klaim5Id,
      }).toString();
    }

    if (klaim5Id.isNotEmpty &&
        fullUri.path.contains('/api/perbaruiklaimmv/klaim5cari/getfile/')) {
      final apiUri = baseUri.resolve('api/perbaruiklaimmv/klaim5cari/getfile');
      return apiUri.replace(queryParameters: {
        'klaim5Id': klaim5Id,
      }).toString();
    }

    return fullUri.toString();
  }

  factory Klaim5cariModel.fromJson(Map<String, dynamic> data) {
    return Klaim5cariModel(
      jenisDocLain: data['jenisDocLain'] ?? '',
      klaim1Id: data['klaim1Id'] ?? '',
      klaim5Id: data['klaim5Id'] ?? '',
      mjenisdocId: data['mjenisdocId'] ?? '',
      jenisNama: data['jenisNama'] ?? '',
      fileUrl: _buildFileUrl(data),
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

  Map<String, dynamic> toJson() => {
    'jenisDocLain': jenisDocLain,
    'klaim1Id': klaim1Id,
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
    String? mjenisdocId,
    String? jenisNama,
    String? localPath,
    String? fileUrl,
    String? fileName,
    String? mimeType,
    int? fileSizeBytes,
    DateTime? uploadedAt,
    double? uploadProgress,
    String? uploadStatus,
    String? errorMessage,
    bool clearError = false,
  }) {
    return Klaim5cariModel(
      jenisDocLain: jenisDocLain ?? this.jenisDocLain,
      klaim5Id: klaim5Id ?? this.klaim5Id,
      mjenisdocId: mjenisdocId ?? this.mjenisdocId,
      klaim1Id: klaim1Id ?? this.klaim1Id,
      jenisNama: jenisNama ?? this.jenisNama,
      localPath: localPath ?? this.localPath,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
