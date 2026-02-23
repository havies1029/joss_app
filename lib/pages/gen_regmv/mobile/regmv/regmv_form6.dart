import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:joss_app/blocs/gen_regmv/regmv_upload_foto_acc_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/thousand_separator_input_formatter.dart';

import '../../../../blocs/gen_regmv/regmv7cari_bloc.dart';
import '../../../../blocs/gen_regmv/regmv7form_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../models/gen_regmv/regmv7cari_model.dart';

class RegmvForm6Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1Id;

  const RegmvForm6Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regmv1Id
  });

  @override
  State<RegmvForm6Section> createState() => RegmvForm6SectionState();
}

class RegmvForm6SectionState extends State<RegmvForm6Section> {
  final _regmvform7key = GlobalKey<FormState>();
  final bool _showError = false;
  Completer<bool>? _validationCompleter;

  List<Uint8List> _images = [];
  List<String> _fileNames = [];
  late final Regmv7CariBloc  regmv7CariBloc;
  List<Regmv7CariModel> _serverPhotos = [];

  @override
  void initState() {
    super.initState();
    regmv7CariBloc = context.read<Regmv7CariBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Regmv7CariBloc, Regmv7CariState>(
      listener: (context, state) {
        debugPrint("────────── 📡 BlocListener Regmv7CariBloc TRIGGERED ──────────");
        debugPrint("state.status = ${state.status}");
        debugPrint("items count = ${state.items.length}");

        if (state.status == ListStatus.success) {
          debugPrint("🟢 Status SUCCESS → Update _serverPhotos");

          setState(() {
            _serverPhotos = List.from(state.items);
          });

          final hasServer = _serverPhotos.isNotEmpty;
          final hasLocal = _images.isNotEmpty;

          debugPrint("📦 Server Photos count = ${_serverPhotos.length}");
          debugPrint("📦 Local Images count  = ${_images.length}");
          debugPrint("hasServer = $hasServer | hasLocal = $hasLocal");

          if (_validationCompleter != null && !_validationCompleter!.isCompleted) {
            debugPrint("🧪 validationCompleter ACTIVE → Evaluating...");

            if (hasServer || hasLocal) {
              debugPrint("✅ Validation Passed → Complete(true)");
              _validationCompleter!.complete(true);
            } else {
              debugPrint("❌ Validation FAILED → No server & no local images");
              debugPrint("❌ Complete(false) + Show SnackBar");

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Harap unggah minimal 1 foto Aksesoris."),
                  backgroundColor: Colors.red,
                ),
              );

              _validationCompleter!.complete(false);
            }
          } else {
            if (_validationCompleter == null) {
              debugPrint("⚪ validationCompleter = NULL → Skip validation");
            } else {
              debugPrint("⚪ validationCompleter already COMPLETED");
            }
          }
        }

        debugPrint("────────────────────────── END LISTENER ─────────────────────────\n");
      },

