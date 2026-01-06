import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/base/base_background_firstpage.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/detail/ringkasan_detail_table_widget.dart';

import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';

class RingkasanDetailPage extends StatefulWidget {
  final String listcobId;
  final String currId;
  const RingkasanDetailPage(
      {super.key, required this.listcobId, required this.currId});

  @override
  RingkasanDetailPageState createState() => RingkasanDetailPageState();
}

class RingkasanDetailPageState extends State<RingkasanDetailPage> {
  late DnsppaCariBloc dnsppaCariBloc;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    dnsppaCariBloc = BlocProvider.of<DnsppaCariBloc>(context);
    return BaseBackgroundSidePage(
      title: 'Konfirmasi Detail Polis',
      child: Container(
          color: secondaryBlackColor,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: RingkasanDetailTableWidget()),
    );
  }

  void refreshData() {
    dnsppaCariBloc.add(
      RefreshDnsppaCariEvent(
        listcobId: widget.listcobId,
        currId: widget.currId,
      ),
    );
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: () {
        dnsppaCariBloc.add(RefreshDnsppaCariEvent(
          listcobId: widget.listcobId,
          currId: widget.currId,
          searchText: _searchController.text,
        ));
      },
    );
  }
}
