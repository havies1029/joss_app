// lib/utils/image_uploader.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/profile/profile_upload_foto_bloc.dart';
import '../blocs/user_profile/user_profile_cubit.dart';

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

      // kirim ke server via bloc
      context.read<ProfileUploadFotoBloc>().add(
        UploadProfilePicture(bytes, fileName),
      );

      // optimistic UI: langsung ganti avatar
      // context.read<UserProfileCubit>().setProfile(fotoBytes: bytes);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih foto: $e')),
      );
    }
  }
}
