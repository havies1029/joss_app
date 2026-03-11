import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../../../common/constants.dart';
import '../../../../models/gen_regmv/regmv5upload_model.dart';

class Regmv5StoragePickerPanel extends StatelessWidget {
  final List<Regmv5UploadModel> items;

  final VoidCallback onPickFile;
  final VoidCallback onPickPhoto;

  final void Function(String localId) onRemove;
  final void Function(Regmv5UploadModel item) onTapItem;
  final bool isLoading;
  final bool showRequiredError;
  final String requiredErrorText;

  const Regmv5StoragePickerPanel({
    super.key,
    required this.items,
    required this.onPickFile,
    required this.onPickPhoto,
    required this.onRemove,
    required this.onTapItem,
    required this.isLoading,
    required this.showRequiredError,
    this.requiredErrorText = "Wajib diisi",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 160,
            child: isLoading
                ? const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
                : items.isEmpty
                ? _emptyState(context)
                : ListView.separated(
              scrollDirection: Axis.horizontal,
              // padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final item = items[i];
                return _ThumbCard(
                  item: item,
                  onRemove: () => onRemove(item.localId),
                  onTap: () => onTapItem(item),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          if (showRequiredError) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                requiredErrorText,
                style: const TextStyle(
                  color: pRed,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // ===== buttons =====
          Row(
            children: [
              Expanded(
                child: AppButton.iconLeft(
                  text: "Ambil File",
                  icon: SvgPicture.asset(
                    "assets/icons/gallery_img.svg",
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color(0xFF4A4A4A),
                  onPressed: onPickFile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton.iconLeft(
                  text: "Ambil Foto",
                  icon: SvgPicture.asset(
                    "assets/icons/photo_img.svg",
                    width: 18,
                    height: 18,
                    color: Colors.white,
                  ),
                  backgroundColor: const Color(0xFFF28C28),
                  onPressed: onPickPhoto,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/icons/upload_simbol.svg",
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 8),
          Text(
            "Unggah Foto Mobil",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getResponsiveFont(context, 16),
              fontWeight: FontWeight.w600,
              color: primaryLightColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Pastikan foto Mobil terlihat jelas dan tidak buram untuk memudahkan proses verifikasi.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getResponsiveFont(context, 14),
              color: cardGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThumbCard extends StatefulWidget {
  final Regmv5UploadModel item;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _ThumbCard({
    required this.item,
    required this.onRemove,
    required this.onTap,
  });

  @override
  State<_ThumbCard> createState() => _ThumbCardState();
}

class _ThumbCardState extends State<_ThumbCard> {
  static const double _size = 146;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        color: const Color(0xFF101010),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: _size,
                  height: _size,
                  child: _content(),
                ),

                // gradient tetap
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.18),
                          Colors.transparent,
                          Colors.black.withOpacity(0.18),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onRemove,
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: sGrey,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    if (widget.item.isImage) {
      return Image.file(File(widget.item.path), fit: BoxFit.cover);
    }

    if (widget.item.isPdf) {
      return Stack(
        children: [
          _PdfThumbImage(path: widget.item.path, width: _size, height: _size),
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: const Text(
                "PDF",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return _FilePlaceholder(name: widget.item.name);
  }
}

class _FilePlaceholder extends StatelessWidget {
  final String name;
  const _FilePlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF101010),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.insert_drive_file_outlined,
                color: Colors.white70, size: 44),
            const SizedBox(height: 10),
            Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _PdfThumbImage extends StatelessWidget {
  final String path;
  final double width;
  final double height;

  const _PdfThumbImage({
    required this.path,
    required this.width,
    required this.height,
  });

  Future<Uint8List?> _renderPage1() async {
    final doc = await PdfDocument.openFile(path);
    final page = await doc.getPage(1);

    final img = await page.render(
      width: (width * 2).toDouble(),
      height: (height * 2).toDouble(),
      format: PdfPageImageFormat.png,
    );

    await page.close();
    await doc.close();

    return img?.bytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _renderPage1(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFF101010),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        return Image.memory(
          snap.data!,
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      },
    );
  }
}