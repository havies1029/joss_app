import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/gen_regmv/regmv4cari_bloc.dart';
import '../../../../blocs/gen_regmv/regmv4form_bloc.dart';
import '../../../../blocs/gen_regmv/regmv_upload_stnk_bloc.dart';
import '../../../../common/app_data.dart';
import '../../../../models/gen_regmv/regmv4cari_model.dart';

class RegmvForm4Section extends StatefulWidget {
  final String viewMode;
  final bool isExpanded;
  final Function(bool) onToggle;
  final String? regmv1Id;

  const RegmvForm4Section({
    super.key,
    required this.viewMode,
    required this.isExpanded,
    required this.onToggle,
    this.regmv1Id,
  });

  @override
  State<RegmvForm4Section> createState() => RegmvForm4SectionState();
}

class RegmvForm4SectionState extends State<RegmvForm4Section> {
  List<Uint8List> _imagesRegmv4 = [];
  List<String> _fileNamesRegmv4 = [];

  List<Regmv4CariModel> _serverPhotosRegmv4 = [];

  final Set<String> _deletingServerIdsRegmv4 = {};

  late final Regmv4CariBloc regmv4CariBloc;

  @override
  void initState() {
    super.initState();
    regmv4CariBloc = context.read<Regmv4CariBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // server list update
        BlocListener<Regmv4CariBloc, Regmv4CariState>(
          listener: (context, state) {
            if (state.status == ListStatus.success) {
              setState(() => _serverPhotosRegmv4 = List.from(state.items));
            }
          },
        ),

        // upload flow
        BlocListener<RegmvUploadStnkBloc, RegmvUploadStnkState>(
          listener: (context, state) {
            if (state is UploadStnkListPreview) {
              // cache untuk submit/delete preview
              setState(() {
                _imagesRegmv4 = List.from(state.images);
                _fileNamesRegmv4 = List.from(state.fileNames);
              });
            }

            if (state is UploadStnkSuccess) {
              _refreshServerPhotos();
            }

            if (state is UploadStnkFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),

        // delete server (state hanya flag)
        BlocListener<Regmv4FormBloc, Regmv4FormState>(
          listener: (context, state) {
            // kalau ada aksi hapus berhasil → clear pending + refresh
            if (state.isSaved) {
              _deletingServerIdsRegmv4.clear();
              _refreshServerPhotos();
            }

            // kalau gagal → clear pending + refresh (rollback by refresh)
            if (state.hasFailure) {
              _deletingServerIdsRegmv4.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Gagal menghapus foto. Mengambil ulang data..."),
                  backgroundColor: Colors.red,
                ),
              );
              _refreshServerPhotos();
            }
          },
        ),
      ],
      child: Card(
        color: pGrey,
        child: Column(
          children: [
            _buildHeader(),
            if (widget.isExpanded) _buildBody(),
          ],
        ),
      ),
    );
  }

  void _refreshServerPhotos() {
    final id = widget.regmv1Id;
    if (id == null || id.isEmpty) return;
    regmv4CariBloc.add(RefreshRegmv4CariEvent(regmv1Id: id));
  }

  Widget _buildHeader() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      title: Text("Foto STNK", style: bodyTextStyle(context)),
      trailing: AnimatedRotation(
        turns: widget.isExpanded ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: SvgPicture.asset("assets/icons/dropdown.svg", width: 16),
      ),
      onTap: () => widget.onToggle(!widget.isExpanded),
    );
  }

  Widget _buildBody() {
    final uploadState = context.watch<RegmvUploadStnkBloc>().state;

    final bool hasPreview =
        uploadState is UploadStnkListPreview && uploadState.images.isNotEmpty;
    final bool hasServer = _serverPhotosRegmv4.isNotEmpty;

    final bool showIntro = !hasPreview && !hasServer;
    final bool isUploading = uploadState is UploadStnkLoading;

    return Padding(
      padding: const EdgeInsets.only(
        left: hPadding,
        right: hPadding,
        bottom: hPadding,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: sGrey),
          color: formGrey,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIntro) _buildIntro(),
            if (!showIntro) _buildGallery(uploadState: uploadState),
            const SizedBox(height: hPadding),
            _buildPickButtons(disabled: isUploading, previewCount: _imagesRegmv4.length),
            const SizedBox(height: 10),
            _buildUploadButton(disabled: isUploading),
            if (isUploading) ...[
              const SizedBox(height: 12),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Column(
      children: [
        Icon(Icons.upload, size: 40, color: primaryLightColor),
        const SizedBox(height: 14),
        Text(
          "Unggah Foto STNK",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryLightColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Pastikan foto STNK jelas, terang, dan tidak buram.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: cardGrey),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGallery({required RegmvUploadStnkState uploadState}) {
    final hasPreview =
        uploadState is UploadStnkListPreview && uploadState.images.isNotEmpty;

    if (hasPreview && uploadState is UploadStnkListPreview) {
      final images = uploadState.images;

      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) {
            return _photoTile(
              child: Image.memory(images[index], fit: BoxFit.cover),
              onDelete: () => _deletePreview(index),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _serverPhotosRegmv4.length,
        itemBuilder: (context, index) {
          final item = _serverPhotosRegmv4[index];
          final url =
              "${AppData.apiDomain}api/regmv/regmv4cari/stnk/getfoto/${item.regmv4Id}";

          final isDeleting = _deletingServerIdsRegmv4.contains(item.regmv4Id);

          return _photoTile(
            child: Image.network(
              url,
              headers: {"Authorization": "Bearer ${AppData.userToken}"},
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) =>
              progress == null ? child : const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, err, st) =>
              const Icon(Icons.broken_image, color: Colors.red, size: 48),
            ),
            onDelete: isDeleting ? null : () => _deleteServerPhoto(item),
          );
        },
      ),
    );
  }

  Widget _photoTile({required Widget child, VoidCallback? onDelete}) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          width: 200,
          height: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: child,
          ),
        ),
        if (onDelete != null)
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPickButtons({required bool disabled, required int previewCount}) {
    return Row(
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
            onPressed: disabled
                ? null
                : previewCount >= 10
                ? _maxReached
                : _pickFromGallery,
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
            onPressed: disabled
                ? null
                : previewCount >= 10
                ? _maxReached
                : _pickFromCamera,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadButton({required bool disabled}) {
    final canUpload = !disabled &&
        widget.regmv1Id != null &&
        widget.regmv1Id!.isNotEmpty &&
        _imagesRegmv4.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canUpload ? _onUploadPressed : null,
        child: const Text("Upload"),
      ),
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

  void _deletePreview(int index) {
    _imagesRegmv4.removeAt(index);
    _fileNamesRegmv4.removeAt(index);

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(List.from(_imagesRegmv4), List.from(_fileNamesRegmv4)),
    );
  }

  void _deleteServerPhoto(Regmv4CariModel item) {
    final id = item.regmv4Id;

    // mark deleting
    _deletingServerIdsRegmv4.add(id);

    // optimistic remove
    setState(() {
      _serverPhotosRegmv4.removeWhere((x) => x.regmv4Id == id);
    });

    // hit api hapus
    context.read<Regmv4FormBloc>().add(
      Regmv4FormHapusEvent(recordId: id),
    );
  }

  Future<void> _pickFromGallery() async {
    if (_imagesRegmv4.length >= 10) {
      _maxReached();
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result == null) return;

    for (final file in result.files) {
      if (_imagesRegmv4.length >= 10) break;
      if (file.bytes == null) continue;
      _imagesRegmv4.add(file.bytes!);
      _fileNamesRegmv4.add(file.name);
    }

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(List.from(_imagesRegmv4), List.from(_fileNamesRegmv4)),
    );
  }

  Future<void> _pickFromCamera() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kamera tidak tersedia di web")),
      );
      return;
    }

    if (_imagesRegmv4.length >= 10) {
      _maxReached();
      return;
    }

    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    _imagesRegmv4.add(bytes);
    _fileNamesRegmv4.add(picked.name);

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkSelectedList(List.from(_imagesRegmv4), List.from(_fileNamesRegmv4)),
    );
  }

  void _onUploadPressed() {
    final id = widget.regmv1Id;
    if (id == null || id.isEmpty) return;

    context.read<RegmvUploadStnkBloc>().add(
      UploadStnkBatchSubmit(
        regmv1Id: id,
        images: List.from(_imagesRegmv4),
        names: List.from(_fileNamesRegmv4),
      ),
    );
  }
}
