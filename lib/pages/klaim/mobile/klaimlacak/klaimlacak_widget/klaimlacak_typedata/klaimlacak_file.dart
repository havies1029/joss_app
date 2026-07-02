import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class KlaimLacakFile extends StatelessWidget {
  final String fileUrl;
  final String? fileName;
  final VoidCallback? onTap;

  const KlaimLacakFile({
    super.key,
    required this.fileUrl,
    this.fileName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = (fileName ?? '').trim().isEmpty
        ? fileUrl.split('/').last
        : fileName!.trim();

    final safeDisplayName =
    displayName.isEmpty ? 'Lihat File Lampiran' : displayName;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: sGrey),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.insert_drive_file_outlined,
                  color: primaryLightColor,
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                safeDisplayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: bodyTextStyle(context, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}