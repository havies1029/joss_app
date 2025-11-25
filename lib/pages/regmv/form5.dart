import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joss_app/common/constants.dart';

import 'package:joss_app/blocs/gen_regmv/regmv5form_bloc.dart';

class Regmv5FormFormPage extends StatefulWidget {
  final String viewMode;
  final String recordId;        // regmv5Id (primary key) -> belum dipakai saat tambah
  final String? parentRegmv1Id; // FK ke regmv1
  final bool initiallyExpanded;

  const Regmv5FormFormPage({
    super.key,
    required this.viewMode,
    required this.recordId,
    this.parentRegmv1Id,
    this.initiallyExpanded = false,
  });

  @override
  State<Regmv5FormFormPage> createState() => _Regmv5FormFormPageState();
}

class _Regmv5FormFormPageState extends State<Regmv5FormFormPage> {
  late String parentRegmv1Id;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    parentRegmv1Id = widget.parentRegmv1Id ?? "";
    isExpanded = widget.initiallyExpanded;

    debugPrint("🔥 [FORM5] initState() parentRegmv1Id = $parentRegmv1Id");
    debugPrint("🔥 [FORM5] viewMode = ${widget.viewMode}, recordId = ${widget.recordId}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🧱 [FORM5] build() dipanggil, isExpanded = $isExpanded");

