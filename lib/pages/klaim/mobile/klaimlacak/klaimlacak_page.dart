  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:joss_app/blocs/klaimlacak/klaimprogresscari_bloc.dart';
  import 'package:joss_app/common/constants.dart';

  import '../../../base/base_background_sidepage.dart';
import 'klaimlacak_detail/klaimlacak_list.dart';

  class KlaimLacakPage extends StatefulWidget {
    final String klaim1Id;
    final String statusDesc;

    const KlaimLacakPage({
      super.key,
      required this.klaim1Id,
      required this.statusDesc,
    });

    @override
    State<KlaimLacakPage> createState() => _KlaimLacakPageState();
  }

  class _KlaimLacakPageState extends State<KlaimLacakPage> {
    late final KlaimprogresscariBloc _klaimProgressCariBloc;

    @override
    void initState() {
      super.initState();

      _klaimProgressCariBloc = context.read<KlaimprogresscariBloc>();
      _refreshData();
    }

    @override
    Widget build(BuildContext context) {
      return BaseBackgroundSidePage(
        title: 'Lacak Klaim',
        child: Container(
          color: secondaryBlackColor,
          child: KlaimLacakList(
            klaim1Id: widget.klaim1Id,
            statusDesc: widget.statusDesc,
          ),
        ),
      );
    }

    void _refreshData() {
      _klaimProgressCariBloc.add(
        RefreshKlaimprogresscariEvent(
          klaim1Id: widget.klaim1Id,
        ),
      );
    }
  }
