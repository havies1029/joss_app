import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../blocs/notifevent/notifeventcari_bloc.dart';
import '../../../common/constants.dart';
import '../../../models/notifevent/notifeventcari_model.dart';
import '../../base/base_background_sidepage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => notificationPage();
}

class notificationPage extends State<NotificationPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<NotifeventcariBloc>().add(RefreshNotifeventcariEvent());
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifeventcariBloc, NotifeventcariState>(
      builder: (context, state) {
        final items = state.items;

        return BaseBackgroundSidePage(
          title: 'Notifikasi',
          child: Container(
            color: secondaryBlackColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: _buildBody(context, state, items),
          ),
        );
      },
    );
  }

  Widget _buildBody(
      BuildContext context,
      NotifeventcariState state,
      List<NotifeventcariModel> items,
      ) {
    if (state.status == ListStatus.initial && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (items.isEmpty) {
      return _centerContainer(context);
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return _notificationItem(items[index]);
      },
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
                  item.eventNama, // ambil dari model
                  style: TextStyle(
                    fontSize: getResponsiveFont(context, 18),
                    color: primaryLightColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.eventDesc, // ambil dari model
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
    return Expanded(
      child: Center(
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
      ),
    );
  }
}

