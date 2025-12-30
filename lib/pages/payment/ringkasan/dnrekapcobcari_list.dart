import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/pages/payment/ringkasan/detail/dnsppacari_list.dart';
import 'package:joss_app/pages/payment/invbayarvaform_form.dart';
import 'package:joss_app/pages/payment/paymentmethodcari_list.dart';
import 'package:joss_app/pages/payment/paymentsuccess_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/pages/payment/ringkasan/dnrekapcobcari_list_widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DnrekapcobCariPage extends StatefulWidget {
  const DnrekapcobCariPage({super.key});

  @override
  DnrekapcobCariPageState createState() => DnrekapcobCariPageState();
}

class DnrekapcobCariPageState extends State<DnrekapcobCariPage> {
  late DnrekapcobCariBloc dnrekapcobCariBloc;
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
    dnrekapcobCariBloc = BlocProvider.of<DnrekapcobCariBloc>(context);

    return BlocListener<DnRekap2invBloc, DnRekap2invState>(
      listener: (BuildContext context, DnRekap2invState state) {  
        if (state.isProcessed){
          if (state.paymentStatus == "20"){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proses pembayaran berhasil. Silakan lanjutkan ke metode pembayaran.')),
            );
            onViewPaymentMethods();
          } 
          else if (state.paymentStatus == "30"){
            refreshData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan lakukan pembayaran.')),
            );          
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InvbayarvaFormFormPage(viewMode: "ubah", recordId: state.invoiceId)),
            );
          }
          else if (state.paymentStatus == "40"){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Proses pembayaran Berhasil.')),
            );           
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentsuccessFormPage()),
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text("DN Rekap COB"),
          elevation: 2,        
        ),
        floatingActionButton: SpeedDial(
            icon: Icons.menu,
            activeIcon: Icons.close,
            backgroundColor: Colors.blue,
            children: [
              SpeedDialChild(
                child: Icon(Icons.add),
                label: 'View Outstanding Polis',
                onTap: () => onViewListOutstandingPolis(),
              ),
              SpeedDialChild(
                child: Icon(Icons.payment),
                label: 'Lanjut Pembayaran',
                onTap: () {
                  context.read<DnRekap2invBloc>().add(DnToInvByListCobProcessEvent(
                    listCob: dnrekapcobCariBloc.state.selectedIds.join(";"),
                  ));
                  //onViewPaymentMethods();
                },
              ),            
            ],
          ),
              body: Column(
          children: [
            ListPageFilterBarUIWidget(
              searchController: _searchController,
              searchButton: buildSearchButton(),
            ),
      
            Expanded(child: buildList()),
          ],
        ),
      ),
    );
  }

  void onViewListOutstandingPolis() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DnsppaCariPage(listcobId: dnrekapcobCariBloc.state.selectedIds.join(";"), currId: '001')),
    ); // Implement your tambah data logic here
  }

  void onViewPaymentMethods() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentMethodsCariListPage()),
    ); // Implement your ta    
  }    

  void refreshData() {
    dnrekapcobCariBloc.add(RefreshDnrekapcobCariEvent());
  }

  IconButton buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35.0),
      onPressed: () {
        dnrekapcobCariBloc.add(RefreshDnrekapcobCariEvent());
      },
    );
  }

  Widget buildList() {
    return Column(
      children: [
        Expanded(
          child: DnrekapcobCariListWidget(
            searchText: _searchController.text,
          ),
        ),
      ],
    );
  }


}
