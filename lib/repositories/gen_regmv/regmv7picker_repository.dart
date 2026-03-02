import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../models/gen_regmv/regmv7upload_model.dart';

abstract class Regmv7PickerRepository {
  Future<Regmv7UploadModel?> pickFromCamera();
  Future<List<Regmv7UploadModel>> pickFiles();
}

class Regmv7PickerRepositoryImpl implements Regmv7PickerRepository {
  final ImagePicker _imagePicker = ImagePicker();
  final Uuid _uuid = const Uuid();

  @override
  Future<Regmv7UploadModel?> pickFromCamera() async {
    final XFile? xf = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xf == null) return null;

    final file = File(xf.path);
    final size = await file.length();
    final name = p.basename(xf.path);
    final mime = lookupMimeType(xf.path);

    return Regmv7UploadModel(
      localId: _uuid.v4(),
      name: name,
      path: xf.path,
      size: size,
      mime: mime,
      isImage: true,
    );
  }

  @override
  Future<List<Regmv7UploadModel>> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: false,
      type: FileType.custom,
      allowedExtensions: [
        'pdf','jpg','jpeg','png','heic','txt',
        'doc','docx','xls','xlsx','ppt','pptx',
        'zip','rar','mp4','mov'
      ],
    );

    if (result == null || result.files.isEmpty) return [];

    final items = <Regmv7UploadModel>[];
    for (final f in result.files) {
      final path = f.path;
      if (path == null) continue;

      final mime = lookupMimeType(path);
      final isImage = (mime?.startsWith('image/') ?? false) ||
          ['.jpg', '.jpeg', '.png', '.heic']
              .contains(p.extension(path).toLowerCase());

      items.add(Regmv7UploadModel(
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