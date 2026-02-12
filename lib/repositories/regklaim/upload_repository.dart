import 'dart:io';
import 'package:dio/dio.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:path/path.dart' as p;
import 'package:joss_app/models/regklaim/attachment_item.dart';

abstract class UploadRepository {
  Future<({String serverId, String serverUrl})> uploadAttachment({
    required String regklaim1Id,
    required AttachmentItem item,
    required void Function(double p) onProgress,
    required CancelToken cancelToken,
  });
}

class UploadRepositoryImpl implements UploadRepository {
  final Dio dio;

  UploadRepositoryImpl(this.dio);

  @override
  Future<({String serverId, String serverUrl})> uploadAttachment({
    required String regklaim1Id,
    required AttachmentItem item,
    required void Function(double p) onProgress,
    required CancelToken cancelToken,
  }) async {
    final file = File(item.path);

    final form = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
        contentType: item.mime != null ? DioMediaType.parse(item.mime!) : null,
      ),
      // optional tambahan:
      // 'docType': 'POLIS',
      // 'remarks': '...'
    });

    final base = AppData.apiDomain;
    String uploadFileEndpoint = "api/regklaim/regklaim1crud/$regklaim1Id/attachments";
    String uploadFileURL = base + uploadFileEndpoint;

    // final resp = await dio.post(
    //   uploadFileURL,
    //   data: form,
    //   cancelToken: cancelToken,
    //   onSendProgress: (sent, total) {
    //     if (total <= 0) return;
    //     onProgress(sent / total);
    //   },
    //   options: Options(contentType: 'multipart/form-data'),
    // );
    final resp = await dio.post(
      "api/regklaim/regklaim1crud/$regklaim1Id/attachments",
      data: form,
      cancelToken: cancelToken,
      onSendProgress: (sent, total) {
        if (total <= 0) return;
        onProgress(sent / total);
      },
    );

    // Sesuaikan parsing response server kamu:
    final data = resp.data;
    final serverId = (data['id'] ?? data['attachmentId'] ?? '').toString();
    final serverUrl = (data['url'] ?? data['fileUrl'] ?? '').toString();

    return (serverId: serverId, serverUrl: serverUrl);
  }
}
