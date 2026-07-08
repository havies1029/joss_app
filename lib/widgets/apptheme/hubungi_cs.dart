import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/layanan/mlayanan1cari_bloc.dart';
import '../../common/constants.dart';

class HubungiCs extends StatefulWidget {
  final String mlayanan1Id;
  final void Function(String noTelepon) onPilihLayanan;

  const HubungiCs({
    super.key,
    required this.mlayanan1Id,
    required this.onPilihLayanan,
  });

  @override
  State<HubungiCs> createState() => _HubungiCsState();
}

class _HubungiCsState extends State<HubungiCs> with TickerProviderStateMixin {
  Mlayanan1CariBloc? mlayanan1cariBloc;

  Future<void> _openLinkLayanan(String link) async {
    if (link.trim().isEmpty) return;

    final uri = Uri.parse(link.trim());

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint("Tidak bisa membuka link: $link");
    }
  }

  @override
  void initState() {
    super.initState();

    mlayanan1cariBloc = context.read<Mlayanan1CariBloc>();
    mlayanan1cariBloc?.add(
      FetchMlayanan1CariEvent(
        mlayanan1Id: widget.mlayanan1Id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.pop(context),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            decoration: const BoxDecoration(
              color: Color(0xFF262626),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHandle(),
                  const SizedBox(height: 26),

                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    alignment: Alignment.topCenter,
                    child: BlocBuilder<Mlayanan1CariBloc, Mlayanan1CariState>(
                      builder: (context, state) {
                        final isLoading =
                            state.status == ListStatus.initial &&
                                state.items.isEmpty;

                        if (isLoading) {
                          return const _LoadingContent();
                        }

                        if (state.items.isEmpty) {
                          return const _EmptyContent();
                        }

                        final data = state.items.first;
                        final layanan2 = data.mLayanan2;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.titleText,
                              style: const TextStyle(
                                color: primaryLightColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              data.descText,
                              style: const TextStyle(
                                color: Color(0xFFB8B8B8),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: vPadding),

                            ...layanan2.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: hPadding),
                                child: _ServiceItem(
                                  imagePath: "assets/icons/${item.logoLayanan}",
                                  title: item.namaLayanan,
                                  subtitle: item.descLayanan,
                                  onTap: () => _openLinkLayanan(item.linkLayanan),
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        width: 70,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(
        child: LoadingIndicator(),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      child: Center(
        child: Text(
          "Data layanan kosong",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ServiceItem({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(cardBorderRadius),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: anotherGrey,
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: hPadding),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: primaryLightColor,
                      fontSize: 18,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: hintGrey,
                      fontSize: 14,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFF00F36A),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Online",
                        style: TextStyle(
                          color: hintGrey,
                          fontSize: 13,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}