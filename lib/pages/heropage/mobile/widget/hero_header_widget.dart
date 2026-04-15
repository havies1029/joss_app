import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/profile/profile_download_foto_bloc.dart';

class HeroHeaderWidget extends StatelessWidget {
  final String userName;
  final String? userImage;
  final String userType;

  const HeroHeaderWidget({
    super.key,
    required this.userName,
    this.userImage,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding + 6),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
              buildWhen: (prev, curr) =>
              curr is ProfileDownloadFotoLoaded ||
                  curr is ProfileDownloadFotoLoading ||
                  prev.runtimeType != curr.runtimeType,
              builder: (context, state) {
                final bool isLoading = state is ProfileDownloadFotoLoading;
                final bool hasBytes = state is ProfileDownloadFotoLoaded &&
                    state.imageBytes.isNotEmpty;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: hasBytes
                          ? Image.memory(
                        state.imageBytes,
                        fit: BoxFit.cover,
                        width: 46,
                        height: 46,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.medium,
                        errorBuilder: (_, __, ___) => _avatarFallback(),
                      )
                          : _buildFromString(userImage),
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
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          userType != 'C'
              ? Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${_getGreeting()}',
                  style: headingStyle(context, fontSize: 22),
                ),
              ],
            ),
          )
              : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $userName',
                  style: headingStyle(context, fontSize: 22),
                ),
                Text(
                  _getGreeting(),
                  style: bodyTextStyle(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFromString(String? s) {
    if (s == null || s.isEmpty) return _avatarFallback();

    if (s.startsWith('http')) {
      return Image.network(
        s,
        fit: BoxFit.cover,
        width: 46,
        height: 46,
        errorBuilder: (_, __, ___) => _avatarFallback(),
      );
    }

    return _avatarFallback();
  }

  Widget _avatarFallback() => SvgPicture.asset(
    'assets/icons/place_holder_2.svg',
    width: 46,
    height: 46,
    fit: BoxFit.contain,
  );

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 11) {
      return 'Selamat Pagi!';
    } else if (hour >= 11 && hour < 15) {
      return 'Selamat Siang!';
    } else if (hour >= 15 && hour < 18) {
      return 'Selamat Sore!';
    } else {
      return 'Selamat Malam!';
    }
  }
}