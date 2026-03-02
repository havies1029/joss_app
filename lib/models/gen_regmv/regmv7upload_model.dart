import 'package:equatable/equatable.dart';

enum UploadStatus { queued, uploading, success, failed, canceled }

class Regmv7UploadModel extends Equatable {
  final String localId;
  final String name;
  final String path;
  final int? size;
  final String? mime;
  final bool isImage;

  final UploadStatus status;
  final double progress; // 0..1
  final String? errorMessage;

  final String? serverId;
  final String? serverUrl;

  const Regmv7UploadModel({
    required this.localId,
    required this.name,
    required this.path,
    this.size,
    this.mime,
    required this.isImage,
    this.status = UploadStatus.queued,
    this.progress = 0.0,
    this.errorMessage,
    this.serverId,
    this.serverUrl,
  });

  bool get isPdf =>
      (mime == 'application/pdf') || name.toLowerCase().endsWith('.pdf');

  Regmv7UploadModel copyWith({
    UploadStatus? status,
    double? progress,
    String? errorMessage,
    String? serverId,
    String? serverUrl,
    bool clearServerId = false,
    bool clearServerUrl = false,
  }) {
    return Regmv7UploadModel(
      localId: localId,
      name: name,
      path: path,
      size: size,
      mime: mime,
      isImage: isImage,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      serverId: clearServerId ? null : (serverId ?? this.serverId),
      serverUrl: clearServerUrl ? null : (serverUrl ?? this.serverUrl),
    );
  }

  @override
  List<Object?> get props => [
    localId,
    name,
    path,
    size,
    mime,
    isImage,
    status,
    progress,
    errorMessage,
    serverId,
    serverUrl,
  ];
}
