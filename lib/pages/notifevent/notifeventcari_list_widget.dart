import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/notifevent/notifeventcari_bloc.dart';
import 'package:joss_app/pages/notifevent/notifeventcari_tile_widget.dart';

class NotifeventcariListWidget extends StatefulWidget {
  const NotifeventcariListWidget({super.key});

  @override
  NotifeventcariListWidgetState createState() =>
      NotifeventcariListWidgetState();
}

class NotifeventcariListWidgetState extends State<NotifeventcariListWidget> {
  late NotifeventcariBloc notifeventcariBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    notifeventcariBloc = BlocProvider.of<NotifeventcariBloc>(context);

    return BlocConsumer<NotifeventcariBloc, NotifeventcariState>(
      listener: (context, state) {},
      builder: (context, state) {
        // loading awal
        if (state.status == ListStatus.initial && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // empty
        if (state.status == ListStatus.success && state.items.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Text(
                'No Data Available!!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        // data
        if (state.items.isNotEmpty) {

          return ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {

              final item = state.items[index];
              return NotifeventcariTileWidget(
                eventDesc: item.eventDesc,
                eventNama: item.eventNama,
                notifeventId: item.notifeventId,
              );
            },
          );
        }

        // fallback
        return const Center(
          child: Text(
            'No Data Available!!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
		if (_scrollController.position.pixels ==
				_scrollController.position.maxScrollExtent) {
			notifeventcariBloc.add(FetchNotifeventcariEvent());
		}
  }
}
