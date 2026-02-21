import 'package:joss_app/pages/regklaim/regklaim1crud_form.dart';
import 'package:joss_app/pages/regklaim/sppapoliscari_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/common/constants.dart';
import 'package:joss_app/blocs/regklaim/polissourcecari_bloc.dart';
import 'package:joss_app/models/regklaim/polissourcecari_model.dart';

class PolissourcecariListWidget extends StatefulWidget {
  final String cobKlaimId;  
  final String cobKlaimNama;
  const PolissourcecariListWidget({super.key, required this.cobKlaimId, required this.cobKlaimNama});

  @override
  PolissourcecariListWidgetState createState() =>
      PolissourcecariListWidgetState();
}

class PolissourcecariListWidgetState extends State<PolissourcecariListWidget> {
  late PolissourcecariBloc polissourcecariBloc;
  List<PolissourcecariModel> polissourcecari = [];
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    polissourcecariBloc = BlocProvider.of<PolissourcecariBloc>(context);

    return BlocConsumer<PolissourcecariBloc, PolissourcecariState>(
      buildWhen: (previous, current) => (current.status == ListStatus.success),
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == ListStatus.success) {
          if (!state.hasReachedMax) {
            polissourcecari.addAll(state.items);
          }

          return state.items.isNotEmpty
              ? Column(
                children: [
                  SizedBox(
                      height: 44,
                      child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: state.items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          final String id = (item.polissourceId).trim();
                          final bool isSelected = id.isNotEmpty && id == state.selectedPolissourceId;
                  
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
                              foregroundColor: isSelected ? Colors.white : Colors.black87,
                              elevation: isSelected ? 2 : 0,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if (id.isEmpty) return; // safety kalau id kosong
                  
                              polissourcecariBloc.add(
                                SelectPolissourcecariEvent(polissourceId: id),
                              );
                            },
                            child: Text(item.sourceNama),
                          );
                  
                        },
                      ),
                    ),
                    Expanded(
                      child: _buildBodyBySelected(state.selectedPolissourceId),
                    ),
                  ],
              )
              : const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      'No Data Available!!',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
        }

        return const Center(
          child: Text(
            'No Data Available!!',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      polissourcecariBloc.add(FetchPolissourcecariEvent());
    }
  }

  Widget _buildBodyBySelected(String id) {
    // ✅ mapping id -> page
    switch (id) {
      case '10': // contoh: Polis JPS
        return SppapoliscariPage(cobKlaimId: widget.cobKlaimId, cobKlaimNama: widget.cobKlaimNama); 

      case '20': // contoh: Bukan Polis JPS
        return Regklaim1CrudFormPage(cobKlaimId: widget.cobKlaimId, cobKlaimNama: widget.cobKlaimNama); 
        // return const RegklaimNonJpsListPage();

      default:
        return Regklaim1CrudFormPage(cobKlaimId: widget.cobKlaimId, cobKlaimNama: widget.cobKlaimNama);
    }
  }
}
