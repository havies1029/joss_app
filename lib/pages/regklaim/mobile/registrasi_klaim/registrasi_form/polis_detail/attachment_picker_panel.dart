import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pdfx/pdfx.dart';

import '../../../../../../common/constants.dart';
import '../../../../../../models/regklaim/attachment_item.dart';

class AttachmentPickerPanel extends StatelessWidget {
  final List<AttachmentItem> items;

  final VoidCallback onPickFile;
  final VoidCallback onPickPhoto;

  final void Function(String localId) onRemove;
  final void Function(AttachmentItem item) onTapItem;

  const AttachmentPickerPanel({
    super.key,
    required this.items,
    required this.onPickFile,
    required this.onPickPhoto,
    required this.onRemove,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== preview strip =====
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1F1F1F),
              borderRadius: BorderRadius.circular(14),
            ),
            child: items.isEmpty
                ? Center(
              child: Text(
                "Belum ada file",
                style: TextStyle(color: Colors.white.withOpacity(0.55)),
              ),
            )
                : ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
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
          const SizedBox(height: 14),

          // ===== buttons ===== ardi
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
}

class _ThumbCard extends StatefulWidget {
  final AttachmentItem item;
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
  static const double _w = 180; // lebih ramping
  static const double _h = 130;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2), // optional, boleh hapus
      child: Material(
        color: const Color(0xFF101010),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: _w,
            height: _h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.10)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // content
                  SizedBox(width: _w, height: _h, child: _content()),

                  // overlay gradient tipis biar text/chip kebaca kalau background terang
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

                  // tombol remove (lebih kecil & rapih)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: widget.onRemove,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.15)),
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ),

                  // kamu bisa taruh status chip kecil di kanan bawah kalau perlu
                  // Positioned(bottom: 10, right: 10, child: _StatusChip(item: widget.item)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    // LOGIC SAMA PERSIS seperti punyamu, cuma ganti width/height pdf thumb
    if (widget.item.isImage) {
      return Image.file(File(widget.item.path), fit: BoxFit.cover);
    }

    if (widget.item.isPdf) {
      return Stack(
        children: [
          _PdfThumbImage(
            path: widget.item.path,
            width: _w,
            height: _h,
          ),
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
      width: (width * 2).toDouble(),   // biar tajam
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
