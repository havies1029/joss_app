import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/payment/dnsppacari_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/models/payment/dnsppacari_model.dart';

import 'ringkasan_detail_table_list.dart';
// import 'package:joss_app/pages/payment/mobile/ringkasan/detail/ringkasan_detail_table_list.dart';

class RingkasanDetailTableWidget extends StatefulWidget {
  const RingkasanDetailTableWidget({super.key});

  @override
  RingkasanDetailTableWidgetState createState() =>
      RingkasanDetailTableWidgetState();
}

class RingkasanDetailTableWidgetState
    extends State<RingkasanDetailTableWidget> {
  late DnsppaCariBloc dnsppaCariBloc;
  List<DnsppaCariModel> dnsppaCari = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  late String? curr;

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dnsppaCariBloc = BlocProvider.of<DnsppaCariBloc>(context);

    return BlocConsumer<DnsppaCariBloc, DnsppaCariState>(
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          if (state.items.isEmpty) {
            return const Center(child: Text("No Data Available!!"));
          }
          final items = state.items;
          final curr = items.isNotEmpty ? items.first.currSimbol : "";

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: RingkasanDetailTableList(
                    items: state.items,
                  ),
                ),
              ),
              _buildBottomButton(context, curr: curr),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
      listener: (context, state) {},
    );
  }

  Widget _buildBottomButton(BuildContext context, {required String curr}) {
    return AppButton.primary(
      text: "Lanjut Pembayaran",
      onPressed: () {
        final dnrekapcobCariBloc = context.read<DnrekapcobCariBloc>();

        if (dnrekapcobCariBloc.state.selectedIds.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            infoSnackBar("Pilih minimal satu COB terlebih dahulu"),
          );
          return;
        }

        context.read<DnRekap2invBloc>().add(
          DnToInvByListCobProcessEvent(
            listCob: dnrekapcobCariBloc.state.selectedIds.join(";"),
            curr: curr,
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      dnsppaCariBloc.add(FetchDnsppaCariEvent());
    }
  }
}
