import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';

import '../../../../../common/constants.dart';
import '../../../../base/base_background_sidepage.dart';
import 'ringkasan_detail_table_widget.dart';

class RingkasanDetailPage extends StatefulWidget {
  final String listcobId;
  final String currId;

  const RingkasanDetailPage({
    super.key,
    required this.listcobId,
    required this.currId,
  });

  @override
  RingkasanDetailPageState createState() => RingkasanDetailPageState();
}

class RingkasanDetailPageState extends State<RingkasanDetailPage> {
  late DnsppaCariBloc dnsppaCariBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dnsppaCariBloc = context.read<DnsppaCariBloc>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: 'Konfirmasi Detail Polis',
      child: Container(
        color: secondaryBlackColor,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: RingkasanDetailTableWidget(
          listcobId: widget.listcobId,
        ),
      ),
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
}