    return BlocListener<Regmv5FormBloc, Regmv5FormState>(
      listenWhen: (prev, curr) =>
      prev.isUploading != curr.isUploading ||
          prev.isUploaded != curr.isUploaded ||
          prev.hasFailure != curr.hasFailure ||
          prev.fotoPath != curr.fotoPath,
      listener: (context, state) {
        debugPrint("[Regmv5Form][KTP][LISTENER] => "
            "isUploading=${state.isUploading}, "
            "isUploaded=${state.isUploaded}, "
            "hasFailure=${state.hasFailure}, "
            "fotoBytes.len=${state.fotoBytes?.length ?? 0}, "
            "fotoPath='${state.fotoPath}'");

        if (state.isUploaded && !state.hasFailure) {
          debugPrint("[Regmv5Form][KTP][LISTENER] ✅ Upload sukses, tampilkan snackbar OK");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload foto KTP berhasil")),
          );
        } else if (state.isUploaded && state.hasFailure) {
          debugPrint("[Regmv5Form][KTP][LISTENER] ❌ Upload gagal, tampilkan snackbar FAILED");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload foto KTP gagal")),
          );
        }
      },
      child: BlocBuilder<Regmv5FormBloc, Regmv5FormState>(
        builder: (context, state) {
          // langsung pakai state.fotoBytes saja, ga perlu fromList
          final Uint8List? fotoBytes = state.fotoBytes;

          debugPrint("[Regmv5Form][KTP][BUILDER] state snapshot => "
              "isUploading=${state.isUploading}, "
              "isUploaded=${state.isUploaded}, "
              "hasFailure=${state.hasFailure}, "
              "isPendingUpload=${state.isPendingUpload}, "
              "fotoBytes.len=${fotoBytes?.length ?? 0}, "
              "fotoPath='${state.fotoPath}'");

          return Container(
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              initiallyExpanded: isExpanded,
              onExpansionChanged: (v) {
                debugPrint("📂 [FORM5] ExpansionTile onExpansionChanged => $v");
                setState(() => isExpanded = v);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Upload Foto KTP",
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
                            final s = context.read<Regmv5FormBloc>().state;

                            final hasFoto =
                                (s.fotoBytes != null && s.fotoBytes!.isNotEmpty) ||
                                    s.fotoPath.isNotEmpty;

                            debugPrint("✅[FORM5][CHECK] ditekan:"
                                " isUploaded=${s.isUploaded},"
                                " hasFailure=${s.hasFailure},"
                                " hasFoto=$hasFoto,"
                                " fotoBytes.len=${s.fotoBytes?.length ?? 0},"
                                " fotoPath='${s.fotoPath}'");

                            if (!(s.isUploaded && !s.hasFailure && hasFoto)) {
                              debugPrint("✅[FORM5][CHECK] ❌ kondisi belum terpenuhi, tampilkan warning");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Silakan upload foto KTP terlebih dahulu'),
                                ),
                              );
                              return;
                            }

                            debugPrint("✅[FORM5][CHECK] ✔ kondisi OK, anggap data tersimpan (regmv5 sudah diinsert oleh API upload)");
                            // Di titik ini, API upload sudah simpan ke tabel regmv5.
                            // Tombol ini cuma "konfirmasi selesai" di sisi UI/flow.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data foto KTP dianggap tersimpan'),
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
                  title: const Text("Pilih & Upload Foto KTP"),
                  subtitle: Text(
                    (fotoBytes != null || state.fotoPath.isNotEmpty)
                        ? "Foto siap / sudah di-upload"
                        : "Belum ada file",
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.upload),
                  onTap: () async {
                    debugPrint("[FORM5][UI][KTP] onTap pilih gambar, parentRegmv1Id='$parentRegmv1Id'");

                    if (parentRegmv1Id.isEmpty) {
                      // Safety: pastikan Form 1 sudah tersimpan & regmv1Id ada
                      debugPrint("[FORM5][UI][KTP] ❌ parentRegmv1Id kosong, blok upload");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Silakan simpan Form 1 terlebih dahulu (regmv1Id belum tersedia).",
                          ),
                        ),
                      );
                      return;
                    }

                    debugPrint("[FORM5][UI][KTP] Mulai pick image... regmv1Id = $parentRegmv1Id");

                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1600,
                      maxHeight: 1600,
                      imageQuality: 90,
                    );

                    if (picked == null) {
                      debugPrint("[FORM5][UI][KTP] Picker batal (picked == null)");
                      return;
                    }

                    final bytes = await picked.readAsBytes();
                    final fileName = picked.name;

                    debugPrint("[FORM5][UI][KTP] Image picked:"
                        " name='$fileName',"
                        " path='${picked.path}',"
                        " bytes.len=${bytes.length}");

                    final bloc = context.read<Regmv5FormBloc>();

                    // 🟦 1) SELALU: simpan dulu ke state (kayak JobReal → Save2StateFotoBinary)
                    debugPrint("[FORM5][BLOC][DISPATCH] Save2StateBinaryFotoEvent("
                        "fileName=$fileName, bytes.len=${bytes.length}, imageSource=gallery)");

                    bloc.add(
                      Save2StateBinaryFotoEvent(
                        fotoBytes: bytes,
                        imageSource: "gallery",
                        fileName: fileName,
                      ),
                    );

                    // 🟦 2) HANYA KALAU viewMode != 'tambah' → langsung upload ke API
                    // 🟦 1) selalu save preview dulu
                    bloc.add(
                      Save2StateBinaryFotoEvent(
                        fotoBytes: bytes,
                        imageSource: "gallery",
                        fileName: fileName,
                      ),
                    );

// 🟦 2) upload ke API di SEMUA mode (tambah & ubah)
                    debugPrint("[FORM5][BLOC][DISPATCH] UploadBinaryFotoEvent("
                        "regmv1Id=$parentRegmv1Id, fileName=$fileName, bytes.len=${bytes.length}, imageSource=gallery)");

                    bloc.add(
                      UploadBinaryFotoEvent(
                        regmv1Id: parentRegmv1Id,
                        fileName: fileName,
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
                    child: Builder(
                      builder: (_) {
                        debugPrint("[FORM5][PREVIEW] tampilkan preview:"
                            " fotoBytes.len=${fotoBytes?.length ?? 0}, "
                            "fotoPath='${state.fotoPath}'");
                        if (fotoBytes != null) {
                          return Image.memory(fotoBytes, height: 180);
                        } else {
                          return Image.file(File(state.fotoPath), height: 180);
                        }
                      },
                    ),
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