      child: BlocBuilder<RegmvUploadFotoAccBloc, RegmvUploadFotoAccState>(
        builder: (context, state) {
          debugPrint("📦 BlocBuilder RegmvUploadFotoAccBloc BUILD → state = $state");

          if (state is UploadFotoAccListPreview) {
            debugPrint("🟣 UploadFotoAccListPreview RECEIVED");
            debugPrint("images count = ${state.images.length}");
            debugPrint("fileNames count = ${state.fileNames.length}");

            _images = List.from(state.images);
            _fileNames = List.from(state.fileNames);
          }

          return Card(
            color: pGrey,
            child: Column(
              children: [
                _buildHeader(),
                if (widget.isExpanded) _buildForm(),
              ],
            ),
          );
        },
      ),
    );

  }

  void onOpenedByParent() {
    if (widget.viewMode == "ubah" && widget.regmv1Id != null) {
      debugPrint("🔥 Form6 dibuka parent → trigger lihat event ${widget.regmv1Id}");
      regmv7CariBloc.add(RefreshRegmv7CariEvent(regmv1Id: widget.regmv1Id!));
    }
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Foto Aksesoris", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () {
        widget.onToggle(!widget.isExpanded);
      },
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(
        left: hPadding,
        right: hPadding,
        bottom: hPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _uploadInstructionBox(),
        ],
      ),
    );
  }

  Future<bool> validateAndReturn() async {
    debugPrint("──────────────────────────────");
    debugPrint("🧪 validateAndReturn() DIPANGGIL");

    _validationCompleter = Completer<bool>();
    debugPrint("📌 _validationCompleter CREATED (isCompleted = ${_validationCompleter!.isCompleted})");

    // Kondisi ubah → fetch ulang server photos
    if (widget.viewMode == "ubah" && widget.regmv1Id != null) {
      debugPrint("🟦 Mode UBAH terdeteksi");
      debugPrint("👉 Trigger RefreshRegmv7CariEvent(regmv1Id: ${widget.regmv1Id})");

      regmv7CariBloc.add(
        RefreshRegmv7CariEvent(regmv1Id: widget.regmv1Id!),
      );

      debugPrint("📨 RefreshRegmv7CariEvent SENT ke bloc");
    } else {
      debugPrint("⚪ Mode bukan 'ubah' atau regmv1Id null → SKIP fetch server");
    }

    debugPrint("⏳ Menunggu _validationCompleter.future...");
    final result = await _validationCompleter!.future;

    debugPrint("✅ _validationCompleter COMPLETED with result = $result");
    debugPrint("──────────────────────────────\n");

    return result;
  }



  Widget _uploadInstructionBox() {
    final blocState = context.watch<RegmvUploadFotoAccBloc>().state;

    List<Uint8List> previewImages = [];
    List<String> previewNames = [];

    if (blocState is UploadFotoAccListPreview) {
      _images = List.from(blocState.images);
      _fileNames = List.from(blocState.fileNames);

      previewImages = _images;
      previewNames = _fileNames;
    }

    final bool hasServer = _serverPhotos.isNotEmpty;
    final bool hasPreview = previewImages.isNotEmpty;
    final bool showIntro = !hasServer && !hasPreview;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: _showError ? Colors.red : sGrey),
        color: formGrey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          if (!showIntro)
            _buildGallery(previewImages),

          if (showIntro)
            _buildIntro(),

          const SizedBox(height: hPadding),

          _buildActionButtons(previewImages.length),

          const SizedBox(height: hPadding),

          _buildLocalUploadButton(),
        ],
      ),
    );
  }

  Widget _buildGallery(List<Uint8List> previewImages) {
    final total = previewImages.length + _serverPhotos.length;

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: total,
            itemBuilder: (context, index) {

              // PREVIEW FOTO (selalu kiri)
              if (index < previewImages.length) {
                return _buildPhotoTile(
                  content: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      previewImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  onDelete: () => _deletePreview(index),
                );
              }

              // FOTO SERVER
              final serverIndex = index - previewImages.length;
              final item = _serverPhotos[serverIndex];
              final url = "${AppData.apiDomain}api/regmv/regmv7cari/fotoacc/getfoto/${item.regmv7Id}";

              return _buildPhotoTile(
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    url,
                    headers: {
                      "Authorization": "Bearer ${AppData.userToken}",
                    },
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint("❌ Error load foto RMV5: $error");
                      return const Icon(Icons.broken_image, color: Colors.red, size: 48);
                    },
                  ),
                ),
                onDelete: () => _deleteServerPhoto(item.regmv7Id),
              );
            },
          ),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  void _deletePreview(int index) {
    debugPrint("🗑 delete preview at $index");

    _images.removeAt(index);
    _fileNames.removeAt(index);

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccSelectedList(List.from(_images), List.from(_fileNames)),
    );

    setState(() {});
  }

  void _deleteServerPhoto(String regmv7Id) {
    debugPrint("🗑 delete server photo $regmv7Id");

    setState(() {
      _serverPhotos.removeWhere((x) => x.regmv7Id == regmv7Id);
    });

    context.read<Regmv7FormBloc>().add(
      Regmv7FormHapusEvent(recordId: regmv7Id),
    );
  }

  Widget _buildIntro() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto Aksesoris",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto Aksesoris jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPhotoTile({
    required Widget content,
    required VoidCallback onDelete,
  }) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: content,
        ),

        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: onDelete,
            child: _buildDeleteCircle(),
          ),
        )
      ],
    );
  }

  Widget _buildActionButtons(int previewCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppButton.iconLeft(
            text: 'Pilih File',
            icon: SvgPicture.asset(
              'assets/icons/gallery_img.svg',
              width: 18,
              height: 18,
              color: Colors.white,
            ),
            backgroundColor: sGrey,
            onPressed: previewCount >= 10
                ? () => _maxReached()
                : () => _pickFromGallery(context),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton.iconLeft(
            text: 'Ambil Foto',
            icon: SvgPicture.asset(
              'assets/icons/photo_img.svg',
              width: 18,
              height: 18,
              color: Colors.white,
            ),
            onPressed: previewCount >= 10
                ? () => _maxReached()
                : () => _pickFromCamera(context),
          ),
        ),
      ],
    );
  }

  void _maxReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Maksimal 10 foto."),
        backgroundColor: Colors.red,
      ),
    );
  }


  Widget _buildLocalUploadButton() {
    final hasImages = _images.isNotEmpty;

    return SizedBox(
      height: 0,
      width: 0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(0, 0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: hasImages ? () => saveForm6() : null,
        child: const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final bloc = context.read<RegmvUploadFotoAccBloc>();
    if (_images.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maksimal 10 foto."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (var file in result.files) {
      if (_images.length >= 10) break;
      if (file.bytes == null) continue;

      _images.add(file.bytes!);
      _fileNames.add(file.name);
    }

    bloc.add(
      UploadFotoAccSelectedList(
        List.from(_images),
        List.from(_fileNames),
      ),
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    final bloc = context.read<RegmvUploadFotoAccBloc>();

    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      _images.add(bytes);
      _fileNames.add(picked.name);

      bloc.add(UploadFotoAccSelectedList(List.from(_images), List.from(_fileNames)));
    }
  }

  Widget _buildDeleteCircle() {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.close,
        color: Colors.white,
        size: 18,
      ),
    );
  }

  Future<bool> saveForm6() async {
    final hasLocalPhotos = _images.isNotEmpty;
    final hasServerPhotos = _serverPhotos.isNotEmpty;

    debugPrint("===== VALIDASI FORM 7 =====");
    debugPrint("Local photos  : $hasLocalPhotos (count=${_images.length})");
    debugPrint("Server photos : $hasServerPhotos (count=${_serverPhotos.length})");
    debugPrint("================================");

    // ❌ Tidak ada foto sama sekali → gagal
    if (!hasLocalPhotos && !hasServerPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap unggah minimal 1 foto ACC."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Jika tidak ada foto lokal (hanya foto server), maka tidak upload apa-apa
    if (!hasLocalPhotos) {
      debugPrint("✔ Hanya ada foto server → tidak upload ulang");
      return true;
    }

    // 🔥 Kalau ada foto lokal → trigger batch upload
    debugPrint("🔥 TRIGGER UPLOAD FOTO ACC --- total local: ${_images.length}");

    context.read<RegmvUploadFotoAccBloc>().add(
      UploadFotoAccBatchSubmit(
        regmv1Id: widget.regmv1Id ?? "",
        images: List.from(_images),
        names: List.from(_fileNames),
      ),
    );

    return true;
  }


}