import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../blocs/notif_read/notif_read_bloc.dart';
import '../../../blocs/notifevent/notifeventcari_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/loading_indicator.dart';
import '../../../models/notifevent/notifeventcari_model.dart';
import '../../base/base_background_sidepage.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, Timer> _visibilityTimers = {};
  final Set<String> _markedReadKeys = {};

  static const String _modulId = 'NOTIF';
  static const String _notifType = 'EVENT';
  List<NotifeventcariModel> _items = [];
  bool _hasReceivedResult = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<NotifeventcariBloc>().add(RefreshNotifeventcariEvent());
    });
  }

  String _keyOf(NotifeventcariModel item) {
    return item.notifeventId;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final bloc = context.read<NotifeventcariBloc>();
    final state = bloc.state;

    if (state.hasReachedMax || state.isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= (maxScroll - 200)) {
      bloc.add(FetchNotifeventcariEvent());
    }
  }

  void _handleVisibility(NotifeventcariModel item, VisibilityInfo info) {
    final key = _keyOf(item);

    if (_markedReadKeys.contains(key)) return;

    final visibleEnough = info.visibleFraction >= 0.7;

    if (visibleEnough) {
      _visibilityTimers[key] ??= Timer(
        const Duration(milliseconds: 700),
            () {
          if (!mounted) return;

          _markedReadKeys.add(key);

          context.read<NotifReadBloc>().add(
            MarkNotifReadEvent(
              modulId: _modulId,
              notifType: _notifType,
              notifId: item.notifeventId,
            ),
          );

          setState(() {});
        },
      );
    } else {
      _visibilityTimers[key]?.cancel();
      _visibilityTimers.remove(key);
    }
  }

  void _refreshUnreadCount() {
    context.read<NotifReadBloc>().add(RefreshNotifUnreadCountEvent());
  }

  @override
  void dispose() {
    for (final timer in _visibilityTimers.values) {
      timer.cancel();
    }

    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        _refreshUnreadCount();
        Navigator.pop(context);
      },
      child: BaseBackgroundSidePage(
        title: 'Notifikasi',
        onBack: () {
          _refreshUnreadCount();
          Navigator.pop(context);
        },
        onHome: () {
          _refreshUnreadCount();
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        child: Container(
          color: secondaryBlackColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: BlocConsumer<NotifeventcariBloc, NotifeventcariState>(
            listener: (context, state) {
              if (state.status == ListStatus.success) {
                setState(() {
                  _items = List<NotifeventcariModel>.from(state.items);
                  _hasReceivedResult = true;
                });
              }
            },
            builder: (context, state) {
              if (!_hasReceivedResult) {
                return const Center(child: LoadingIndicator());
              }

              if (_items.isEmpty) {
                return _centerContainer(context);
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: _items.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= _items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: LoadingIndicator()),
                    );
                  }

                  final item = _items[index];

                  return VisibilityDetector(
                    key: Key('notif_${item.notifeventId}'),
                    onVisibilityChanged: (info) {
                      _handleVisibility(item, info);
                    },
                    child: _notificationItem(item),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _notificationItem(NotifeventcariModel item) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: hPadding * 1.5,
        vertical: hPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            "assets/icons/notification-1.svg",
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.eventNama,
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    color: primaryLightColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.eventDesc,
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 16),
                    color: cGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerContainer(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/icons/notifikasi-2.svg",
            height: 50,
          ),
          const SizedBox(height: 20),
          Text(
            "Tidak Ada Notifikasi",
            style: TextStyle(
              fontSize: getResponsiveFont(context, 16),
              color: hintGrey,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Saat ini Anda belum menerima notifikasi apa pun.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: getResponsiveFont(context, 14),
              color: hintGrey,
            ),
          ),
        ],
      ),
    );
  }
}