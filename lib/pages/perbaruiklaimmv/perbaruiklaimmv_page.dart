import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvbengkelcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvklaimcrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvpoliscrud_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimmv/klaimmvstatuscrud_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5cari_list.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvaccordioncard.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvbengkelcrud_form.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvklaimcrud_form.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvpoliscrud_form.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaimmvstatuscari_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerbaruiKlaimMvPage extends StatefulWidget {
  final String cobGroupNama;
  final String klaim1Id;
	const PerbaruiKlaimMvPage({super.key, required this.klaim1Id, required this.cobGroupNama});

	@override
	PerbaruiKlaimMvPageState createState() => PerbaruiKlaimMvPageState();
}


class PerbaruiKlaimMvPageState extends State<PerbaruiKlaimMvPage> {

  @override
  Widget build(BuildContext context) {
    var klaimmvpoliscrudBloc = BlocProvider.of<KlaimmvpoliscrudBloc>(context);
    var klaimmvklaimcrudBloc = BlocProvider.of<KlaimmvklaimcrudBloc>(context);
    var klaimmvbengkelcrudBloc = BlocProvider.of<KlaimmvbengkelcrudBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.cobGroupNama)),
      body: BlocConsumer<KlaimmvaccordionBloc, KlaimmvaccordionState>(
        builder: (context, acc) {
          return Column(
            children: [
              // progress (contoh: hitung completion dari tiap bloc)
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<KlaimmvpoliscrudBloc, KlaimmvpoliscrudState>(
                  builder: (_, polis) => BlocBuilder<KlaimmvklaimcrudBloc, KlaimmvklaimcrudState>(
                    builder: (_, klaim) => BlocBuilder<Klaim5cariBloc, Klaim5cariState>(
                      builder: (_, dok) => BlocBuilder<KlaimmvstatuscrudBloc, KlaimmvstatuscrudState>(
                        builder: (_, st) => BlocBuilder<KlaimmvbengkelcrudBloc, KlaimmvbengkelcrudState>(
                          builder: (_, beng) {
                            final done = [
                              polis.isComplete,
                              klaim.isComplete,
                              dok.isComplete,
                              st.isComplete,
                              beng.isComplete,
                            ].where((x) => x).length;

                            final progress = done / 5.0;

                            return Row(
                              children: [
                                Expanded(child: LinearProgressIndicator(value: progress)),
                                const SizedBox(width: 12),
                                Text('${(progress * 100).round()}%'),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Klaimmvaccordioncard(
                        title: 'Data Polis',
                        isOpen: acc.openedIndex == 0,
                        onTap: () => context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 0)),
                        child: KlaimmvpoliscrudFormPage(recordId: widget.klaim1Id, viewMode: "ubah"),
                      ),
                      
                      Klaimmvaccordioncard(
                        title: 'Data Klaim',
                        isOpen: acc.openedIndex == 1,
                        onTap: () => context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 1)),
                        child: KlaimmvklaimcrudFormPage(recordId:  widget.klaim1Id, viewMode: "ubah"),
                      ),
                      
                      Klaimmvaccordioncard(
                        title: 'Dokumen Klaim',
                        isOpen: acc.openedIndex == 2,
                        onTap: () => context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 2)),
                        child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
                      ),
                      
                      Klaimmvaccordioncard(
                        title: 'Kesimpulan Status Klaim',
                        isOpen: acc.openedIndex == 3,
                        onTap: () => context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 3)),
                        child: KlaimmvstatuscariPage(klaim1Id: widget.klaim1Id),
                      ),
                      
                      Klaimmvaccordioncard(
                        title: 'Bengkel yang dipilih',
                        isOpen: acc.openedIndex == 4,
                        onTap: () => context.read<KlaimmvaccordionBloc>().add(KlaimmvaccordionToggleEvent(index: 4)),
                        child: KlaimmvbengkelcrudFormPage(recordId: widget.klaim1Id, viewMode: "ubah"),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      switch(acc.openedIndex) {
                        case 0:
                          klaimmvpoliscrudBloc.add(KlaimmvPolisAutoSaveEvent());
                          break;
                        case 1:
                          klaimmvklaimcrudBloc.add(KlaimmvklaimAutoSaveEvent());
                          break;
                        case 4:
                          klaimmvbengkelcrudBloc.add(KlaimmvbengkelAutoSaveEvent());
                          break;
                      }
                    },
                    child: const Text('Perbarui Klaim'),
                  ),
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, KlaimmvaccordionState state) async {
          if (state.previousIndex != null &&
            state.previousIndex != state.openedIndex) {
            
            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 50));

            switch(state.previousIndex) {
              case 0:
                klaimmvpoliscrudBloc.add(KlaimmvPolisAutoSaveEvent());
                break;
              case 1:
                klaimmvklaimcrudBloc.add(KlaimmvklaimAutoSaveEvent());
                break;
              case 4:
                klaimmvbengkelcrudBloc.add(KlaimmvbengkelAutoSaveEvent());
                break;
            }

          }
         },        
      ),
    );
  }
}
