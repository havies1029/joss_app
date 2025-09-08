import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import '../../../../blocs/gen_berita/berita1cari_bloc.dart';
import '../../../../blocs/gen_berita/beritakecilcari_bloc.dart';
import '../../../../blocs/gen_berita/beritalaincari_bloc.dart';
import '../../../../blocs/gen_berita/berita2cari_bloc.dart';
import '../../../../blocs/gen_berita/berita3cari_bloc.dart';
import '../../../../blocs/local_prefs/article_selection_cubit.dart';

import 'artikel_detail_page.dart';
import '../../widgets/artikel_card.dart';

class ArtikelListPage extends StatelessWidget {
  const ArtikelListPage({super.key});

  void _goToDetail(BuildContext context, dynamic artikel) {
    context.read<ArticleSelectionCubit>().selectArticle(
      berita1Id: artikel.berita1Id,
      gambarArtikel: artikel.gambar,
      judulArtikel: artikel.judul,
    );

    context.read<Berita2CariBloc>().add(
      RefreshBerita2CariEvent(berita1Id: artikel.berita1Id!),
    );
    context.read<Berita3CariBloc>().add(
      RefreshBerita3CariEvent(berita1Id: artikel.berita1Id!),
    );

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ArtikelDetailPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MAIN ARTICLES
          BlocBuilder<Berita1CariBloc, Berita1CariState>(
            builder: (context, state1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Cerita Besar'),
                  const SizedBox(height: 25),
                  ...state1.items.map(
                    (artikel) => ArticleCardWidget(
                      title: artikel.judul ?? '-',
                      onTap: () => _goToDetail(context, artikel),
                      accentColor: const Color(0xFF2E7D32),
                      icon: Icons.article_rounded,
                      imageUrl: artikel.gambar,
                      date:
                          artikel.tglTerbit?.toString().split(' ').first ?? "",
                    ),
                  ),
                ],
              );
            },
          ),

          // SIDE ARTICLES
          BlocBuilder<BeritaKecilCariBloc, BeritaKecilCariState>(
            builder: (context, state2) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Cerita Lainnya'),
                  const SizedBox(height: 25),
                  ...state2.items.map(
                    (artikel) => ArticleCardWidget(
                      title: artikel.judul ?? '-',
                      onTap: () => _goToDetail(context, artikel),
                      accentColor: const Color(0xFF2E7D32),
                      icon: Icons.article_rounded,
                      imageUrl: artikel.gambar, // <= ini penting!
                      date:
                          artikel.tglTerbit?.toString().split(' ').first ?? "",
                    ),
                  ),
                ],
              );
            },
          ),

          // SIDEBAR ARTICLES
          BlocBuilder<BeritaLainCariBloc, BeritaLainCariState>(
            builder: (context, state3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Artikel Lainnya'),
                  const SizedBox(height: 25),
                  ...state3.items.map(
                    (artikel) => ArticleCardWidget(
                      title: artikel.judul ?? '-',
                      onTap: () => _goToDetail(context, artikel),
                      accentColor: const Color(0xFF2E7D32),
                      icon: Icons.article_rounded,
                      imageUrl: artikel.gambar, // <= ini penting!
                      date:
                          artikel.tglTerbit?.toString().split(' ').first ?? "",
                    ),
                  ),
                ],
              );
            },
          ),

          // Footer spacing
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
