import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/common/loading_indicator.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';

import '../../../../../widgets/apptheme/register_client_pop_up.dart';
import 'ringkasan_detail_table_list.dart';

class RingkasanDetailTableWidget extends StatefulWidget {
  final String listcobId;

  const RingkasanDetailTableWidget({
    super.key,
    required this.listcobId,
  });

  @override
  RingkasanDetailTableWidgetState createState() =>
      RingkasanDetailTableWidgetState();
}

class RingkasanDetailTableWidgetState
    extends State<RingkasanDetailTableWidget> {
  late DnsppaCariBloc dnsppaCariBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dnsppaCariBloc = context.read<DnsppaCariBloc>();
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
    return BlocConsumer<DnsppaCariBloc, DnsppaCariState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: LoadingIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(child: Text("No Data Available!!"));
        }

        final List<DnsppaCariModel> items = state.items;
        final String curr = items.first.currSimbol;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: RingkasanDetailTableList(items: items),
              ),
            ),
            _buildBottomButton(context, curr: curr),
          ],
        );
      },
    );
  }

  Widget _buildBottomButton(BuildContext context, {required String curr}) {
    return AppButton.primary(
      text: "Lanjut Pembayaran",
      onPressed: () {
        final listCob = widget.listcobId.trim();

        if (listCob.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            infoSnackBar("Data COB tidak ditemukan"),
          );
          return;
        }

        // context.read<DnRekap2invBloc>().add(
        //   DnToInvByListCobProcessEvent(
        //     listCob: listCob,
        //     curr: curr,
        //   ),
        // );
        showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.6),
          builder: (dialogContext) => RegisterClientPopUp(
            showIcon: false,
            header: 'Fitur pembayaran belum tersedia.',
            description:
            'Saat ini aplikasi masih dalam mode Demo/Uji Coba. Pembayaran belum dapat dilakukan. Silahkan tunggu hingga aplikasi Go Live.',
            buttonText: 'Mengerti',
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      dnsppaCariBloc.add(FetchDnsppaCariEvent());
    }
  }
}