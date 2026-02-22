import 'package:flutter/material.dart';

class NotifeventcariTileWidget extends StatelessWidget {
  final String eventDesc;
  final String eventNama;
  final String notifeventId;

  const NotifeventcariTileWidget({
    super.key,
    required this.eventDesc,
    required this.eventNama,
    required this.notifeventId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 12,
      minLeadingWidth: 44,

      leading: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFF3A3A3A),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.notifications_none_rounded,
          color: Colors.white.withOpacity(0.92),
          size: 22,
        ),
      ),

      title: Text(
        eventNama,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),

      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          eventDesc,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 13,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}
