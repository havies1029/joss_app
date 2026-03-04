import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_bloc.dart';
import 'package:joss_app/blocs/payment/paymentmethodcari_event.dart';
import 'package:joss_app/widgets/payment/bank_logo_widget.dart';
import 'package:joss_app/common/constants.dart';

class PaymentList extends StatelessWidget {
  final String categoryName;

  final List items;

  final bool isExpanded;
  final VoidCallback onTapHeader;
  final String iconPath;

  const PaymentList({
    super.key,
    required this.categoryName,
    required this.items,
    required this.isExpanded,
    required this.onTapHeader,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    final selectedId =
    context.select((PaymentMethodCariBloc b) => b.state.selectedMethodId);

    final sortedItems = [...items]..sort((a, b) {
      final sa = (a.sortOrder ?? 0) as int;
      final sb = (b.sortOrder ?? 0) as int;
      return sa.compareTo(sb);
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  categoryName,
                  style: bodyTextStyle(context),
                ),
              ],
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: Icon(
                Icons.expand_more,
                color: isExpanded ? primaryColor : sGrey,
              ),
            ),
            onTap: onTapHeader,
          ),
        ),
        if (isExpanded) ...[
          Divider(height: 1, thickness: 1, color: sGrey),
          Column(
            children: sortedItems.map<Widget>((item) {
              final bool isSelected = item.methodId == selectedId;

              return InkWell(
                onTap: () {
                  context
                      .read<PaymentMethodCariBloc>()
                      .add(PaymentSelectMethodEvent(item.methodId));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: hPadding * 1.5,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          buildBankLogo(
                            item.iconId,
                            item.iconUrl,
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: bodyTextStyle(context),
                            ),
                          ),
                          if (isSelected)
                            SvgPicture.asset(
                              'assets/icons/checklist2.svg',
                              width: 18,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(height: 1, thickness: 1, color: sGrey),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}