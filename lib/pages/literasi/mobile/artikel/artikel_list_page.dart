import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/gen_berita/berita1cari_bloc.dart';
import '../../../../blocs/gen_berita/beritakecilcari_bloc.dart';
import '../../../../blocs/gen_berita/beritalaincari_bloc.dart';
import '../../../../blocs/gen_berita/berita2cari_bloc.dart';
import '../../../../blocs/gen_berita/berita3cari_bloc.dart';
import '../../../../blocs/local_prefs/article_selection_cubit.dart';

import '../../../../common/constants.dart';
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ArtikelDetailPage(
          authorNama: artikel.authorNama ?? '',
          tglTerbit: artikel.tglTerbit != null
              ? formatTanggalCard(artikel.tglTerbit!)
              : "",
        ),
      ),
    );
  }

  String formatTanggalCard(DateTime dt) {
    const bulan = [
      '',
      'Jan','Feb','Mar','Apr','Mei','Jun',
      'Jul','Agu','Sep','Okt','Nov','Des'
    ];

    return "${dt.day} ${bulan[dt.month]}, ${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<Berita1CariBloc, Berita1CariState>(
            builder: (context, state1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Cerita Besar'),
                  kDivider(),
                  ...state1.items.map(
                        (artikel) => ArticleCardWidget.bigNews(
                      judul: artikel.judul ?? '-',
                      subjudul: artikel.sumber,
                      onTap: () => _goToDetail(context, artikel),
                      imageUrl: artikel.gambar,
                      lamaBaca:
                      (artikel.lamaBaca != null)
                          ? "${artikel.lamaBaca} min"
                          : null,
                          tglTerbit: formatTanggalCard(artikel.tglTerbit),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(height: 27, color: primaryBlackColor),
          // SIDE ARTICLES
          BlocBuilder<BeritaKecilCariBloc, BeritaKecilCariState>(
            builder: (context, state2) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Cerita Lainnya'),
                  kDivider(),
                  ...state2.items.map(
                        (artikel) => ArticleCardWidget.otherArticle(
                      judul: artikel.judul ?? '-',
                      subjudul: artikel.sumber,
                      onTap: () => _goToDetail(context, artikel),
                      imageUrl: artikel.gambar,
                      lamaBaca:
                      (artikel.lamaBaca != null)
                          ? "${artikel.lamaBaca} min"
                          : null,
                          tglTerbit: formatTanggalCard(artikel.tglTerbit),
                    ),
                  ),
                ],
              );
            },
          ),
          Container(height: 27, color: primaryBlackColor),
          // SIDEBAR ARTICLES
          BlocBuilder<BeritaLainCariBloc, BeritaLainCariState>(
            builder: (context, state3) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sectionTitleBar(context, 'Artikel Lainnya'),
                  kDivider(),
                  ...state3.items.map(
                        (artikel) => ArticleCardWidget.otherArticle(
                      judul: artikel.judul ?? '-',
                      subjudul: artikel.sumber,
                      onTap: () => _goToDetail(context, artikel),
                      imageUrl: artikel.gambar,
                      lamaBaca:
                      (artikel.lamaBaca != null)
                          ? "${artikel.lamaBaca} min"
                          : null,
                          tglTerbit: formatTanggalCard(artikel.tglTerbit),
                    ),
                  ),
                ],
              );
            },
          ),

          // Footer spacing
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
