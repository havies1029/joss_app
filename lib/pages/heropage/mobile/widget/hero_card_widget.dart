import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/gen_profile/mrekan1crud_bloc.dart';
import 'hero_header_widget.dart';
import 'premi_polis_summary_widget.dart';

class HeroCardWidget extends StatefulWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;

  final String premiumAmount;
  final int polisCount;

  final VoidCallback? onDetailTap;
  final String userType;

  const HeroCardWidget({
    super.key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.premiumAmount,
    required this.polisCount,
    this.onDetailTap,
    required this.userType,
  });

  @override
  State<HeroCardWidget> createState() => _HeroCardWidgetState();
}

class _HeroCardWidgetState extends State<HeroCardWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MRekan1CrudBloc, MRekan1CrudState>(
      builder: (context, state) {
        final String mjenisClient = state.record?.mjnsclientId ?? '';

        final bool shouldShowPremi =
            widget.userType == 'C' && mjenisClient == '10';

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: hPadding + 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardBorderRadius * 2),
            gradient: primaryBlackGradient,
          ),
          child: Container(
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: secondaryBlackColor,
              borderRadius:
              BorderRadius.circular(cardBorderRadius * 2 - 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                HeroHeaderWidget(
                  userName: widget.userName,
                  userImage: widget.userImage,
                  userType: widget.userType,
                  imageBytes: widget.imageBytes,
                ),

                const SizedBox(height: 16),

                if (shouldShowPremi)
                  PremiPolisSummaryWidget(
                    userType: widget.userType,
                    onDetailTap: widget.onDetailTap,
                    mjnsclientId: mjenisClient,
                  ),

                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}