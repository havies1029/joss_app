  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';

  import '../../blocs/payment/dnrekapcobcari_bloc.dart';
  import '../../widgets/apptheme/empty_state_page.dart';
  import 'mobile/ringkasan/ringkasan_page.dart';
  import '../../../common/constants.dart';

  class PaymentRingkasanTab extends StatefulWidget {
    const PaymentRingkasanTab({super.key});

    @override
    State<PaymentRingkasanTab> createState() => _PaymentRingkasanTabState();
  }

  class _PaymentRingkasanTabState extends State<PaymentRingkasanTab> {
    bool hasData = true;

    @override
    Widget build(BuildContext context) {
      return MultiBlocListener(
        listeners: [
          BlocListener<DnrekapcobCariBloc, DnrekapcobCariState>(
            listener: (context, state) {
              if (state.status == ListStatus.failure) {
                setState(() {
                  hasData = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Gagal memuat data ringkasan'),
                  ),
                );
              }

              if (state.status == ListStatus.success) {
                setState(() {
                  hasData = state.items.isNotEmpty;
                });
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: secondaryBlackColor,
          body: hasData ? const RingkasanPage() : const _EmptyRingkasanView(),
        ),
      );
    }
  }

  class _EmptyRingkasanView extends StatelessWidget {
    const _EmptyRingkasanView();

    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        color: secondaryBlackColor,
        child: const Center(
          child: EmptyStatePage(
            iconPath: 'assets/icons/belipolis_no_file.svg',
            title: 'Tidak ada Tagihan Pembayaran',
            description: 'Ringkasan tagihan pembayaran akan muncul di sini ketika tersedia.',
          ),
        ),
      );
    }
  }