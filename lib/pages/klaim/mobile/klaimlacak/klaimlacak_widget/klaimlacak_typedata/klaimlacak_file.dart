// klaimlacak_typedata/klaimlacak_file.dart

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

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: sGrey),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.insert_drive_file_outlined,
              color: primaryLightColor,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                displayName.isEmpty ? 'Lihat File Lampiran' : displayName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: bodyTextStyle(context, fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.open_in_new,
              color: hintGrey,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
