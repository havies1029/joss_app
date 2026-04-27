import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../models/gen_regmv/regmv5upload_model.dart';

abstract class Regmv5PickerRepository {
  Future<Regmv5UploadModel?> pickFromCamera();
  Future<List<Regmv5UploadModel>> pickFiles();
}

class Regmv5PickerRepositoryImpl implements Regmv5PickerRepository {
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  @override
  Future<Regmv5UploadModel?> pickFromCamera() async {
    final XFile? xf = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xf == null) return null;

    final file = File(xf.path);
    final size = await file.length();
    final name = p.basename(xf.path);
    final mime = lookupMimeType(xf.path);

    return Regmv5UploadModel(
      localId: _uuid.v4(),
      name: name,
      path: xf.path,
      size: size,
      mime: mime,
      isImage: true,
    );
  }

  @override
  Future<List<Regmv5UploadModel>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'pdf',
        'doc',
        'docx',
      ],
    );

    if (result == null || result.files.isEmpty) return [];

    final items = <Regmv5UploadModel>[];

    for (final f in result.files) {
      final path = f.path;
      if (path == null) continue;

      final ext = p.extension(path).toLowerCase();

      final allowed = [
        '.png',
        '.jpg',
        '.jpeg',
        '.pdf',
        '.doc',
        '.docx',
      ];

      // 🔒 SECURITY FILTER (WAJIB)
      if (!allowed.contains(ext)) continue;

      final mime = lookupMimeType(path);
      final isImage = ['.png', '.jpg', '.jpeg'].contains(ext);

      items.add(Regmv5UploadModel(
        localId: _uuid.v4(),
        name: f.name,
        path: path,
        size: f.size,
        mime: mime,
        isImage: isImage,
      ));
    }

    return items;
  }
}