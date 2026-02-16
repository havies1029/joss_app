import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/constants.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
    final displayName = fileName ?? _inferName(localPath, fileUrl) ?? 'Belum ada file';
    final displaySize = fileSizeBytes != null ? _formatBytes(fileSizeBytes!) : null;

    return InkWell(
      onTap: onPreview,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: formGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== thumbnail kiri =====
            _Thumb(
              localPath: localPath,
              fileUrl: fileUrl,
              isImage: isImage,
              isPdf: isPdf,
            ),
            const SizedBox(width: 8),

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
                          jenisNama,
                          style: headingStyle(context, fontSize: 16)
                        ),
                      ),
                      if (hasFile)
                        Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xFF34C759),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/checklist2.svg",
                            width: 13,
                            height: 13,
                            colorFilter: const ColorFilter.mode(
                              primaryLightColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyTextStyle(context, fontSize: 14).copyWith(color: cardGrey),
                  ),
                  if (displaySize != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Ukuran: $displaySize',
                      style: bodyTextStyle(context, fontSize: 14).copyWith(color: cardGrey),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: AppButton.iconLeft(
                          text: 'Ambil Fie',
                          icon: SvgPicture.asset(
                            "assets/icons/btn_lapor_klaim.svg",
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          backgroundColor: sGrey,
                          textStyle: headingStyle(context, fontSize: 14),
                          padding: const EdgeInsets.all(10),
                          onPressed: onPickFile,
                        ),
                      ),
                      const SizedBox(width: 6),

                      // kalau sudah ada file: tampilkan Hapus (merah)
                      // kalau belum ada file: tampilkan Ambil Foto (oranye)
                      Expanded(
                        child: hasFile
                            ? AppButton.iconLeft(
                          text: 'Hapus',
                          icon: SvgPicture.asset(
                            "assets/icons/btn_delete.svg",
                            width: 14,
                            height: 14,
                          ),
                          backgroundColor: const Color(0xFFFF383C),
                          textStyle: headingStyle(context, fontSize: 14),
                          padding: const EdgeInsets.all(10),
                          onPressed: onDelete,
                        )
                            : AppButton.iconLeft(
                          text: 'Ambil Foto',
                          icon: SvgPicture.asset(
                            "assets/icons/camera icon.svg",
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          backgroundColor: primaryColor,
                          textStyle: headingStyle(context, fontSize: 14),
                          padding: const EdgeInsets.all(10),
                          onPressed: onPickPhoto,
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
    Widget child;

    final hasLocal = localPath != null && localPath!.isNotEmpty;
    final hasUrl = fileUrl != null && fileUrl!.isNotEmpty;

    if (isImage && hasLocal) {
      child = Image.file(File(localPath!), fit: BoxFit.cover);
    } else if (isPdf && hasLocal) {
      child = _PdfThumbImage(path: localPath!, width: 90, height: 90);
    } else if (isImage && hasUrl) {
      child = Image.network(
        fileUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _FileIconPlaceholder(isPdf: isPdf, isImage: isImage),
        loadingBuilder: (ctx, wdg, progress) {
          if (progress == null) return wdg;
          return const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)));
        },
      );
    } else {
      // PDF dari URL: kalau belum download -> minimal tampil icon PDF
      child = _FileIconPlaceholder(isPdf: isPdf, isImage: isImage);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: pGrey,
          border: Border.all(color: sGrey),
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
      color: pGrey,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 26),
          const SizedBox(height: 4),
          Text(label, style: bodyTextStyle(context, fontSize: 14)),
        ],
      ),
    );
  }
}

class _DocButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color fg;
  final VoidCallback? onTap;

  const _DocButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: fg, size: 18),
        label: Text(
          label,
          style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          disabledBackgroundColor: bg,
          disabledForegroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFF101010),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.picture_as_pdf_outlined, color: Colors.white70, size: 26),
          SizedBox(height: 4),
          Text(
            "PDF",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
