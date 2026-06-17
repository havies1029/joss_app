import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class KlaimPlaceholderWidget extends StatelessWidget {
  final String title;
  final Color baseText;

  const KlaimPlaceholderWidget({
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
            style: bodyTextStyle(context, fontSize: 14).copyWith(color: formGrey)
        ),
      ),
    );
  }
}
