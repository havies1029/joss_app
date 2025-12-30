import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:joss_app/widgets/listpage_filter_bar_ui.dart';
import '../../../../blocs/payment/dnrekap2inv_bloc.dart';
import '../../../../blocs/payment/dnrekapcobcari_bloc.dart';
import '../../../../blocs/share_cubit/share_dnrekapcob_state_cubit.dart';
import '../../../../common/constants.dart';
import '../../../asset_management/mobile/konfirmasi_detail_polis.dart';
import '../../invbayarvaform_form.dart';
import '../../paymentmethodcari_list.dart';
import '../../paymentsuccess_form.dart';
import 'payment_table_ringkasan_list.dart';

class DnrekapcobCariPage extends StatefulWidget {
  const DnrekapcobCariPage({super.key});

  @override
  State<DnrekapcobCariPage> createState() => _DnrekapcobCariPageState();
}

class _DnrekapcobCariPageState extends State<DnrekapcobCariPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), _refreshData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShareDnrekapcobStateCubit(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              ListPageFilterBarUIWidget(
                searchController: _searchController,
                searchButton: _buildSearchButton(),
              ),
              const SizedBox(height: 10),
              Expanded(child: _buildList()),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingButton(),
      ),
    );
  }

  Widget _buildList() {
    return PaymentRingkasanList(
      searchText: _searchController.text,
      showCheckbox: true,
    );
  }

  Widget _buildFloatingButton() {
    return BlocBuilder<ShareDnrekapcobStateCubit, Map<String, dynamic>>(
      builder: (context, selectedItems) {
        final hasSelection = selectedItems.isNotEmpty;

        return FloatingActionButton(
          onPressed: hasSelection ? () => _goToConfirmation(context) : null,
          backgroundColor: hasSelection ? primaryColor : unselectedColor,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14), // 👈 bikin kotak membulat
          ),
          child: SvgPicture.asset(
            'assets/icons/bayar.svg',
            width: 28,
            height: 28,
          ),
        );
      },
    );
  }
  void _goToConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const KonfirmasiDetailPolisPage(
          showPaymentButton: true,
        ),
      ),
    );
  }

  void _refreshData() {
    context.read<DnrekapcobCariBloc>().add(
      RefreshDnrekapcobCariEvent(),
    );
  }

  IconButton _buildSearchButton() {
    return IconButton(
      icon: const Icon(Icons.autorenew_rounded, size: 35),
      onPressed: _refreshData,
    );
  }
}
