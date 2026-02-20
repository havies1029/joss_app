import 'package:flutter/material.dart';

class KlaimProgressPlaceholderRow extends StatelessWidget {
  final String title;
  final Color baseText;

  const KlaimProgressPlaceholderRow({
    super.key,
    required this.title,
    required this.baseText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: baseText.withOpacity(0.45),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
