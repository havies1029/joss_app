// // pages/tagihan_pembayaran/payment_rincian_tab.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../blocs/payment/dnrekap2inv_bloc.dart';
// import '../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
// import '../../pages/payment/mobile/rincian/rincian_page.dart';
//
// class PaymentRincianTab extends StatelessWidget {
//   const PaymentRincianTab({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (_) => DnRekap2invBloc()
//             ..add( InitializeDnRekap2invEvent())
//             ..add(const GetRincianSOACustomerEvent(searchText: '')),
//         ),
//         BlocProvider(
//           create: (_) => ShareRincianStateCubit(),
//         ),
//       ],
//       child: const RincianSoaPage(),
//     );
//   }
// }
