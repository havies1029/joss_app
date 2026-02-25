import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../models/gen_regmv/stnk_pick_item.dart';

class StnkPickerRepository {
  final ImagePicker _imagePicker = ImagePicker();

  Future<StnkPickItem?> pickFromCamera() async {
    final XFile? xf = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (xf == null) return null;

    final bytes = await xf.readAsBytes();
    return StnkPickItem.create(bytes, p.basename(xf.path));
  }

  Future<List<StnkPickItem>> pickFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return [];

    return result.files
        .where((f) => f.bytes != null)
        .map((f) => StnkPickItem.create(f.bytes!, f.name))
        .toList();
  }
}