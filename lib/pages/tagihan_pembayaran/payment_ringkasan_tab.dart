import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../payment/mobile/ringkasan/ringkasan_page.dart';
import '../payment/ringkasan/dnrekapcobcari_list.dart';


class PaymentRingkasanTab extends StatelessWidget {
  const PaymentRingkasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider(
    //       create: (_) => DnrekapcobCariBloc()..add(RefreshDnrekapcobCariEvent()),
    //     ),
    //     BlocProvider(
    //       create: (_) => DnRekap2invBloc(),
    //     ),
    //     BlocProvider(
    //       create: (_) => ShareDnrekapcobStateCubit(),
    //     ),
    //   ],
    // <<<<<<< HEAD
    //       child: const RincianSoaPage(),
    // =======
    //   child: const DnrekapcobCariPage(),
    // );

    return Scaffold(
      body: const RingkasanPage(),
    );
  }

}
