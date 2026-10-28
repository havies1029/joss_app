import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/polis_endors_history/polis_endors_history_bloc.dart';
import '../../../../common/constants.dart';
import '../../../../common/loading_indicator.dart';
import '../../../../models/polis_endors_history/polis_endors_history_model.dart';
import '../cob_polis/template_polis_table/detail_polis_table.dart';
import 'template_endors_table.dart';

class HistoryEndorsPopup extends StatefulWidget {
  final String title;
  final String polis2Id;
  final PolisEndorsHistoryCob cob;
  final List<DetailPolisColumn<PolisEndorsHistoryModel>> columns;

  const HistoryEndorsPopup({
    super.key,
    required this.title,
    required this.polis2Id,
    required this.cob,
    required this.columns,
  });

  @override
  State<HistoryEndorsPopup> createState() => _HistoryEndorsPopupState();
}

class _HistoryEndorsPopupState extends State<HistoryEndorsPopup> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    context.read<PolisEndorsHistoryBloc>().add(
          RefreshPolisEndorsHistoryEvent(
            cob: widget.cob,
            polis2Id: widget.polis2Id,
            searchText: _searchController.text,
          ),
        );
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 400), _refresh);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: screen.width < 600 ? 12 : 40,
        vertical: 24,
      ),
      backgroundColor: pGrey,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: sGrey),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 980,
          maxHeight: screen.height * 0.82,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            if (widget.cob.supportsPagination) _buildSearch(),
            Flexible(
              fit: FlexFit.loose,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  hPadding * 1.5,
                  hPadding,
                  hPadding * 1.5,
                  hPadding * 1.5,
                ),
                child: BlocBuilder<PolisEndorsHistoryBloc,
                    PolisEndorsHistoryState>(
                  builder: (context, state) {
                    if (state.status == ListStatus.initial ||
                        (state.isFetching && state.items.isEmpty)) {
                      return _statePanel(
                        const LoadingIndicator(),
                      );
                    }

                    if (state.status == ListStatus.failure &&
                        state.items.isEmpty) {
                      return _statePanel(
                        _messageState(
                          context,
                          state.errorMessage.isEmpty
                              ? 'Gagal memuat riwayat endorsement.'
                              : state.errorMessage.replaceFirst(
                                  'Exception: ',
                                  '',
                                ),
                          showRetry: true,
                        ),
                      );
                    }

                    if (state.items.isEmpty) {
                      return _statePanel(
                        _messageState(
                          context,
                          'Belum ada riwayat endorsement.',
                        ),
                      );
                    }

                    return Align(
                      alignment: Alignment.topCenter,
                      child: TemplateEndorsTable(
                        items: state.items,
                        columns: widget.columns,
                        isLoadingMore: state.isFetching,
                        onLoadMore: widget.cob.supportsPagination
                            ? () {
                                if (!state.hasReachedMax && !state.isFetching) {
                                  context.read<PolisEndorsHistoryBloc>().add(
                                        const FetchPolisEndorsHistoryEvent(),
                                      );
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 49,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 52),
            child: Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: bodyTextStyle(
                context,
                fontSize: getResponsiveFont(context, 16),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: 'Tutup',
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: primaryLightColor,
                size: 20,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Divider(height: 1, color: sGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        hPadding * 1.5,
        hPadding,
        hPadding * 1.5,
        0,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: const TextStyle(color: primaryLightColor, fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Cari riwayat endorsement',
          hintStyle: TextStyle(color: primaryLightColor.withOpacity(0.6)),
          prefixIcon: const Icon(Icons.search, color: primaryLightColor),
          suffixIcon: IconButton(
            tooltip: 'Muat ulang',
            onPressed: _refresh,
            icon: const Icon(
              Icons.autorenew_rounded,
              color: primaryLightColor,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: sGrey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: dBlue),
          ),
        ),
      ),
    );
  }

  Widget _statePanel(Widget child) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Center(child: child),
    );
  }

  Widget _messageState(
    BuildContext context,
    String message, {
    bool showRetry = false,
  }) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: bodyTextStyle(context, fontSize: 14).copyWith(
              color: primaryLightColor,
            ),
          ),
          if (showRetry) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ],
      ),
    );
  }
}
