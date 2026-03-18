import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../blocs/regklaim/cobklaimcari_bloc.dart';
import '../../../../../common/constants.dart';
import '../../../../../common/loading_indicator.dart';
import '../../../../../models/regklaim/cobklaimcari_model.dart';
import '../cob_klaim_page/registrasi_klaim.dart';

class ButtonCobKlaimWidget extends StatefulWidget {
  const ButtonCobKlaimWidget({super.key});

  @override
  State<ButtonCobKlaimWidget> createState() => _ButtonCobKlaimWidgetState();
}

class _ButtonCobKlaimWidgetState extends State<ButtonCobKlaimWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CobklaimcariBloc>().add(RefreshCobklaimcariEvent());
  }

  String _iconPath(String id) {
    switch (id) {
      case "10001":
        return "assets/icons/properti.svg";
      case "10002":
        return "assets/icons/kendaraan.svg";
      case "10003":
        return "assets/icons/lainnya.svg";
      default:
        return "assets/icons/lainnya.svg";
    }
  }

  void _navigateByCob(BuildContext context, String cobId, String cobNama) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrasiKlaim(
          cobKlaimId: cobId,
          cobKlaimNama: cobNama,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CobklaimcariBloc, CobklaimcariState>(
      builder: (context, state) {
        if (state.status == ListStatus.initial) {
          return const SizedBox(
            height: 44,
            child: Align(
              alignment: Alignment.centerLeft,
              child: LoadingIndicator(),
            ),
          );
        }

        if (state.status == ListStatus.failure) {
          return const Text(
            "Gagal memuat data",
            style: TextStyle(color: Colors.red),
          );
        }

        if (state.status == ListStatus.success) {
          final items = state.items;

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            children: items.map((item) {
              final isSelected = state.selectedItem?.mcobklaim1Id == item.mcobklaim1Id;

              return Padding(
                padding: const EdgeInsets.only(bottom: hPadding ),
                child: _CobKlaimTile(
                  item: item,
                  iconPath: _iconPath(item.mcobklaim1Id),
                  isSelected: isSelected,
                  onTap: () {
                    context.read<CobklaimcariBloc>().add(
                      CobklaimcariItemSelectedEvent(selectedItem: item),
                    );

                    // ScaffoldMessenger.of(context)
                    //   ..hideCurrentSnackBar()
                    //   ..showSnackBar(
                    //     SnackBar(
                    //       content: Text('Kamu pilih: ${item.cobNama}'),
                    //       duration: const Duration(milliseconds: 800),
                    //     ),
                    //   );

                    _navigateByCob(context, item.mcobklaim1Id, item.cobNama);
                  },
                ),
              );
            }).toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _CobKlaimTile extends StatelessWidget {
  final CobklaimcariModel item;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const _CobKlaimTile({
    required this.item,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(cardBorderRadius),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: hPadding,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: pGrey,
            borderRadius: BorderRadius.circular(cardBorderRadius),
            border: Border.all(
              color: sGrey,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.cobNama,
                  style: TextStyle(
                    color: primaryLightColor,
                    fontSize: getResponsiveFont(context, 18),
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: primaryLightColor,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
