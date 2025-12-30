import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../payment/mobile/ringkasan/payment_ringkasan_page.dart';

class PaymentRingkasanTab extends StatelessWidget {
  const PaymentRingkasanTab({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => DnrekapcobCariBloc()..add(RefreshDnrekapcobCariEvent()),
        ),
        BlocProvider(
          create: (_) => DnRekap2invBloc(),
        ),
        BlocProvider(
          create: (_) => ShareDnrekapcobStateCubit(),
        ),
      ],
      child: const DnrekapcobCariPage(),
    );
  }
}
