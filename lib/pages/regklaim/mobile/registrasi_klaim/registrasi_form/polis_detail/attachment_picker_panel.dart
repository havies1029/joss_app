import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

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

          // ===== buttons =====
          Row(
            children: [
              Expanded(
                child: _BigButton(
                  label: "Ambil File",
                  icon: Icons.insert_drive_file_outlined,
                  bg: const Color(0xFF4A4A4A),
                  fg: Colors.white,
                  enabled: true,
                  onTap: onPickFile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BigButton(
                  label: "Ambil Foto",
                  icon: Icons.photo_camera_outlined,
                  bg: const Color(0xFFF28C28),
                  fg: Colors.white,
                  enabled: true,
                  onTap: onPickFile,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            SizedBox(
              width: 210,
              height: 136,
              child: _content(),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: InkWell(
                onTap: widget.onRemove,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.25)),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),

            // optional overlay status upload kecil
            // Positioned(bottom: 10, right: 10, child: _StatusChip(item: widget.item)),
          ],
        ),
      ),
    );
  }

  Widget _content() {
    if (widget.item.isImage) {
      return Image.file(File(widget.item.path), fit: BoxFit.cover);
    }

    if (widget.item.isPdf) {
      return Container(
        color: const Color(0xFF101010),
        child: Stack(
          children: [
            _PdfThumbImage(
              path: widget.item.path,
              width: 210,
              height: 136,
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: const Text(
                  "PDF",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return _FilePlaceholder(name: widget.item.name);
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;
  final bool enabled;

  const _BigButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = enabled ? bg : bg.withOpacity(0.35);
    final effectiveFg = enabled ? fg : fg.withOpacity(0.55);

    return SizedBox(
      height: 72,
      child: ElevatedButton.icon(
        onPressed: enabled ? onTap : null, // <- null = disabled native
        icon: Icon(icon, color: effectiveFg, size: 30),
        label: Text(
          label,
          style: TextStyle(
            color: effectiveFg,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          disabledBackgroundColor: effectiveBg, // biar tetap sesuai opacity
          disabledForegroundColor: effectiveFg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
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
