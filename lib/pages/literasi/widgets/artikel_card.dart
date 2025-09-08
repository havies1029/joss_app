import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

Widget sectionTitleBar(BuildContext context, String text) {
  return Container(
    margin: EdgeInsets.zero,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: const Color(0x80EF7A28),
      border: const Border(left: BorderSide(color: primaryColor, width: 1.7)),
    ),
    child: Text(text, style: bodyTextStyle(context)),
  );
}

class ArticleCardWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color accentColor;
  final IconData icon;
  final String? subtitle;
  final String? imageUrl;
  final String? date;
  final String? readTime;

  const ArticleCardWidget({
    super.key,
    required this.title,
    required this.onTap,
    required this.accentColor,
    required this.icon,
    this.subtitle,
    this.imageUrl,
    this.date = "Static Date",
    this.readTime = "5 min",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Gambar atau icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      (imageUrl != null && imageUrl!.isNotEmpty)
                          ? Image.network(
                            imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 80,
                                height: 80,
                                color: accentColor.withOpacity(0.13),
                                child: Icon(icon, color: accentColor, size: 32),
                              );
                            },
                          )
                          : Container(
                            width: 80,
                            height: 80,
                            color: accentColor.withOpacity(0.13),
                            child: Icon(icon, color: accentColor, size: 32),
                          ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: bodyTextStyle(context
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          subtitle!,
                          style: bodyTextStyle(context, fontSize: 14).copyWith(color: hintGrey),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            readTime ?? "5 min",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            date ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow indicator
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
