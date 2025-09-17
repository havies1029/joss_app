import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../blocs/gen_berita/berita3cari_bloc.dart';
import '../../../../blocs/local_prefs/article_selection_cubit.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/widgets/klien_jps_widget.dart';

class ArtikelDetailPage extends StatelessWidget {
  const ArtikelDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedArticle = context.watch<ArticleSelectionCubit>().state;
    final isMobile = MediaQuery.of(context).size.width < 500;

    return Scaffold(
      backgroundColor: secondaryBlackColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Material(
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
                  colorFilter: ColorFilter.mode(primaryColor, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedArticle.judulArtikel ?? '-',
              style: bodyTextStyle(context, fontSize: 22),
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin JPS', style: bodyTextStyle(context)),
                    const SizedBox(height: 3),
                    Text(
                      '16 Jan, 2018',
                      style: bodyTextStyle(context).copyWith(color: hintGrey),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    SocmedIcon('assets/icons/instagram.svg', isMobile),
                    const SizedBox(width: 11),
                    SocmedIcon('assets/icons/tiktok.svg', isMobile),
                    const SizedBox(width: 11),
                    SocmedIcon('assets/icons/linkedin.svg', isMobile),
                    const SizedBox(width: 11),
                    SocmedIcon('assets/icons/facebook.svg', isMobile),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            if (selectedArticle.gambarArtikel != null &&
                selectedArticle.gambarArtikel!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  selectedArticle.gambarArtikel!,
                  height: 187,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (selectedArticle.gambarArtikel != null &&
                selectedArticle.gambarArtikel!.isNotEmpty)
              const SizedBox(height: 18),

            BlocBuilder<Berita3CariBloc, Berita3CariState>(
              builder: (context, contentState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      contentState.items.map<Widget>((section) {
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
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
