import 'package:joss_app/blocs/payment/dnrekap2inv_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/pages/payment/invbayarvaform_form.dart';
import 'package:joss_app/pages/payment/paymentmethodcari_list.dart';
import 'package:joss_app/pages/payment/paymentsuccess_form.dart';
import 'package:joss_app/pages/payment/rinciansoa_widget.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class RincianSoaPage extends StatefulWidget {
  const RincianSoaPage({super.key});

  @override
  State<RincianSoaPage> createState() => _RincianSoaPageState();
}

class _RincianSoaPageState extends State<RincianSoaPage> {
  late DnRekap2invBloc dn2invBloc;
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
    dn2invBloc = BlocProvider.of<DnRekap2invBloc>(context);
    dnrekapcobCariBloc = BlocProvider.of<DnrekapcobCariBloc>(context);
    dn2invBloc.add(InitializeDnRekap2invEvent());
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
        appBar: AppBar(title: const Text("Rincian Outstanding per COB")),
        floatingActionButton: SpeedDial(
          icon: Icons.menu,
          activeIcon: Icons.close,
          backgroundColor: Colors.blue,
          children: [          
            SpeedDialChild(
              child: Icon(Icons.payment),
              label: 'Lanjut Pembayaran',
              onTap: () {
                context.read<DnRekap2invBloc>().add(DnToInvByListDnProcessEvent(
                  listDn: dn2invBloc.state.selectedIds.join(";"),
                ));
                //onViewPaymentMethods();
              },
            ),            
          ],
        ),
        body: BlocBuilder<DnRekap2invBloc, DnRekap2invState>(
          builder: (context, state) {
            if (state.isProcessing) {
              return const Center(child: CircularProgressIndicator());
            }         
      
            return Column(
              children: [
                ListPageFilterBarUIWidget(
                      searchController: _searchController,
                      searchButton: buildSearchButton()),
                Expanded(
                  child: state.rincianSOAList.isEmpty
                      ? const Center(child: Text("Data kosong"))
                      : RincianSoaWidget(
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
            );
          },
        ),
      ),
    );
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
      MaterialPageRoute(builder: (context) => PaymentMethodsCariListPage()),
    ); // Implement your ta    
  }    
  
}
