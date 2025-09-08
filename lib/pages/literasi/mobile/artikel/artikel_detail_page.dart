import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../blocs/gen_berita/berita2cari_bloc.dart';
import '../../../../blocs/gen_berita/berita3cari_bloc.dart';
import '../../../../blocs/local_prefs/article_selection_cubit.dart';

class ArtikelDetailPage extends StatefulWidget {
  const ArtikelDetailPage({super.key});

  @override
  State<ArtikelDetailPage> createState() => _ArtikelDetailPageState();
}

class _ArtikelDetailPageState extends State<ArtikelDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String sectionId) {
    final key = _sectionKeys[sectionId];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }
  }

  Widget _buildDetailHeader(String title, {String? imageUrl}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar di atas judul
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: const Icon(Icons.article_rounded, color: Colors.grey, size: 48),
                ),
              ),
            )
          else
          // Fallback: icon kalau gambar kosong/null
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.article_rounded, color: Colors.grey, size: 48),
            ),
          const SizedBox(height: 16),
          // Judul artikel
          Text(
            title,
            style: bodyTextStyle(context).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTOCSection(List items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt_rounded, color: Colors.teal, size: 20),
              const SizedBox(width: 12),
              Text(
                'Daftar Isi',
                style: bodyTextStyle(context).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  'Daftar isi tidak tersedia',
                  style: bodyTextStyle(context).copyWith(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            )
          else
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final toc = entry.value;
              final sectionId = 'section_${index}';

              return InkWell(
                onTap: () => _scrollToSection(sectionId),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.teal,
                        child: Text(
                          '${index + 1}',
                          style: bodyTextStyle(context).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          toc.subjudul ?? '-',
                          style: bodyTextStyle(context).copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right_rounded, color: Colors.teal[600], size: 20),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildUnifiedContentSection(List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.description_rounded, color: Colors.purple, size: 20),
            const SizedBox(width: 12),
            Text(
              'Konten Artikel',
              style: bodyTextStyle(context).copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (items.isEmpty)
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Konten tidak tersedia',
                style: bodyTextStyle(context).copyWith(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          )
        else
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            final sectionId = 'section_${index}';
            _sectionKeys[sectionId] = GlobalKey();

            return Container(
              key: _sectionKeys[sectionId],
              margin: const EdgeInsets.only(bottom: 24),
              child: (section.paragraf ?? '').isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  section.paragraf ?? '',
                  style: bodyTextStyle(context).copyWith(
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
                  : const SizedBox.shrink(),
            );
          }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedArticle = context.watch<ArticleSelectionCubit>().state;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: primaryLightColor,
              size: 20,
            ),
          ),
        ),
        title: Text(
          'Detail Artikel',
          style: bodyTextStyle(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Tutup",
            icon: const Icon(Icons.close_rounded, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailHeader(
              selectedArticle.judulArtikel ?? 'Judul Artikel',
              imageUrl: selectedArticle.gambarArtikel,
            ),

            BlocBuilder<Berita2CariBloc, Berita2CariState>(
              builder: (context, tocState) {
                return _buildTOCSection(tocState.items);
              },
            ),

            BlocBuilder<Berita3CariBloc, Berita3CariState>(
              builder: (context, contentState) {
                return _buildUnifiedContentSection(contentState.items);
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
