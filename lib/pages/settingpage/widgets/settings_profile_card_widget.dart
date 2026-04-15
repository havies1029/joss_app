import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:joss_app/common/loading_indicator.dart';

import '../../../blocs/profile/profile_download_foto_bloc.dart';
import '../../../common/constants.dart';

class SettingsProfileCardWidget extends StatelessWidget {
  final String nama;
  final String? email;
  final String? telepon;
  final String? subtitle;

  const SettingsProfileCardWidget({
    super.key,
    required this.nama,
    this.email,
    this.telepon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
      buildWhen: (prev, curr) =>
      curr is ProfileDownloadFotoLoaded ||
          curr is ProfileDownloadFotoLoading ||
          prev.runtimeType != curr.runtimeType,
      builder: (context, fotoState) {
        final bool isLoading = fotoState is ProfileDownloadFotoLoading;
        final Uint8List? foto =
        fotoState is ProfileDownloadFotoLoaded &&
            fotoState.imageBytes.isNotEmpty
            ? fotoState.imageBytes
            : null;

        return Container(
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardBorderRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryColor,
                primaryColor.withOpacity(0.6),
                primaryColor.withOpacity(0.4),
                primaryColor.withOpacity(0.2),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 0.75, 0.9, 1.0],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(hPadding + 6),
            decoration: BoxDecoration(
              color: pGrey,
              borderRadius: BorderRadius.circular(cardBorderRadius - 1.5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(
                  foto,
                  _initialsFromName(nama),
                  isLoading: isLoading,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: headingStyle(context, fontSize: 22),
                      ),
                      const SizedBox(height: 6),
                      if (subtitle != null && subtitle!.trim().isNotEmpty)
                        Text(
                          subtitle!,
                          style: bodyTextStyle(context).copyWith(
                            color: primaryLightColor,
                          ),
                        ),
                      const SizedBox(height: 8),
                      if (email != null && email!.trim().isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/email.svg",
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                primaryLightColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                email!,
                                style: bodyTextStyle(context, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 6),
                      if (telepon != null && telepon!.trim().isNotEmpty)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/telepon.svg",
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                primaryLightColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                telepon!.startsWith('+')
                                    ? telepon!
                                    : '+$telepon',
                                style: bodyTextStyle(context, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
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
      },
    );
  }

  Widget _buildAvatar(
      Uint8List? bytes,
      String initials, {
        bool isLoading = false,
      }) {
    final hasPhoto = bytes != null && bytes.isNotEmpty;
    return SizedBox(
      width: 46,
      height: 46,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: hasPhoto
                ? Image.memory(
              bytes,
              fit: BoxFit.cover,
              width: 46,
              height: 46,
              gaplessPlayback: true,
              filterQuality: FilterQuality.medium,
              errorBuilder: (_, __, ___) => _placeholderAvatar(),
            )
                : _placeholderAvatar(),
          ),
          if (isLoading)
            SizedBox(
              width: 46,
              height: 46,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                backgroundColor: Colors.transparent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _placeholderAvatar() => SvgPicture.asset(
    'assets/icons/place_holder_2.svg',
    width: 46,
    height: 46,
    fit: BoxFit.cover,
  );

  String _initialsFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';

    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.isNotEmpty && parts.first.isNotEmpty
        ? parts.first[0]
        : '';
    final last = parts.length > 1 && parts.last.isNotEmpty
        ? parts.last[0]
        : '';

    return (first + last).toUpperCase();
  }
}