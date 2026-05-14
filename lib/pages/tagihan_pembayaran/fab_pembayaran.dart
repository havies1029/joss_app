import 'package:flutter/material.dart';
import 'package:joss_app/pages/management_polis/floating_action_menu_widget.dart';

class FabPembayaran extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onBayarTap;
  final VoidCallback? onHubungiKeuTap;

  const FabPembayaran({
    super.key,
    required this.isEnabled,
    required this.onBayarTap,
    required this.onHubungiKeuTap,
  });

  @override
  Widget build(BuildContext context) {
    final actions = [
      ActionMenuItem(
        type: ActionType.bayar,
        label: "Bayar",
        iconAsset: "assets/icons/bayar.svg",
        gradientColors: const [Color(0xFFEF7A28), Color(0xFFFF9144)],
        borderColor: const Color(0xFFFF9144),
        isEnabled: isEnabled,
      ),
      ActionMenuItem(
        type: ActionType.hubungiJps,
        label: "Hubungi KEU",
        iconAsset: "assets/icons/cs_klaim.svg",
        gradientColors: const [Color(0xFFF69713), Color(0xFFFFF782)],
        borderColor: const Color(0xFFFFD06C),
        isEnabled: true,
      ),
    ];

    return Positioned(
      right: 16,
      bottom: 30,
      child: FloatingActionMenuWidget(
        availableActions: actions,
        selectedItems: const [],
        onActionTap: (type, _) {
          switch (type) {
            case ActionType.bayar:
              if (isEnabled) {
                onBayarTap?.call();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Pilih data terlebih dahulu")),
                );
              }
              break;

            case ActionType.hubungiJps:
              onHubungiKeuTap?.call();
              break;

            default:
              break;
          }
        },
      ),
    );
  }
}