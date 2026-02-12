import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ImageSourceChooser {
  static final ImagePicker _picker = ImagePicker();

  static Future<File?> show(BuildContext context) {
    return showModalBottomSheet<File?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => const _ChooserSheet(),
    );
  }

  static Future<File?> pickCamera() async {
    final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    return x == null ? null : File(x.path);
  }

  static Future<File?> pickGallery() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    return x == null ? null : File(x.path);
  }

  static Future<File?> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result == null) return null;

    final path = result.files.single.path;
    if (path == null) return null;
    return File(path);
  }
}

class _ChooserSheet extends StatelessWidget {
  const _ChooserSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _item(
              context,
              icon: Icons.camera_alt,
              title: 'Kamera',
              onTap: () async {
                final f = await ImageSourceChooser.pickCamera();
                Navigator.pop(context, f);
              },
            ),
            _item(
              context,
              icon: Icons.photo_library,
              title: 'Galeri',
              onTap: () async {
                final f = await ImageSourceChooser.pickGallery();
                Navigator.pop(context, f);
              },
            ),
            _item(
              context,
              icon: Icons.folder,
              title: 'Files / Drive',
              onTap: () async {
                final f = await ImageSourceChooser.pickFiles();
                Navigator.pop(context, f);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Future<void> Function() onTap,
      }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
