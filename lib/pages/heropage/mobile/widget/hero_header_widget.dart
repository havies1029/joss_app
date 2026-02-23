import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:joss_app/common/constants.dart';

class HeroHeaderWidget extends StatelessWidget {
  final String userName;
  final Uint8List? imageBytes;
  final String? userImage;
  final String userType;

  const HeroHeaderWidget({
    super.key,
    required this.userName,
    this.imageBytes,
    this.userImage,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final hasBytes = imageBytes != null && imageBytes!.isNotEmpty;
    final String? src = userImage;

    Widget buildFromString(String? s) {
      if (s == null || s.isEmpty) return _avatarFallback();

      if (s.startsWith('http')) {
        return Image.network(
          s,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _avatarFallback(),
        );
      }

      return _avatarFallback();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding + 6),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child: ClipOval(
              child: hasBytes
                  ? Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.medium,
                      errorBuilder: (_, __, ___) => _avatarFallback(),
                    )
                  : buildFromString(src),
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

  Widget _avatarFallback() => Container(
        color: pGrey,
        child: const Icon(Icons.person, color: primaryLightColor, size: 25),
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