import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/app_data.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class Klaim5cariTileWidget extends StatelessWidget {
  final String mjenisdocId;
  final String jenisDocLain;
  final String jenisNama;
  final String klaim5Id;

  // ===== file info (optional) =====
  final String? localPath;     // path file yg dipilih dari device
  final String? fileUrl;       // url dari server (kalau sudah upload)
  final String? fileName;      // nama file
  final int? fileSizeBytes;    // ukuran (bytes)
  final String? mime;          // "image/jpeg", "application/pdf", ...

  // ===== actions =====
  final VoidCallback? onPickFile;
  final VoidCallback? onPickPhoto;
  final VoidCallback? onDelete;
  final VoidCallback? onPreview; // tap ke thumbnail / card

  const Klaim5cariTileWidget({
    super.key,
    required this.mjenisdocId,
    required this.jenisDocLain,
    required this.jenisNama,
    required this.klaim5Id,
    this.localPath,
    this.fileUrl,
    this.fileName,
    this.fileSizeBytes,
    this.mime,
    this.onPickFile,
    this.onPickPhoto,
    this.onDelete,
    this.onPreview,
  });

  bool get hasFile => (localPath != null && localPath!.isNotEmpty) || (fileUrl != null && fileUrl!.isNotEmpty);

  bool get isImage {
    final m = (mime ?? '').toLowerCase();
    if (m.startsWith('image/')) return true;
    final p = (localPath ?? fileUrl ?? '').toLowerCase();
    return p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.png') || p.endsWith('.webp');
  }

  bool get isPdf {
    final m = (mime ?? '').toLowerCase();
    if (m.contains('pdf')) return true;
    final p = (localPath ?? fileUrl ?? '').toLowerCase();
    return p.endsWith('.pdf');
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = const Color(0xFF2F2F2F);
    final border = Colors.white.withOpacity(0.12);

    final displayName = fileName ?? _inferName(localPath, fileUrl) ?? 'Belum ada file';
    final displaySize = fileSizeBytes != null ? _formatBytes(fileSizeBytes!) : null;

    return InkWell(
      onTap: onPreview,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== thumbnail kiri =====
            _Thumb(
              localPath: localPath,
              fileUrl: fileUrl,
              isImage: isImage,
              isPdf: isPdf,
            ),
            const SizedBox(width: 12),

            // ===== kanan: info + buttons =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title row + (opsional) status check
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jenisNama.isNotEmpty ? jenisNama : jenisDocLain,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      if (hasFile)
                        Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, size: 13, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
                  ),
                  if (displaySize != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Ukuran: $displaySize',
                      style: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 11.5),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _DocButton(
                          label: hasFile
                            ? 'Ganti File'
                            : 'Ambil File',
                          icon: SvgPicture.asset(
                            "assets/icons/photo_img.svg",
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          bg: const Color(0xFF4A4A4A),
                          fg: Colors.white,
                          onTap: onPickFile,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: hasFile
                            ? _DocButton(
                                label: 'Hapus',
                                icon: SvgPicture.asset(
                                  "assets/icons/gallery_img.svg",
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                bg: const Color(0xFFEF4444),
                                fg: Colors.white,
                                onTap: onDelete,
                              )
                            : _DocButton(
                                label: 'Ambil Foto',
                                icon: SvgPicture.asset(
                                  "assets/icons/photo_img.svg",
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                bg: const Color(0xFFF28C28),
                                fg: Colors.white,
                                onTap: onPickPhoto,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String? _inferName(String? localPath, String? fileUrl) {
    final s = localPath ?? fileUrl;
    if (s == null || s.isEmpty) return null;
    final i = s.lastIndexOf('/');
    if (i >= 0 && i < s.length - 1) return s.substring(i + 1);
    return s;
  }

  static String _formatBytes(int bytes) {
    const kb = 1024;
    const mb = 1024 * 1024;
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(1)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(0)} KB';
    return '$bytes B';
  }
}

class _Thumb extends StatelessWidget {
  final String? localPath;
  final String? fileUrl;
  final bool isImage;
  final bool isPdf;

  const _Thumb({
    required this.localPath,
    required this.fileUrl,
    required this.isImage,
    required this.isPdf,
  });

  @override
  Widget build(BuildContext context) {
    const w = 86.0;
    const h = 68.0;
    final bg = const Color(0xFF1F1F1F);
    final border = Colors.white.withOpacity(0.10);

    Widget child;

    final hasLocal = localPath != null && localPath!.isNotEmpty;
    final hasUrl = fileUrl != null && fileUrl!.isNotEmpty;
    if (isImage && hasLocal) {
      child = Image.file(File(localPath!), fit: BoxFit.cover);
    } else if (isPdf && hasLocal) {
      child = _PdfThumbImage(path: localPath!, width: w, height: h);
    } else if (isImage && hasUrl) {
      child = Image(
        image: NetworkImage(
          fileUrl!,
          headers: {
            'Authorization': 'Bearer ${AppData.userToken}',
          },
        ),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _FileIconPlaceholder(isPdf: isPdf, isImage: isImage),
        loadingBuilder: (ctx, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      );
    } else {
      // PDF dari URL: kalau belum download -> minimal tampil icon PDF
      child = _FileIconPlaceholder(isPdf: isPdf, isImage: isImage);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
        ),
        child: child,
      ),
    );
  }
}

class _FileIconPlaceholder extends StatelessWidget {
  final bool isPdf;
  final bool isImage;
  const _FileIconPlaceholder({required this.isPdf, required this.isImage});

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.insert_drive_file_outlined;
    String label = 'FILE';
    if (isPdf) {
      icon = Icons.picture_as_pdf_outlined;
      label = 'PDF';
    } else if (isImage) {
      icon = Icons.image_outlined;
      label = 'IMG';
    }

    return Container(
      color: const Color(0xFF101010),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _DocButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;

  const _DocButton({
    required this.label,
    this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  bool _isOverflow(String text, double maxWidth, TextStyle style) {
    final safeWidth = maxWidth.clamp(0.0, double.infinity);

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: safeWidth);

    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: fg,
      fontSize: 13,
      fontWeight: FontWeight.w800,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        const iconWidth = 18.0;
        const iconSpacing = 6.0;
        const horizontalPadding = 24.0;

        final iconSpace = icon != null
            ? iconWidth + iconSpacing + horizontalPadding
            : horizontalPadding;

        final textWidth =
        (maxWidth - iconSpace).clamp(0.0, double.infinity);

        final overflowWithIcon =
        _isOverflow(label, textWidth, textStyle);

        final showIcon =
            icon != null && !overflowWithIcon && maxWidth > iconSpace;

        return SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              disabledBackgroundColor: bg,
              disabledForegroundColor: fg,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showIcon) ...[
                  icon!,
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
              width: 16,
              height: 16,
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
