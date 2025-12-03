import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joss_app/common/constants.dart';

import 'package:joss_app/blocs/gen_regmv/regmv4form_bloc.dart';

class Regmv4FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;        // regmv4Id (primary key) -> belum dipakai saat tambah
  final String? parentRegmv1Id; // FK ke regmv1
  final bool initiallyExpanded;

  const Regmv4FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.parentRegmv1Id,
    this.initiallyExpanded = false,
  });

  @override
  State<Regmv4FormFormPage> createState() => _Regmv4FormFormPageState();
}

class _Regmv4FormFormPageState extends State<Regmv4FormFormPage> {
  late String parentRegmv1Id;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    parentRegmv1Id = widget.parentRegmv1Id ?? "";
    isExpanded = widget.initiallyExpanded;

    debugPrint("🔥 [FORM4] parentRegmv1Id diterima dari parent = $parentRegmv1Id");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Regmv4FormBloc, Regmv4FormState>(
      listenWhen: (prev, curr) =>
      prev.isUploading != curr.isUploading ||
          prev.isUploaded != curr.isUploaded ||
          prev.hasFailure != curr.hasFailure ||
          prev.fotoPath != curr.fotoPath,
      listener: (context, state) {
        debugPrint("[Regmv4Form][STNK] listener => "
            "isUploading=${state.isUploading}, "
            "isUploaded=${state.isUploaded}, "
            "hasFailure=${state.hasFailure}");

        if (state.isUploaded && !state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload STNK berhasil")),
          );
        } else if (state.isUploaded && state.hasFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload STNK gagal")),
          );
        }
      },
      child: BlocBuilder<Regmv4FormBloc, Regmv4FormState>(
        builder: (context, state) {
          Uint8List? fotoBytes = state.fotoBytes != null
              ? Uint8List.fromList(state.fotoBytes!)
              : null;

          return Container(
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              initiallyExpanded: isExpanded,
              onExpansionChanged: (v) => setState(() => isExpanded = v),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload Foto STNK",
                    style: bodyTextStyle(context),
                  ),
                  Row(
                    children: [
                      if (state.isUploading)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (isExpanded)
                        IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: primaryLightColor,
                            size: 26,
                          ),
                          tooltip: "Save / Confirm",
                          onPressed: () {
                            final s = context.read<Regmv4FormBloc>().state;

                            final hasFoto =
                                (s.fotoBytes != null && s.fotoBytes!.isNotEmpty) ||
                                    s.fotoPath.isNotEmpty;

                            if (!(s.isUploaded && !s.hasFailure && hasFoto)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Silakan upload foto STNK terlebih dahulu'),
                                ),
                              );
                              return;
                            }

                            // Di titik ini, API upload sudah simpan ke tabel regmv4
                            // (DataRegmv4Form.DataRegMv5UploadFotoMobil).
                            // Jadi tombol ini cuma "konfirmasi" seperti form lain.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data STNK dianggap tersimpan'),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
              children: [
                ListTile(
                  title: const Text("Pilih & Upload Foto STNK"),
                  subtitle: Text(
                    (fotoBytes != null || state.fotoPath.isNotEmpty)
                        ? "Foto siap / sudah di-upload"
                        : "Belum ada file",
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.upload),
                  onTap: () async {
                    if (parentRegmv1Id.isEmpty) {
                      // Safety: pastikan Form 1 sudah tersimpan dan regmv1Id ada
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Silakan simpan Form 1 dulu (regmv1Id belum ada)."),
                        ),
                      );
                      return;
                    }

                    debugPrint(
                        "[UI][STNK] Pilih gambar... regmv1Id = $parentRegmv1Id");

                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1600,
                      maxHeight: 1600,
                      imageQuality: 90,
                    );

                    if (picked == null) return;

                    final bytes = await picked.readAsBytes();
                    debugPrint("[UI][STNK] Bytes = ${bytes.length}");

                    // 🔥 kirim ke bloc, pakai regmv1Id sebagai referensi (FK)
                    // context.read<Regmv4FormBloc>().add(
                    //   UploadBinaryStnkEvent(
                    //     regmv1Id: parentRegmv1Id, // <- kunci FK
                    //     fileName: picked.name,
                    //     bytes: bytes,
                    //     imageSource: "gallery",
                    //   ),
                    // );

                    context.read<Regmv4FormBloc>().add(
                      UploadBinaryStnkEvent(
                        regmv1Id: parentRegmv1Id,
                        fileName: picked.name,
                        bytes: bytes,
                        imageSource: "gallery",
                      ),
                    );
                  },
                ),

                // PREVIEW FOTO
                if (fotoBytes != null || state.fotoPath.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: fotoBytes != null
                        ? Image.memory(fotoBytes, height: 180)
                        : Image.file(File(state.fotoPath), height: 180),
                  ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
