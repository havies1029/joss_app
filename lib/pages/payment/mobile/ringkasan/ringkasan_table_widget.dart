import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/blocs/payment/dnrekapcobcari_bloc.dart';
import 'package:joss_app/pages/payment/mobile/ringkasan/ringkasan_table_list.dart';

import '../../../../common/constants.dart';

class RingkasanTableWidget extends StatelessWidget {
  final String searchText;
  const RingkasanTableWidget({super.key, required this.searchText});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DnrekapcobCariBloc, DnrekapcobCariState>(
      builder: (context, state) {
        if (state.status != ListStatus.success) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.items.isEmpty) {
          return const Center(child: Text("Data kosong"));
        }

        return RingkasanTablePage(
          items: state.items,
          selectedIds: state.selectedIds.toSet(),
          onSelect: (id) {
            context.read<DnrekapcobCariBloc>()
                .add(ToggleSelectItemEvent(id));
          },
          onUnselect: (id) {
            context.read<DnrekapcobCariBloc>()
                .add(ToggleSelectItemEvent(id));
          },
        );
      },
    );
  }
}
