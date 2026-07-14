import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class DialogDetailPolis extends StatelessWidget {
  final String title;
  final List<DetailItem> items;

  const DialogDetailPolis({
    super.key,
    this.title = "Detail",
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding * 1.5,
      ),
      backgroundColor: pGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: sGrey),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border.all(color: sGrey),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    title,
                    style: bodyTextStyle(context, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            // Content (scrollable)
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children:
                        items.map((item) => _buildDetailRow(item)).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(DetailItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  item.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.8,
          color: sGrey.withOpacity(0.6),
        ),
      ],
    );
  }

  // Static helper method untuk menampilkan dialog
  static void show(
    BuildContext context, {
    String title = "Detail",
    required List<DetailItem> items,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => DialogDetailPolis(
        title: title,
        items: items,
      ),
    );
  }
}

// Model untuk detail item
class DetailItem {
  final String label;
  final String value;

  DetailItem({
    required this.label,
    required this.value,
  });
}
