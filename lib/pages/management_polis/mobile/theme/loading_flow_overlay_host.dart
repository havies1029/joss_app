import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joss_app/pages/management_polis/mobile/theme/polis_full_page_loader.dart';

import '../../../../blocs/loading_flow/loading_flow_bloc.dart';

class LoadingFlowOverlayHost extends StatefulWidget {
  const LoadingFlowOverlayHost({
    super.key,
    required this.child,
    this.size = 36,
  });

  final Widget child;
  final double size;

  @override
  State<LoadingFlowOverlayHost> createState() => _LoadingFlowOverlayHostState();
}

class _LoadingFlowOverlayHostState extends State<LoadingFlowOverlayHost> {
  OverlayEntry? _entry;

  void _show() {
    if (_entry != null) return;

    _entry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: PolisFullPageLoaderOverlay(
          visible: true, // overlay entry cuma dibuat saat perlu tampil
          size: widget.size,
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  void _hide() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void dispose() {
    _hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoadingFlowBloc, LoadingFlowState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        final loading = state.status == LoadingFlowStatus.loading;
        if (loading) {
          _show();
        } else {
          _hide();
        }
      },
      child: widget.child,
    );
  }
}
