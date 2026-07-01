import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/common/loading_indicator.dart';

Widget sectionTitleBar(BuildContext context, String text) {
  return Container(
    margin: const EdgeInsets.all(15),
    width: 108,
    height: 25,
    padding: EdgeInsets.only(left: 3),
    decoration: BoxDecoration(
      color: const Color(0x80EF7A28),
      border: const Border(left: BorderSide(color: primaryColor, width: 1.7)),
    ),
    alignment: Alignment.centerLeft,
    child: Text(text, style: bodyTextStyle(context)),
  );
}

class ArticleCardWidget extends StatelessWidget {
  final String judul;
  final VoidCallback onTap;
  final String? subjudul;
  final String? imageUrl;
  final String? tglTerbit;
  final String? lamaBaca;
  final bool isImageOnLeft;

  const ArticleCardWidget._({
    super.key,
    required this.judul,
    required this.onTap,
    required this.isImageOnLeft,
    this.subjudul,
    this.imageUrl,
    this.tglTerbit,
    this.lamaBaca,
  });

  factory ArticleCardWidget.bigNews({
    Key? key,
    required String judul,
    required VoidCallback onTap,
    String? subjudul,
    String? imageUrl,
    String? tglTerbit,
    String? lamaBaca,
  }) {
    return ArticleCardWidget._(
      key: key,
      judul: judul,
      onTap: onTap,
      isImageOnLeft: false,
      subjudul: subjudul,
      imageUrl: imageUrl,
      tglTerbit: tglTerbit,
      lamaBaca: lamaBaca,
    );
  }

  factory ArticleCardWidget.otherArticle({
    Key? key,
    required String judul,
    required VoidCallback onTap,
    String? subjudul,
    String? imageUrl,
    String? tglTerbit,
    String? lamaBaca,
  }) {
    return ArticleCardWidget._(
      key: key,
      judul: judul,
      onTap: onTap,
      isImageOnLeft: true,
      subjudul: subjudul,
      imageUrl: imageUrl,
      tglTerbit: tglTerbit,
      lamaBaca: lamaBaca,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: secondaryBlackColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: pGrey, width: 0.5),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Row(
            children:
                isImageOnLeft
                    ? _buildImageLeftLayout(context)
                    : _buildImageRightLayout(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildImageLeftLayout(BuildContext context) {
    return [
      _buildImageWidget(),
      const SizedBox(width: 16),
      Expanded(child: _buildContentWidget(context)),
    ];
  }

  List<Widget> _buildImageRightLayout(BuildContext context) {
    return [
      Expanded(child: _buildContentWidget(context)),
      const SizedBox(width: 16),
      _buildImageWidget(),
    ];
  }

  Widget _buildImageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: (imageUrl != null && imageUrl!.isNotEmpty)
          ? CachedNetworkImage(
        imageUrl: imageUrl!,
        width: 160,
        height: 113,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          return Container(
            width: 160,
            height: 113,
            color: secondaryBlackColor,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 22,
              height: 22,
              child: LoadingIndicator(),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            width: 160,
            height: 113,
            color: sGrey,
            alignment: Alignment.center,
            child: const Icon(Icons.image, color: sGrey, size: 32),
          );
        },
      )
          : Container(
        width: 160,
        height: 113,
        color: sGrey,
        alignment: Alignment.center,
        child: const Icon(Icons.image, color: sGrey, size: 32),
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          judul,
          style: bodyTextStyle(context),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (subjudul != null && subjudul!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            subjudul!,
            style: bodyTextStyle(
              context,
              fontSize: 14,
            ).copyWith(color: hintGrey),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            if (tglTerbit != null && tglTerbit!.isNotEmpty) ...[
              Text(
                tglTerbit!,
                style: bodyTextStyle(
                  context,
                  fontSize: 14,
                ).copyWith(color: hintGrey),
              ),
            ],
            if (tglTerbit != null &&
                tglTerbit!.isNotEmpty &&
                lamaBaca != null &&
                lamaBaca!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                '•',
                style: bodyTextStyle(
                  context,
                  fontSize: 14,
                ).copyWith(color: hintGrey, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
            ],
            if (lamaBaca != null && lamaBaca!.isNotEmpty) ...[
              Text(
                lamaBaca!,
                style: bodyTextStyle(
                  context,
                  fontSize: 14,
                ).copyWith(color: hintGrey),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
