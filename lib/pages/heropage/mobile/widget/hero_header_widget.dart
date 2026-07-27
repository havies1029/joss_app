import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/common/constants.dart';

import '../../../../blocs/profile/profile_download_foto_bloc.dart';

class HeroHeaderWidget extends StatefulWidget {
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
  State<HeroHeaderWidget> createState() => _HeroHeaderWidgetState();
}

class _HeroHeaderWidgetState extends State<HeroHeaderWidget>
    with WidgetsBindingObserver {
  late String _greeting;
  Timer? _greetingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _greeting = _getGreeting();
    _scheduleGreetingRefresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _greetingTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshGreeting();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: hPadding + 6),
      child: Row(
        children: [
          SizedBox(
            width: 46,
            height: 46,
            child:
                BlocBuilder<ProfileDownloadFotoBloc, ProfileDownloadFotoState>(
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
                          : _buildFromString(widget.userImage),
                    ),
                    if (isLoading)
                      SizedBox(
                        width: 46,
                        height: 46,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(primaryColor),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          widget.userType != 'C'
              ? Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $_greeting',
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
                        'Halo, ${widget.userName}',
                        style: headingStyle(context, fontSize: 22),
                      ),
                      Text(
                        _greeting,
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

  void _refreshGreeting() {
    final nextGreeting = _getGreeting();

    if (mounted && nextGreeting != _greeting) {
      setState(() {
        _greeting = nextGreeting;
      });
    }

    _scheduleGreetingRefresh();
  }

  void _scheduleGreetingRefresh() {
    _greetingTimer?.cancel();
    _greetingTimer = Timer(_durationUntilNextGreeting(), _refreshGreeting);
  }

  Duration _durationUntilNextGreeting() {
    final now = DateTime.now();
    final next = _nextGreetingBoundary(now);
    final duration = next.difference(now);

    return duration.isNegative ? const Duration(minutes: 1) : duration;
  }

  DateTime _nextGreetingBoundary(DateTime now) {
    final boundaries = <DateTime>[
      DateTime(now.year, now.month, now.day, 4),
      DateTime(now.year, now.month, now.day, 11),
      DateTime(now.year, now.month, now.day, 15),
      DateTime(now.year, now.month, now.day, 18),
    ];

    for (final boundary in boundaries) {
      if (boundary.isAfter(now)) {
        return boundary;
      }
    }

    final tomorrow = now.add(const Duration(days: 1));
    return DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 4);
  }

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
