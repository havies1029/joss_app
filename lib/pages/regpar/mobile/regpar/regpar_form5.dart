import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/regpar/regpar6cari_bloc.dart';
import '../../../../blocs/regpar/regpar6form_bloc.dart';
import '../../../../blocs/regpar/regpar_upload_foto_object_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../models/regpar/regpar6cari_model.dart';


class RegparForm5Section extends StatefulWidget {
  final String viewMode;
  final String? recordId;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regpar1Id;

  const RegparForm5Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.recordId,
    this.regpar1Id
  });

  @override
  State<RegparForm5Section> createState() => RegparForm5SectionState();
}

class RegparForm5SectionState extends State<RegparForm5Section> {
  final _regparform5key = GlobalKey<FormState>();
  final bool _showError = false;
  Completer<bool>? _validationCompleter;

  List<Uint8List> _images = [];
  List<String> _fileNames = [];
  late final Regpar6CariBloc  regpar6CariBloc;
  List<Regpar6CariModel> _serverPhotos = [];

  @override
  void initState() {
    super.initState();
    regpar6CariBloc = context.read<Regpar6CariBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<Regpar6CariBloc, Regpar6CariState>(
      listener: (context, state) {
        if (state.status == ListStatus.success) {
          setState(() {
            _serverPhotos = List.from(state.items);
          });


          final hasServer = _serverPhotos.isNotEmpty;
          final hasLocal = _images.isNotEmpty;

          if (_validationCompleter != null && !_validationCompleter!.isCompleted) {
            if (hasServer || hasLocal) {
              _validationCompleter!.complete(true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Harap unggah minimal 1 foto Bangunan."),
                  backgroundColor: Colors.red,
                ),
              );
              _validationCompleter!.complete(false);
            }
          }
        }
      },
      child: BlocBuilder<RegparUploadFotoObjectBloc, RegparUploadFotoObjectState>(
        builder: (context, state) {
          if (state is UploadFotoObjectListPreview) {
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
    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      debugPrint("🔥 Form5 dibuka parent → trigger lihat event ${widget.regpar1Id}");
      regpar6CariBloc.add(RefreshRegpar6CariEvent(regpar1Id: widget.regpar1Id!));
    }
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Foto Bangunan", style: bodyTextStyle(context)),
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
    _validationCompleter = Completer<bool>();

    if (widget.viewMode == "ubah" && widget.regpar1Id != null) {
      regpar6CariBloc.add(
        RefreshRegpar6CariEvent(regpar1Id: widget.regpar1Id!),
      );
    }

    final result = await _validationCompleter!.future;

    return result;
  }

  Widget _uploadInstructionBox() {
    final blocState = context.watch<RegparUploadFotoObjectBloc>().state;

    List<Uint8List> previewImages = [];
    List<String> previewNames = [];

    if (blocState is UploadFotoObjectListPreview) {
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
              final url = "${AppData.apiDomain}api/regpar/regpar6cari/fotoobject/getfoto/${item.regpar6Id}";

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
                      debugPrint("❌ Error load foto Rpar5: $error");
                      return const Icon(Icons.broken_image, color: Colors.red, size: 48);
                    },
                  ),
                ),
                onDelete: () => _deleteServerPhoto(item.regpar6Id),
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

    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectSelectedList(List.from(_images), List.from(_fileNames)),
    );

    setState(() {});
  }

  void _deleteServerPhoto(String regpar6Id) {
    debugPrint("🗑 delete server photo $regpar6Id");

    setState(() {
      _serverPhotos.removeWhere((x) => x.regpar6Id == regpar6Id);
    });

    context.read<Regpar6FormBloc>().add(
      Regpar6FormHapusEvent(recordId: regpar6Id),
    );
  }


  Widget _buildIntro() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto Object",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto Object jelas, terang, dan tidak buram.",
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
        onPressed: hasImages ? () => saveForm5() : null,
        child: const SizedBox.shrink(),
      ),
    );
  }


  Future<void> _pickFromGallery(BuildContext context) async {
    final bloc = context.read<RegparUploadFotoObjectBloc>();
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
      UploadFotoObjectSelectedList(
        List.from(_images),
        List.from(_fileNames),
      ),
    );
  }

  Future<void> _pickFromCamera(BuildContext context) async {
    final bloc = context.read<RegparUploadFotoObjectBloc>();

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

      bloc.add(UploadFotoObjectSelectedList(List.from(_images), List.from(_fileNames)));
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


  Future<bool> saveForm5() async {
    final hasLocalPhotos = _images.isNotEmpty;
    final hasServerPhotos = _serverPhotos.isNotEmpty;

    debugPrint("=== VALIDASI SAVE FORM 5 ===");
    debugPrint("Local Photos   : ${_images.length}");
    debugPrint("Server Photos  : ${_serverPhotos.length}");
    debugPrint("Valid? (ada salah satu): ${hasLocalPhotos || hasServerPhotos}");
    debugPrint("====================================");

    // ❌ kalau dua-duanya kosong → TIDAK VALID
    if (!hasLocalPhotos && !hasServerPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Harap unggah minimal 1 foto Object."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // 🟩 kalau valid → upload hanya foto baru (local photos)
    context.read<RegparUploadFotoObjectBloc>().add(
      UploadFotoObjectBatchSubmit(
        regpar1Id: widget.regpar1Id ?? "",
        images: List.from(_images),
        names: List.from(_fileNames),
      ),
    );

    return true;
  }

}