// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:joss_app/pages/payment/mobile/payment_page/payment_success/payment_success.dart';
//
// import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
// import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
// import '../../../../widgets/listpage_filter_bar_ui.dart';
// import '../../paymentmethodcari_list.dart';
// import '../../ringkasan/dnrekapcobcari_list_widget.dart';
// import '../payment_page/payment_process/payment_process.dart';
//
// class RincianPage extends StatefulWidget {
//   const RincianPage({super.key});
//
//   @override
//   State<RincianPage> createState() => _RincianPageState();
// }
//
// class _RincianPageState extends State<RincianPage> {
//   late DnrekapcobCariBloc dnrekapcobCariBloc;
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(const Duration(milliseconds: 500), () {
//       refreshData();
//     });
//   }
//
//   void refreshData() {
//     dnrekapcobCariBloc.add(RefreshDnrekapcobCariEvent());
//   }
//
//   IconButton buildSearchButton() {
//     return IconButton(
//       icon: const Icon(Icons.autorenew_rounded, size: 35.0),
//       onPressed: () {
//         dnrekapcobCariBloc.add(RefreshDnrekapcobCariEvent());
//       },
//     );
//   }
//
//   Widget buildList() {
//     return Column(
//       children: [
//         Expanded(
//           child: DnrekapcobCariListWidget(
//             searchText: _searchController.text,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     dnrekapcobCariBloc = BlocProvider.of<DnrekapcobCariBloc>(context);
//
//     return BlocListener<DnRekap2invBloc, DnRekap2invState>(
//       listener: (BuildContext context, DnRekap2invState state) {
//         if (state.isProcessed){
//           if (state.paymentStatus == "20"){
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.')),
//             );
//             onViewPaymentMethods();
//           }
//           else if (state.paymentStatus == "30"){
//             refreshData();
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Silakan lakukan pembayaran.')),
//             );
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => PaymentProcess(viewMode: "ubah", recordId: state.invoiceId)),
//             );
//           }
//           else if (state.paymentStatus == "40"){
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Proses pembayaran Berhasil.')),
//             );
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => PaymentSuccess()),
//             );
//           }
//           else if (state.paymentStatus == "91"){
//             refreshData();
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Proses pembayaran gagal. Silakan coba lagi.')),
//             );
//           }
//         }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("DN Rekap COB"),
//           elevation: 2,
//         ),
//         floatingActionButton: SpeedDial(
//           icon: Icons.menu,
//           activeIcon: Icons.close,
//           backgroundColor: Colors.blue,
//           children: [
//             SpeedDialChild(
//               child: Icon(Icons.add),
//               label: 'View Outstanding Polis',
//               onTap: () => onViewListOutstandingPolis(),
//             ),
//             SpeedDialChild(
//               child: Icon(Icons.payment),
//               label: 'Lanjut Pembayaran',
//               onTap: () {
//                 context.read<DnRekap2invBloc>().add(DnToInvByListCobProcessEvent(
//                   listCob: dnrekapcobCariBloc.state.selectedIds.join(";"),
//                 ));
//                 //onViewPaymentMethods();
//               },
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             ListPageFilterBarUIWidget(
//               searchController: _searchController,
//               searchButton: buildSearchButton(),
//             ),
//
//             Expanded(child: buildList()),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void onViewListOutstandingPolis() {
//     // Navigator.push(
//     //   context,
//     //   MaterialPageRoute(builder: (context) => DnsppaCariPage(listcobId: dnrekapcobCariBloc.state.selectedIds.join(";"), currId: '001')),
//     // ); // Implement your tambah data logic here
//   }
//
//   void onViewPaymentMethods() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PaymentMethodsCariListPage()),
//     ); // Implement your ta
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/payment_success/payment_success.dart';
import 'package:joss_app/pages/payment/mobile/rincian/rincian_tabel_page.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../widgets/listpage_filter_bar_ui.dart';
import '../payment_page/payment_method/paymentFormPage.dart';
import '../payment_page/payment_process/payment_process.dart';

class RincianPage extends StatefulWidget {
  const RincianPage({super.key});

  @override
  State<RincianPage> createState() => _RincianPageState();
}

class _RincianPageState extends State<RincianPage> {
  late DnRekap2invBloc dn2invBloc;
  late DnrekapcobCariBloc dnrekapcobCariBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dn2invBloc = context.read<DnRekap2invBloc>();
    dnrekapcobCariBloc = context.read<DnrekapcobCariBloc>();
    dn2invBloc.add(InitializeDnRekap2invEvent());
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshData();
    });
  }

  void refreshData() {
    dn2invBloc.add(GetRincianSOACustomerEvent(searchText: _searchController.text));
  }

  IconButton buildSearchButton() {
    return IconButton(
        icon: const Icon(
          Icons.autorenew_rounded,
          size: 35.0,
        ),
        onPressed: () {
          refreshData();
        });
  }

  void onViewPaymentMethods() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethods()),
    ); // Implement your ta
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: (BuildContext context, DnRekap2invState state) {
        if (state.isProcessed){
          if (state.paymentStatus == "20"){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan lanjutkan ke metode pembayaran.')),
            );
            onViewPaymentMethods();
          }
          else if (state.paymentStatus == "30"){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan lakukan pembayaran.')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentProcess(viewMode: "ubah", recordId: state.invoiceId)),
            );
          }
          else if (state.paymentStatus == "40"){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proses pembayaran Berhasil.')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentSuccess()),
            );
          }
          else if (state.paymentStatus == "91"){
            refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proses pembayaran gagal. Silakan coba lagi.')),
            );
          }
        }
      },
        child: BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
          builder: (context, state) {
            if (state.isProcessing) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: vPadding,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: hPadding * 1.5,
                      ),
                      child: ListPageFilterBarUIWidget(
                        searchController: _searchController,
                        searchButton: buildSearchButton(),
                      ),
                    ),

                    Expanded(
                      child: state.rincianSOAList.isEmpty
                          ? const Center(child: Text("Data kosong"))
                          : RincianTablePage(
                        headers: state.rincianSOAList,
                        selectedIds: state.selectedIds,
                        onSelect: (dn1Id) {
                          dn2invBloc.add(SelectDetailEvent(dn1Id));
                        },
                        onUnselect: (dn1Id) {
                          dn2invBloc.add(UnselectDetailEvent(dn1Id));
                        },
                      ),
                    ),
                  ],
                ),

                // 👉 FAB ala-Scaffold
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SpeedDial(
                      icon: Icons.menu,
                      activeIcon: Icons.close,
                      backgroundColor: Colors.blue,
                      children: [
                        SpeedDialChild(
                          child: const Icon(Icons.payment),
                          label: 'Lanjut Pembayaran',
                          onTap: () {
                            context.read<DnRekap2invBloc>().add(
                              DnToInvByListDnProcessEvent(
                                listDn: dn2invBloc.state.selectedIds.join(";"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }
}