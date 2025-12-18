import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/payment/mobile/payment_page/paymetlist.dart';
import '../../../../blocs/payment/paymentmethodcari_bloc.dart';
import '../../../../blocs/payment/paymentmethodcari_event.dart';
import '../../../../blocs/payment/paymentmethodcari_state.dart';
import '../../../../common/constants.dart';
import '../../../base/base_background_sidepage.dart';

class PaymentMethodsCariListPage extends StatefulWidget {
  const PaymentMethodsCariListPage({super.key});

  @override
  State<PaymentMethodsCariListPage> createState() =>
      _PaymentMethodsCariListPageState();
}
class _PaymentMethodsCariListPageState
    extends State<PaymentMethodsCariListPage> {

  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodCariBloc>().add(
      PaymentMethodCariLoadEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackgroundSidePage(
      title: "Metode Pembayaran",
      child: Container(
        color: secondaryBlackColor,
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<PaymentMethodCariBloc, PaymentMethodCariState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }
                  if (state.hasError) {
                    return const Center(
                        child: Text("Failed to load data"));
                  }

                  return ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: hPadding),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final cat = state.categories[index];

                      return PaymentCategoryTile(
                        categoryName: cat.categoryName,
                        items: cat.items,
                        isExpanded: _expandedIndex == index,
                        onTapHeader: () {
                          setState(() {
                            _expandedIndex =
                            _expandedIndex == index ? null : index;
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
