// lib/utils/image_uploader.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/profile/profile_upload_foto_bloc.dart';
import '../blocs/profile/profile_download_foto_bloc.dart'; // NEW

class ImageUploader {
  static Future<void> pickAndUpload(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 88,
      );

      if (picked == null) return;

      final bytes = await picked.readAsBytes();
      final fileName = picked.name;

      context.read<ProfileDownloadFotoBloc>().add(
        SetLocalPreviewImage(bytes),
      );

      // 2) upload ke server via bloc
      context.read<ProfileUploadFotoBloc>().add(
        UploadProfilePicture(bytes, fileName),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto: $e')),
      );
    }
  }
}