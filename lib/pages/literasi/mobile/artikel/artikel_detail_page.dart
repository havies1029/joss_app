import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/loading_indicator.dart';
import '../../../../blocs/gen_berita/berita3cari_bloc.dart';
import '../../../../blocs/local_prefs/article_selection_cubit.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/klien_jps_widget.dart';

import '../../../../blocs/logoclient/mlogoclientcari_bloc.dart';

class ArtikelDetailPage extends StatelessWidget {
  final String authorNama;
  final String tglTerbit;

  const ArtikelDetailPage({
    super.key,
    required this.authorNama,
    required this.tglTerbit,
  });

  @override
  Widget build(BuildContext context) {
    final selectedArticle = context.watch<ArticleSelectionCubit>().state;
    final isMobile = MediaQuery.of(context).size.width < 500;
    return Scaffold(
      backgroundColor: secondaryBlackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5,vertical: vPadding),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Material(
              color: pGrey,
              borderRadius: BorderRadius.circular(6.67),
              child: InkWell(
                borderRadius: BorderRadius.circular(6.67),
                onTap: () => Navigator.pop(context),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/arrow_back.svg',
                      colorFilter: ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: hPadding * 1.5), // 👈 ini aja
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedArticle.judulArtikel ?? '-',
              style: bodyTextStyle(context, fontSize: 22),
            ),
            const SizedBox(height: vPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(authorNama, style: bodyTextStyle(context)),
                    const SizedBox(height: 3),
                    Text(
                      tglTerbit,
                      style: bodyTextStyle(context).copyWith(color: hintGrey),
                    ),
                  ],
                ),
                const Spacer(),

                BlocBuilder<MlogoclientCariBloc, MlogoclientCariState>(
                  builder: (context, state) {
                    if (state.items.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    final items = state.items
                        .where((e) => e.isActive)
                        .toList()
                      ..sort((a, b) => a.noUrut.compareTo(b.noUrut));

                    return Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 12,
                      children: items.map((item) {
                        return SocmedIcon(
                          'assets/icons/${item.logoSvg}',
                          isMobile,
                          url: item.linkUrl,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: vPadding),

            if (selectedArticle.gambarArtikel != null &&
                selectedArticle.gambarArtikel!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  imageUrl: selectedArticle.gambarArtikel!,
                  height: 187,
                  width: double.infinity,
                  fit: BoxFit.cover,

                  placeholder: (context, url) {
                    return Container(
                      height: 187,
                      width: double.infinity,
                      color: secondaryBlackColor,
                      alignment: Alignment.center,
                      child: const SizedBox(
                        width: 26,
                        height: 26,
                        child: LoadingIndicator(),
                      ),
                    );
                  },

                  errorWidget: (context, url, error) {
                    return Container(
                      height: 187,
                      width: double.infinity,
                      color: sGrey,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 36,
                        color: sGrey,
                      ),
                    );
                  },
                ),
              ),

            if (selectedArticle.gambarArtikel != null &&
                selectedArticle.gambarArtikel!.isNotEmpty)
              const SizedBox(height: 18),
            BlocBuilder<Berita3CariBloc, Berita3CariState>(
              builder: (context, contentState) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildContent(context, contentState),
                );
              },
            ),
            const SizedBox(height: vPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Berita3CariState contentState) {

    if (contentState.status == ListStatus.initial) {
      return const Padding(
        key: ValueKey("loading"),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: LoadingIndicator(),
        ),
      );
    }

    if (contentState.status == ListStatus.failure) {
      return const Padding(
        key: ValueKey("error"),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text("Gagal memuat artikel"),
        ),
      );
    }

    return Column(
      key: const ValueKey("content"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contentState.items.map<Widget>((section) {
        if ((section.paragraf ?? '').trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            section.paragraf ?? '',
            style: bodyTextStyle(context),
            textAlign: TextAlign.justify,
          ),
        );
      }).toList(),
    );
  }
}
