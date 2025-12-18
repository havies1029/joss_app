import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../common/constants.dart';

class PaymentCategoryTile extends StatelessWidget {
  final String categoryName;
  final List items;
  final bool isExpanded;
  final VoidCallback onTapHeader;

  const PaymentCategoryTile({
    required this.categoryName,
    required this.items,
    required this.isExpanded,
    required this.onTapHeader,
  });

  @override
  Widget build(BuildContext context) {
    final selectedId =
    context.select((PaymentMethodCariBloc b) => b.state.selectedMethodId);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: pGrey,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        border: Border.all(color: sGrey),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: hPadding * 1.5),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(categoryName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SvgPicture.asset(
                        'assets/icons/checklist.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.expand_more,
                      color: isExpanded ? primaryColor : sGrey,
                    ),
                  ),
                ],
              ),
              onTap: onTapHeader,
            ),
          ),

          if (isExpanded) ...[
            Divider(height: 1, thickness: 1, color: sGrey),

            Column(
              children: items.map<Widget>((item) {
                final bool isSelected = item.methodId == selectedId;

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        context
                            .read<PaymentMethodCariBloc>()
                            .add(PaymentSelectMethodEvent(item.methodId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: hPadding * 1.5,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color:
                                  isSelected ? primaryColor : Colors.white,
                                ),
                              ),
                            ),

                            if (isSelected)
                              SvgPicture.asset(
                                'assets/icons/checklist2.svg',
                                width: 18,
                                height: 18,
                                color: primaryColor,
                              ),
                          ],
                        ),
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: sGrey,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}