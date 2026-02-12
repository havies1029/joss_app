import 'dart:io';
import 'package:flutter/material.dart';

import '../helper/image_source_chooser.dart';


class ImagePickerDummyPage extends StatefulWidget {
  const ImagePickerDummyPage({super.key});

  @override
  State<ImagePickerDummyPage> createState() => _ImagePickerDummyPageState();
}

class _ImagePickerDummyPageState extends State<ImagePickerDummyPage> {
  File? selectedImage;

  Future<void> onPickImage() async {
    debugPrint('🟢 onPickImage tapped');

    final file = await ImageSourceChooser.show(context);

    if (file == null) {
      debugPrint('⚠️ User batal pilih gambar');
      return;
    }

    debugPrint('✅ File picked: ${file.path}');
    setState(() {
      selectedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dummy Pick Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: onPickImage,
              child: const Text('Pilih Foto'),
            ),

            const SizedBox(height: 20),

            if (selectedImage == null)
              const Text(
                'Belum ada gambar dipilih',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: [
                  const Text(
                    'Preview:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Image.file(
                    selectedImage!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    selectedImage!.path,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
