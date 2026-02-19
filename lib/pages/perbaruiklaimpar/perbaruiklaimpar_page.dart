import 'package:joss_app/blocs/perbaruiklaimmv/klaim5cari_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparaccordion_bloc.dart';
import 'package:joss_app/blocs/perbaruiklaimpar/klaimparklaimcrud_bloc.dart';
import 'package:joss_app/pages/perbaruiklaimmv/klaim5cari_list.dart';
import 'package:joss_app/pages/perbaruiklaimpar/klaimparaccordioncard.dart';
import 'package:joss_app/pages/perbaruiklaimpar/klaimparklaimcrud_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PerbaruiKlaimParPage extends StatefulWidget {
  final String cobGroupId;
  final String cobGroupNama;
  final String klaim1Id;
	const PerbaruiKlaimParPage({super.key, required this.klaim1Id, required this.cobGroupId, required this.cobGroupNama});

	@override
	PerbaruiKlaimParPageState createState() => PerbaruiKlaimParPageState();
}


class PerbaruiKlaimParPageState extends State<PerbaruiKlaimParPage> {

  @override
  Widget build(BuildContext context) {
    var klaimparklaimcrudBloc = BlocProvider.of<KlaimparklaimcrudBloc>(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.cobGroupNama)),
      body: BlocConsumer<KlaimparaccordionBloc, KlaimparaccordionState>(
        builder: (context, acc) {
          return Column(
            children: [
              // progress (contoh: hitung completion dari tiap bloc)
              Padding(
                padding: const EdgeInsets.all(16),
                child: BlocBuilder<KlaimparklaimcrudBloc, KlaimparklaimcrudState>(
                    builder: (_, klaim) => BlocBuilder<Klaim5cariBloc, Klaim5cariState>(
                          builder: (_, dok) {
                            final done = [
                              klaim.isComplete,
                              dok.isComplete,
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      
                      Klaimparaccordioncard(
                        title: 'Data Klaim',
                        isOpen: acc.openedIndex == 0,
                        onTap: () => context.read<KlaimparaccordionBloc>().add(KlaimparaccordionToggleEvent(index: 0)),
                        child: KlaimparklaimcrudFormPage(recordId:  widget.klaim1Id, viewMode: "ubah", cobGroupId: widget.cobGroupId),
                      ),
                      
                      Klaimparaccordioncard(
                        title: 'Dokumen Klaim',
                        isOpen: acc.openedIndex == 1,
                        onTap: () => context.read<KlaimparaccordionBloc>().add(KlaimparaccordionToggleEvent(index: 1)),
                        child: Klaim5cariPage(klaim1Id: widget.klaim1Id),
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
                          klaimparklaimcrudBloc.add(KlaimparklaimcrudAutoSaveEvent());
                          break;              
                      }
                    },
                    child: const Text('Perbarui Klaim'),
                  ),
                ),
              ),
            ],
          );
        }, listener: (BuildContext context, KlaimparaccordionState state) async { 
          if (state.previousIndex != null &&
            state.previousIndex != state.openedIndex) {

            FocusManager.instance.primaryFocus?.unfocus();
            await Future.delayed(const Duration(milliseconds: 50));

            switch(state.previousIndex) {
              case 0:
                klaimparklaimcrudBloc.add(KlaimparklaimcrudAutoSaveEvent());
                break;              
            }
          }
         },        
      ),
    );
  }
}
