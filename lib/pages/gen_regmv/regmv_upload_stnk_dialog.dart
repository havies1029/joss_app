import 'package:joss_app/blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class RegmvUploadStnkDialog extends StatefulWidget {
  final String regmv1Id;
  const RegmvUploadStnkDialog({super.key, required this.regmv1Id});

  @override
  State<RegmvUploadStnkDialog> createState() => _RegmvUploadStnkDialogState();
}

class _RegmvUploadStnkDialogState extends State<RegmvUploadStnkDialog> {
  final TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final bloc = context.read<RegmvUploadStnkBloc>(); // ambil dulu di sini!

    if (kIsWeb) {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.bytes != null) {
        bloc.add(
          UploadStnkSelected(
            result.files.single.bytes!,
            result.files.single.name,
          ),
        );
      }
    } else {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        bloc.add(UploadStnkSelected(bytes, picked.name));
      }
    }
  }


  Future<void> _pickFromCamera(BuildContext context) async {
    final bloc = context.read<RegmvUploadStnkBloc>();    

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      bloc.add(UploadStnkSelected(bytes, picked.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Upload Foto STNK"),
      content: BlocBuilder<RegmvUploadStnkBloc, RegmvUploadStnkState>(
        builder: (context, state) {
          Uint8List? imageBytes;
          if (state is UploadStnkPreview) imageBytes = state.imageBytes;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageBytes != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Image.memory(imageBytes, height: 150),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickFromGallery(context),
                    icon: const Icon(Icons.photo),
                    label: const Text("Galeri"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickFromCamera(context),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Kamera"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: captionController,
                decoration: const InputDecoration(
                  labelText: "Caption",
                  border: OutlineInputBorder(),
                ),
              ),
              if (state is UploadStnkLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        BlocBuilder<RegmvUploadStnkBloc, RegmvUploadStnkState>(
          builder: (context, state) {
            final isEnabled = state is UploadStnkPreview;

            return ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      context.read<RegmvUploadStnkBloc>().add(
                            UploadStnkSubmitted(
                              regmv1Id: widget.regmv1Id,
                              caption: captionController.text, // ← kirim caption!
                            ),
                          );
                      Navigator.pop(context);
                    }
                  : null,
              child: const Text("Upload"),
            );
          },
        ),
      ],
    );
  }
}
