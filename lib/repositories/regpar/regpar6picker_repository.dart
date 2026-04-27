import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../models/regpar/regpar6upload_model.dart';

abstract class Regpar6PickerRepository {
  Future<Regpar6UploadModel?> pickFromCamera();
  Future<List<Regpar6UploadModel>> pickFiles();
}

class Regpar6PickerRepositoryImpl implements Regpar6PickerRepository {
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  @override
  Future<Regpar6UploadModel?> pickFromCamera() async {
    final XFile? xf = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xf == null) return null;

    final file = File(xf.path);
    final size = await file.length();
    final name = p.basename(xf.path);
    final mime = lookupMimeType(xf.path);

    return Regpar6UploadModel(
      // localId: _uuid.v4(),
      localId: _uuid.v4(),
      name: name,
      path: xf.path,
      size: size,
      mime: mime,
      isImage: true,
    );
  }

  @override
  Future<List<Regpar6UploadModel>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
        'doc',
        'docx',
      ],
    );
    if (result == null || result.files.isEmpty) return [];
    final items = <Regpar6UploadModel>[];
    for (final f in result.files) {
      final path = f.path;
      if (path == null) continue;
      final ext = p.extension(path).toLowerCase();
      const allowed = [
        '.jpg',
        '.jpeg',
        '.png',
        '.pdf',
        '.doc',
        '.docx',
      ];
      if (!allowed.contains(ext)) continue;
      final mime = lookupMimeType(path);
      final isImage = ['.jpg', '.jpeg', '.png'].contains(ext);
      items.add(Regpar6UploadModel(
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