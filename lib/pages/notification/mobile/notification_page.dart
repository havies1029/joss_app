import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../blocs/notifevent/notifeventcari_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/loading_indicator.dart';
import '../../../models/notifevent/notifeventcari_model.dart';
import '../../base/base_background_sidepage.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});
//
//   @override
//   State<NotificationPage> createState() => notificationPage();
// }
//
// class notificationPage extends State<NotificationPage> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     Future.delayed(const Duration(milliseconds: 300), () {
//       context.read<NotifeventcariBloc>().add(RefreshNotifeventcariEvent());
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController
//       ..removeListener(_onScroll)
//       ..dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (!_scrollController.hasClients) return;
//     final bloc = context.read<NotifeventcariBloc>();
//     final state = bloc.state;
//     if (state.hasReachedMax || state.isLoadingMore) return;
//     final maxScroll = _scrollController.position.maxScrollExtent;
//     final current = _scrollController.position.pixels;
//     if (current >= (maxScroll - 200)) {
//       bloc.add(FetchNotifeventcariEvent());
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NotifeventcariBloc, NotifeventcariState>(
//       builder: (context, state) {
//         final items = state.items;
//
//         return BaseBackgroundSidePage(
//           title: 'Notifikasi',
//           child: Container(
//             color: secondaryBlackColor,
//             padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//             child: _buildBody(context, state, items),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildBody(
//       BuildContext context,
//       NotifeventcariState state,
//       List<NotifeventcariModel> items,
//       ) {
//     if (state.status == ListStatus.initial && items.isEmpty) {
//       return const Center(child: LoadingIndicator());
//     }
//     if (items.isEmpty) {
//       return _centerContainer(context);
//     }
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: items.length + (state.isLoadingMore ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index >= items.length) {
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 16),
//             child: Center(child: LoadingIndicator()),
//           );
//         }
//         return _notificationItem(items[index]);
//       },
//     );
//   }
//
//   Widget _notificationItem(NotifeventcariModel item) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         horizontal: hPadding * 1.5,
//         vertical: hPadding,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SvgPicture.asset(
//             "assets/icons/notification-1.svg",
//             width: 40,
//             height: 40,
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.eventNama, // ambil dari model
//                   style: TextStyle(
//                     fontSize: getResponsiveFont(context, 18),
//                     color: primaryLightColor,
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   item.eventDesc, // ambil dari model
//                   style: TextStyle(
//                     fontSize: getResponsiveFont(context, 16),
//                     color: cGrey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _centerContainer(BuildContext context) {
//     return Expanded(
//       child: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SvgPicture.asset(
//               "assets/icons/notifikasi-2.svg",
//               height: 50,
//             ),
//             const SizedBox(height: 20),
//
//             Text(
//               "Tidak Ada Notifikasi",
//               style: TextStyle(
//                 fontSize: getResponsiveFont(context, 16),
//                 color: hintGrey,
//               ),
//             ),
//             const SizedBox(height: 6),
//
//             Text(
//               "Saat ini Anda belum menerima notifikasi apa pun.",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: getResponsiveFont(context, 14),
//                 color: hintGrey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/pages/notification/mobile/test_notification.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../blocs/notifevent/notifeventcari_bloc.dart';
import '../../../common/constants.dart';
import '../../../common/loading_indicator.dart';
import '../../../models/notifevent/notifeventcari_model.dart';
import '../../base/base_background_sidepage.dart';

class NotificationPage extends StatefulWidget {
  final VoidCallback? onUnreadChanged;

  const NotificationPage({
    super.key,
    this.onUnreadChanged,
  });

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, Timer> _visibilityTimers = {};
  final Set<String> _pendingReadKeys = {};

  List<NotifModel> items = [];
  bool isLoading = true;
  bool _isFlushingRead = false;

  @override
  void initState() {
    super.initState();
    _loadNotif();
  }

  String _keyOf(NotifModel item) {
    return '${item.notifType}_${item.notifeventId}';
  }

  Future<void> _loadNotif() async {
    final result = await NotifDummyHelper.getNotifications();

    if (!mounted) return;

    setState(() {
      items = result;
      isLoading = false;
    });
  }

  void _handleVisibility(NotifModel item, VisibilityInfo info) {
    if (item.isRead) return;

    final key = _keyOf(item);
    final visibleEnough = info.visibleFraction >= 0.7;

    if (visibleEnough) {
      _visibilityTimers[key] ??= Timer(
        const Duration(milliseconds: 700),
            () {
          if (!mounted) return;

          setState(() {
            _pendingReadKeys.add(key);
          });
        },
      );
    } else {
      _visibilityTimers[key]?.cancel();
      _visibilityTimers.remove(key);
    }
  }

  Future<void> _flushPendingRead() async {
    if (_isFlushingRead) return;

    final pendingItems = items.where((item) {
      final key = _keyOf(item);
      return _pendingReadKeys.contains(key) && !item.isRead;
    }).toList();

    if (pendingItems.isEmpty) return;

    _isFlushingRead = true;

    await NotifDummyHelper.markManyAsRead(pendingItems);

    if (!mounted) return;

    setState(() {
      for (final item in pendingItems) {
        item.isRead = true;
      }

      _pendingReadKeys.clear();
    });

    widget.onUnreadChanged?.call();

    _isFlushingRead = false;
  }

  Future<bool> _onWillPop() async {
    await _flushPendingRead();
    return true;
  }

  @override
  void dispose() {
    for (final timer in _visibilityTimers.values) {
      timer.cancel();
    }

    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BaseBackgroundSidePage(
        title: 'Notifikasi',
        onBack: () async {
          await _flushPendingRead();

          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        onHome: () async {
          await _flushPendingRead();

          if (context.mounted) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        child: Container(
          color: secondaryBlackColor,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: LoadingIndicator());
    }

    if (items.isEmpty) {
      return _centerContainer(context);
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return VisibilityDetector(
          key: Key('notif_${item.notifType}_${item.notifeventId}'),
          onVisibilityChanged: (info) {
            _handleVisibility(item, info);
          },
          child: _notificationItem(item),
        );
      },
    );
  }

  Widget _notificationItem(NotifModel item) {
    final key = _keyOf(item);
    final isPendingRead = _pendingReadKeys.contains(key);
    final visuallyRead = item.isRead || isPendingRead;

    return Opacity(
      opacity: visuallyRead ? 0.55 : 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: hPadding * 1.5,
          vertical: hPadding,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  "assets/icons/notification-1.svg",
                  width: 40,
                  height: 40,
                ),
                if (!visuallyRead)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
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
                      color: visuallyRead ? cGrey : primaryLightColor,
                      fontWeight:
                      visuallyRead ? FontWeight.normal : FontWeight.bold,
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