import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/payment_table_ringkasan_list.dart';
import '../../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';

class TablePaymentRingkasanWidget extends StatelessWidget {
  final String searchText;

  const TablePaymentRingkasanWidget({
    super.key,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Selection cubit (mirip ShareParStateCubit di Asset)
        BlocProvider(
          create: (_) => ShareDnrekapcobStateCubit(),
        ),
      ],
      child: PaymentRingkasanList(
        searchText: searchText,
        showCheckbox: true,
      ),
    );
  }
}
